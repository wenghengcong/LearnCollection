import Foundation
import Swiftline
import ColorizeSwift
import CommandLineKit
let cli = CommandLineKit.CommandLine()
let dirPath = StringOption(shortFlag: "t", longFlag: "filetypes", helpMessage: "List all the types of files in current directory")
cli.addOptions(dirPath)
do {
    try cli.parse()
} catch {
    cli.printUsage(error)
}

var extensions = [String]() // Array to hold types of files present in the given directory
let fileManager = FileManager.default
let dirURL = URL(fileURLWithPath: dirPath.value!)
do {
    // fileURLs contains urls of all the files in the given directory
    let fileURLs = try fileManager.contentsOfDirectory(at: dirURL, includingPropertiesForKeys: nil)
    // Getting the unique file types
    for file in fileURLs {
        if !extensions.contains(file.pathExtension) {
            extensions.append(file.pathExtension)
        }
    }
    // To remove a empty string at the begining
    extensions.remove(at: 0)
    
    print("\n")
    print("Found \(extensions.count) types of files:".bold().blue())
    print("\n")
    print(extensions.joined(separator: " ").bold())
    print("\n")
    let fileType = ask("Choose the file type to be grouped into a folder...".bold().green())
    print("\n")
    let choice = agree("Are you sure you want to group files of type: \(fileType)?".bold().white().onRed())
    if(choice == true) {
        print("\n")
        let dirName = ask("Choose the folder name to store files of type: \(fileType)".bold().blue())
        print("\n")
        print("Grouping files by chosen filetype".bold().green())
        let baseDirPath = dirPath.value!
        let newDirPath = baseDirPath + dirName + "/"
        let _ = run("mkdir" ,args: newDirPath)
        var noOfFilesMoved = 0
        for file in fileURLs {
            if (file.pathExtension == fileType) {
                do {
                    try fileManager.moveItem(atPath:file.path, toPath: newDirPath+file.lastPathComponent)
                    noOfFilesMoved = noOfFilesMoved + 1
                }
                catch let error as NSError {
                    print("Ooops! Couldn't move the file: \(file.lastPathComponent) because of error: \(error)")
                }
            }
        }
        print("\n")
        print("Successfully moved \(noOfFilesMoved) no of files!".underline().bold().green())
    }
} catch {
    print("Error while enumerating files \(error.localizedDescription)")
}


