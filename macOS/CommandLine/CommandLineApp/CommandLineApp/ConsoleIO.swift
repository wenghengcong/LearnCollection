//
//  ConsoleIO.swift
//  CommandLineApp
//
//  Created by WengHengcong on 2019/2/28.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

import Foundation

enum OutputType {
    case error
    case standard
}

class ConsoleIO {
    
    func writeMessage(_ message: String, to: OutputType = .standard) {
        switch to {
        case .standard:
            print("\(message)")
        case .error:
            fputs("Error: \(message)\n", stderr)
        }
    }
    
    
    /// 输出
    func printUsage() {
        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
        
        writeMessage("usage:")
        writeMessage("\(executableName) -a string1 string2")
        writeMessage("or")
        writeMessage("\(executableName) -p string")
        writeMessage("or")
        writeMessage("\(executableName) -h to show usage information")
        writeMessage("Type \(executableName) without an option to enter interactive mode.")
    }
    
    
    /// 输入
    func getInput() -> String {
        // 1 获取输入流
        let keyboard = FileHandle.standardInput
        // 2 获取输入的数据
        let inputData = keyboard.availableData
        // 3 将获取的数据转换为字符串
        let strData = String(data: inputData, encoding: String.Encoding.utf8)!
        // 4 删除换行符
        return strData.trimmingCharacters(in: CharacterSet.newlines)
    }
}
