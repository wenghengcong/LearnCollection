/*
 Copyright (C) 2018 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller class for managing zones.
 */

import UIKit
import CloudKit

// ZoneViewController: present the zones in current iCloud container and manages zone deletion / creation.
// No conflicting handling is needed here because:
// a) Adding: add a new zone anyway so no conflict has to be considered
// b) Deleting: the zone to be deleted can be changed or deleted. In that case, CloudKit should return
// .zoneNotFound for .itemNotFound, which will be ignored in a deletion operation.
//
final class ZoneViewController: SpinnerViewController {
    
    private var zoneCacheOrNil: ZoneLocalCache? {
        return (UIApplication.shared.delegate as? AppDelegate)?.zoneCacheOrNil
    }

    private var topicCacheOrNil: TopicLocalCache? {
        return (UIApplication.shared.delegate as? AppDelegate)?.topicCacheOrNil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = editButtonItem
        clearsSelectionOnViewWillAppear = false

        NotificationCenter.default.addObserver(self, selector: #selector(type(of:self).zoneCacheDidChange(_:)),
                                               name: .zoneCacheDidChange, object: nil)
        // Start spinner animation.
        // ZoneCacheDidChange should come soon, which will stop the animation
        // if the local cache container is not ready, notification won't come though.
        //
        spinner.startAnimating()
    }
    
    // Set the tableview selected row based on the current ZoneLocalCache.
    //
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard zoneCacheOrNil != nil, let topicCache = topicCacheOrNil else { return }
        selectTableRow(database: topicCache.database, zone: topicCache.zone)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        UIView.transition(with: tableView, duration: 0.4, options: .transitionCrossDissolve,
                          animations: { self.tableView.reloadData() })
    }
    
    @IBAction func toggleZone(_ sender: AnyObject) {
        if let menuViewController = view.window?.rootViewController as? MenuViewController {
            menuViewController.toggleMenu()
        }
    }
}

extension ZoneViewController { // MARK: - Actions and handlers.
    
    // Notification is posted from main thread by cache class.
    //
    @objc func zoneCacheDidChange(_ notification: Notification) {
        // tableView.numberOfSections can be 0 when the app is entering foreground and the
        // account is unavaible. Simply reloadData in this case.
        //
        navigationItem.rightBarButtonItem?.isEnabled = (zoneCacheOrNil == nil) ? false : true
        spinner.stopAnimating()
        tableView.reloadData()
        
        guard let topicCache = topicCacheOrNil else { return }
        selectTableRow(database: topicCache.database, zone: topicCache.zone)
    }
    
    // Present an alert controller and add a new record zone with the specified name if users choose to do that.
    // This sample doesn't bother to validate the user input, but zone name must be unique in the datbase.
    //
    func addZone(at section: Int) {
        
        guard let zoneCache = zoneCacheOrNil else { fatalError("\(#function): zoneCache shouldn't be nil") }

        let alert = UIAlertController(title: "New Zone.", message: "Creating a new zone.", preferredStyle: .alert)
        alert.addTextField { textField -> Void in textField.placeholder = "Zone name must be unique!" }
        alert.addAction(UIAlertAction(title: "New Zone", style: .default) {_ in
            
            guard let zoneName = alert.textFields![0].text, zoneName.isEmpty == false else { return }
            
            self.spinner.startAnimating()
            let database = zoneCache.databases[section]
            zoneCache.addZone(with: zoneName, ownerName: CKCurrentUserDefaultName, to: database)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Select the row when zone is changed from outside this view controller.
    //
    func selectTableRow(database: CKDatabase, zone: CKRecordZone) {
        
        guard let zoneCache = zoneCacheOrNil else { fatalError("\(#function): zoneCache shouldn't be nil") }
        
        let result: (Int, Int)? = zoneCache.performReaderBlockAndWait {
            if let section = zoneCache.databases.index(where: { $0.cloudKitDB === database }),
                let row = zoneCache.databases[section].zones.index(where: { $0.zoneID == zone.zoneID }) {
                return (section, row)
            }
            return nil
        }
        
        guard let (section, row) = result else { return }
        
        let indexPath = IndexPath(row: row, section: section)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
    }
}

extension ZoneViewController { // MARK: - UITableViewDataSource and UITableViewDelegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let zoneCache = zoneCacheOrNil else { return 0 }
        return zoneCache.databases.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return zoneCacheOrNil?.databases[section].cloudKitDB.name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let zoneCache = zoneCacheOrNil else { return 0 }
        
        return zoneCache.performReaderBlockAndWait {
            if zoneCache.databases[section].cloudKitDB.databaseScope == .private {
                if isEditing {
                    return zoneCache.databases[section].zones.count + 1
                }
            }
            return zoneCache.databases[section].zones.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let zoneCache = zoneCacheOrNil else { fatalError("\(#function): zoneCache shouldn't be nil") }

        let cell = tableView.dequeueReusableCell(withIdentifier: TableCellReusableID.subTitle, for: indexPath)
        var labelText: String = "Add a zone"
        
        zoneCache.performReaderBlockAndWait {
            let database = zoneCache.databases[indexPath.section]

            if indexPath.row < database.zones.count {
                let zone = zoneCache.databases[indexPath.section].zones[indexPath.row]
                labelText = zone.zoneID.zoneName
            }
        }
        
        cell.textLabel?.text = labelText
        cell.detailTextLabel?.text = ""
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {

        guard let zoneCache = zoneCacheOrNil else { fatalError("\(#function): zoneCache shouldn't be nil") }

        return zoneCache.performReaderBlockAndWait {
            let database = zoneCache.databases[indexPath.section]
            return (database.zones.count == indexPath.row) ? .insert : .delete
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let zoneCache = zoneCacheOrNil else { fatalError("\(#function): zoneCache shouldn't be nil") }
        
        // Adding a zone doesn't have any race condition because the database is always there and/
        // the zone will be new.
        //
        if editingStyle == .insert {
            return addZone(at: indexPath.section)
        }
        spinner.startAnimating()

        // deleteZone -> .zoneCacheDidChange notification -> AppDelegate.zoneCacheDidChange -> Zone switching
        //
        zoneCache.performWriterBlock {
            let database = zoneCache.databases[indexPath.section]
            let zone = database.zones[indexPath.row]
            zoneCache.deleteZone(zone, from: database)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let zoneCache = zoneCacheOrNil else { fatalError("\(#function): zoneCache shouldn't be nil") }

        // Refresh the cache even the selected row is the current row
        // This is to provide a way to refresh the cache of the current zone.
        //
        guard let menuViewController = view.window?.rootViewController as? MenuViewController else { return }
        
        if let mainNC = menuViewController.mainViewController as? UINavigationController,
            let mainVC = mainNC.topViewController as? MainViewController {
            
            mainVC.view.bringSubview(toFront: mainVC.spinner)
            mainVC.spinner.startAnimating()
        }
        
        let (newDatabase, newZone): (Database, CKRecordZone) = zoneCache.performReaderBlockAndWait {
            let newDatabase = zoneCache.databases[indexPath.section]
            return (newDatabase, newDatabase.zones[indexPath.row])
        }
        
        let notificaitonObject = ZoneDidSwitch()
        notificaitonObject.payload = ZoneSwitched(database: newDatabase, zone: newZone)
        
        NotificationCenter.default.post(name: .zoneDidSwitch, object: notificaitonObject)

        menuViewController.toggleMenu() // Hide the zone view.
    }
}

