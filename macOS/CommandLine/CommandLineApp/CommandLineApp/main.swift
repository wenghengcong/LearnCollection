//
//  main.swift
//  CommandLineApp
//
//  Created by WengHengcong on 2019/2/28.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

import Foundation

let panagram = Panagram()
//panagram.staticMode()

if CommandLine.argc < 2 {
    panagram.interactiveMode()
} else {
    panagram.staticMode()
}
