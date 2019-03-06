//
//  ViewController.swift
//  NSTokenFieldDemo
//
//  Created by Hunt on 2019/3/6.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

import Cocoa


// 学习https://www.cocoanetics.com/2013/05/tokenize-this/
class ViewController: NSViewController, NSTokenFieldDelegate {

    @IBOutlet weak var tokenField: NSTokenField!
    
    var allToken = ["alice", "ali", "bob", "bank", "tom", "tony", "weng", "good"]
    var matches: [String] = []
    
    
    /// 自定义菜单
    var customMenu: NSMenu?
    /// 可自定义菜单视图
    var customMenuView: NSView = NSView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tokenField.tokenStyle = .default
        tokenField.completionDelay = 0.2 // slow down auto completion a bit for type matching
        tokenField.delegate = self
        
        // 菜单
        customMenu = NSMenu(title: "Custom Menu")
        let menuItem = NSMenuItem(title: "Edit", action: #selector(editAction), keyEquivalent: "")
        menuItem.view = customMenuView
        customMenu?.addItem(menuItem)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // MARK: -样式
    /// style
    func tokenField(_ tokenField: NSTokenField, styleForRepresentedObject representedObject: Any) -> NSTokenField.TokenStyle {
        return NSTokenField.TokenStyle.squared
    }

    // MARK: - 校验
    // 返回一个校验通过的数组，只有在这个数组里面的才能显示，否则直接显示该数组里所有的内容
//    func tokenField(_ tokenField: NSTokenField, shouldAdd tokens: [Any], at index: Int) -> [Any] {
//        var validToken: [String] = []
//        for token in tokens {
//            // 校验
//        }
//        return validToken
//    }
    
    // MARK: - 自定义 Represented Objects
    /*
     Represented Objects
     If you use represented objects instead of the default strings, then you have to implement several delegate methods because the token field needs to convert between the object and what it should write on the token and what the editing value should be. From the NSTokenField.h header:
     
     // If you return nil or don't implement these delegate methods, we will assume
     // editing string = display string = represented object
     - (NSString *)tokenField:(NSTokenField *)tokenField displayStringForRepresentedObject:(id)representedObject;
     - (NSString *)tokenField:(NSTokenField *)tokenField editingStringForRepresentedObject:(id)representedObject;
     - (id)tokenField:(NSTokenField *)tokenField representedObjectForEditingString: (NSString *)editingString;
     You provide backing object for a given editing string. Conversely if the user double-clicks on a token this turns into editable text. Finally the display string is the inscription on the blue pills.
     
     For example if you have the token represent an email address, then the editing string could be “Oliver Drobnik <oliver@cocoanetics.com>” and the display string be just “Oliver Drobnik”. In that case you could have a token object class with a displayName and an email string.
     */
    // 双击选中对应的token后展示的文本，比如在邮箱app中，双击收件人「翁恒丛」，会展示完整的「翁恒丛 wenghengcong@icloud.com」
    //    Called 2nd, after you choose a choice from the menu list and press return.
    //
    //    The represented object must implement the NSCoding protocol.
    //    If your application uses some object other than an NSString for their represented objects,
    //    you should return a new instance of that object from this method.
    
    func tokenField(_ tokenField: NSTokenField, representedObjectForEditing editingString: String) -> Any? {
        let myToken = MyToken()
        myToken.name = editingString
        return myToken
    }
    
    //    Called 3rd, once the token is ready to be displayed.
    //
    //    If you return nil or do not implement this method, then representedObject
    //    is displayed as the string. The represented object must implement the NSCoding protocol.
    func tokenField(_ tokenField: NSTokenField, displayStringForRepresentedObject representedObject: Any) -> String? {
        // 获取所有的token
        print(tokenField.objectValue)
        var display = ""
        if representedObject is MyToken {
            display = (representedObject as! MyToken).name
        } else {
            display = representedObject as! String
        }
        return "dis:" + display
    }
    
//    func tokenField(_ tokenField: NSTokenField, editingStringForRepresentedObject representedObject: Any) -> String? {
//        var display = ""
//        if representedObject is MyToken {
//            display = (representedObject as! MyToken).name
//        } else {
//            display = representedObject as! String
//        }
//        return "edit:" + display
//    }
    
    // MARK: - Menu菜单
    /// 是否提供menu
//    func tokenField(_ tokenField: NSTokenField, hasMenuForRepresentedObject representedObject: Any) -> Bool {
//        return true
//    }
    
    /// 返回Menu
//    func tokenField(_ tokenField: NSTokenField, menuForRepresentedObject representedObject: Any) -> NSMenu? {
//        return customMenu
//    }
//
    
    // MARK: - 剪贴板
//    func tokenField(_ tokenField: NSTokenField, writeRepresentedObjects objects: [Any], to pboard: NSPasteboard) -> Bool {
//        return true
//    }
//
//    func tokenField(_ tokenField: NSTokenField, readFrom pboard: NSPasteboard) -> [Any]? {
//        return ["abc", "edf"]
//    }
//
    
    // MARK: - 智能提示
    /// 智能提示，自动完成。提供下拉菜单中的索引
    //    Called 1st, and again every time a completion delay finishes.
    //
    //    substring =        the partial string that to be completed.
    //    tokenIndex =    the index of the token being edited.
    //    selectedIndex = allows you to return by-reference an index in the array
    //                    specifying which of the completions should be initially selected.
    func tokenField(_ tokenField: NSTokenField, completionsForSubstring substring: String, indexOfToken tokenIndex: Int, indexOfSelectedItem selectedIndex: UnsafeMutablePointer<Int>?) -> [Any]? {
        matches = (allToken as NSArray).filtered(using: NSPredicate(format: "SELF beginswith[cd] %@", substring)) as! [String]
        return matches
    }
    
    
    @IBAction func tokenFieldAction(_ sender: Any) {
        
        
    }
    
    
}

extension ViewController {
    @objc func delAction()  {
        
    }
    @objc func editAction()  {
        
    }
}

