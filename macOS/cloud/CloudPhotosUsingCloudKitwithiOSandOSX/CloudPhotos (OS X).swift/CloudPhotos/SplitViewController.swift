/*
Copyright (C) 2017 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This sample's split view managing both the master and detail view controllers.
*/

import Cocoa

class SplitViewController : NSSplitViewController, MasterViewControllerDelegate {
    @IBOutlet weak var MySplitView: NSSplitView!
    
    var masterViewController: MasterViewController!
    var detailViewController: DetailViewController!

    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Note: we keep the left split view item from growing as the window grows by setting its holding priority to 200,
        // and the right to 199. The view with the lowest priority will be the first to take on additional width if the
        // split view grows or shrinks.
        //
        MySplitView.adjustSubviews()

        masterViewController = splitViewItems[0].viewController as! MasterViewController
        masterViewController.delegate = self   // Listen for table view selection changes.
        
        detailViewController = splitViewItems[1].viewController as! DetailViewController
        
        // Make our master view controller adopt DetailViewControllerDelegate to listen for photo changes.
        detailViewController.detailViewDelegate = masterViewController
        
        detailViewController.detailItemRecord = nil // Start off with no selected photo.
        
        splitView.autosaveName = "SplitViewAutoSave"   // Remember the split view position.
    }

    // MARK: - MasterViewControllerDelegate
    
    func didChangePhotoSelection(masterViewController: MasterViewController, selection: Int) {
        if selection != -1 && selection != NSNotFound {
            // Find the photo that was selected and change the detail view controller to that photo.
            let photos = masterViewController.photoArrayController.arrangedObjects as! Array<AnyObject>
            let selectedPhoto = photos[selection] as! CloudPhoto
            detailViewController.detailItemRecord = selectedPhoto
        }
        else {
            detailViewController.detailItemRecord = nil // No photo found that was selected.
        }
    }
}
