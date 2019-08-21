/*
 Copyright (C) 2018 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Base class for the view controllers in this sample.
 */

import UIKit
import CloudKit

// Use the TableView style name as the reusable ID.
// For a custom cell, use the class name.
//
struct TableCellReusableID {
    static let basic = "Basic"
    static let subTitle = "Subtitle"
    static let rightDetail = "Right Detail"
    static let textField = "TextFieldCell"
}

// Storybard ID constants.
//
struct StoryboardID {
    static let main = "Main"
    static let mainNC = "MainNC"
    static let zoneNC = "ZoneNC"
    static let note = "Note"
    static let noteNC = "NoteNC"
}

// Segue ID constants.
//
struct SegueID {
    static let mainAddNew = "AddNew"
}

struct AssetNames {
    static let menu = "menu24"
    static let add = "circleAdd36"
    static let cross = "circleCross36"
}

class SpinnerViewController: UITableViewController {
    
    lazy var spinner: UIActivityIndicatorView = {
        return UIActivityIndicatorView(activityIndicatorStyle: .gray)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.addSubview(spinner)
        tableView.bringSubview(toFront: spinner)
        spinner.hidesWhenStopped = true
        spinner.color = .blue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        spinner.center = CGPoint(x: tableView.frame.size.width / 2,
                                 y: tableView.frame.size.height / 2)
    }
}
