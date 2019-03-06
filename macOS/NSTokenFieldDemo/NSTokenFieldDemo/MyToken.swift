//
//  MyToken.swift
//  NSTokenFieldDemo
//
//  Created by Hunt on 2019/3/6.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

import Foundation

class MyToken: NSObject, NSCoding {
    var name: String = ""
    
    override init() {
        super.init()
        name = ""
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
    }
}

