/*
 Chapter - 12
 File Handling in iOS
 */

import UIKit

let bundlePath = Bundle.main.bundlePath
        print(bundlePath)
        let infoFilePath = Bundle.main.path(forResource: "Info", ofType: "plist")
        print(infoFilePath)

protocol AppFileStatusChecking
{
    func isWritable(file at: URL) -> Bool
    
    func isReadable(file at: URL) -> Bool
    
    func exists(file at: URL) -> Bool
}


extension AppFileStatusChecking
{
    func isWritable(file at: URL) -> Bool
    {
        if FileManager.default.isWritableFile(atPath: at.path)
        {
            print(at.path)
            return true
        }
        else
        {
            print(at.path)
            return false
        }
    }
    
    func isReadable(file at: URL) -> Bool
    {
        if FileManager.default.isReadableFile(atPath: at.path)
        {
            print(at.path)
            return true
        }
        else
        {
            print(at.path)
            return false
        }
    }
    
    func exists(file at: URL) -> Bool
    {
        if FileManager.default.fileExists(atPath: at.path)
        {
            return true
        }
        else
        {
            return false
        }
    }
}


protocol AppFileSystemMetaData
{
    func list(directory at: URL) -> Bool
    
    func attributes(ofFile atFullPath: URL) -> [FileAttributeKey : Any]
}
 
extension AppFileSystemMetaData
{
    func list(directory at: URL) -> Bool
    {
        let listing = try! FileManager.default.contentsOfDirectory(atPath: at.path)
        
        if listing.count > 0
        {
            print("\n----------------------------")
            print("LISTING: \(at.path)")
            print("")
            for file in listing
            {
                print("File: \(file.debugDescription)")
            }
            print("")
            print("----------------------------\n")
            
            return true
        }
        else
        {
            return false
        }
    }
    
    func attributes(ofFile atFullPath: URL) -> [FileAttributeKey : Any]
    {
        return try! FileManager.default.attributesOfItem(atPath: atFullPath.path)
    }
}


enum AppDirectories : String
{
    case Documents = "Documents"
    case Inbox = "Inbox"
    case Library = "Library"
    case Temp = "tmp"
}
 
protocol AppDirectoryNames
{
    func documentsDirectoryURL() -> URL
    func inboxDirectoryURL() -> URL
    func libraryDirectoryURL() -> URL
    func tempDirectoryURL() -> URL
    func getURL(for directory: AppDirectories) -> URL
    func buildFullPath(forFileName name: String, inDirectory directory: AppDirectories) -> URL
}


extension AppDirectoryNames
{
    func documentsDirectoryURL() -> URL
    {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func inboxDirectoryURL() -> URL
    {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(AppDirectories.Inbox.rawValue)
    }
    
    func libraryDirectoryURL() -> URL
    {
        return FileManager.default.urls(for: FileManager.SearchPathDirectory.libraryDirectory, in: .userDomainMask).first!
    }
    
    func tempDirectoryURL() -> URL
    {
        return FileManager.default.temporaryDirectory
    }
    
    func getURL(for directory: AppDirectories) -> URL
    {
        switch directory
        {
        case .Documents:
            return documentsDirectoryURL()
        case .Inbox:
            return inboxDirectoryURL()
        case .Library:
            return libraryDirectoryURL()
        case .Temp:
            return tempDirectoryURL()
        }
    }
    
    func buildFullPath(forFileName name: String, inDirectory directory: AppDirectories) -> URL
    {
        return getURL(for: directory).appendingPathComponent(name)
    }
 }


protocol AppFileManipulation : AppDirectoryNames
{
    func writeFile(containing: String, to path: AppDirectories, withName name: String) -> Bool
    func readFile(at path: AppDirectories, withName name: String) -> String
    func deleteFile(at path: AppDirectories, withName name: String) -> Bool
    
    func renameFile(at path: AppDirectories, with oldName: String, to newName: String) -> Bool
    func moveFile(withName name: String, inDirectory: AppDirectories, toDirectory directory: AppDirectories) -> Bool
    func copyFile(withName name: String, inDirectory: AppDirectories, toDirectory directory: AppDirectories) -> Bool
    func changeFileExtension(withName name: String, inDirectory: AppDirectories, toNewExtension newExtension: String) -> Bool
}


extension AppFileManipulation
{
    func writeFile(containing: String, to path: AppDirectories, withName name: String) -> Bool
    {
        let filePath = getURL(for: path).path + "/" + name
        let rawData: Data? = containing.data(using: .utf8)
        return FileManager.default.createFile(atPath: filePath, contents: rawData, attributes: nil)
    }
    
    func writeFile(containing: Data, to path: AppDirectories, withName name: String) -> Bool
    {
        let filePath = getURL(for: path).path + "/" + name
        return FileManager.default.createFile(atPath: filePath, contents: containing, attributes: nil)
    }
 
    func writeFileIn(folder: String, containing: Data, to path: AppDirectories, withName name: String) -> Bool
    {
        let filePath = getURL(for: path).path + "/" + folder + "/" + name
        let fileManager = FileManager.default
        if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath =  tDocumentDirectory.appendingPathComponent("\(folder)")
            if !fileManager.fileExists(atPath: filePath.path) {
                do {
                    try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    NSLog("Couldn't create document directory")
                }
            }
            NSLog("Document directory is \(filePath)")
        }
        return FileManager.default.createFile(atPath: filePath, contents: containing, attributes: nil)
     }
 
    func readFile(at path: AppDirectories, withName name: String) -> String
    {
        let filePath = getURL(for: path).path + "/" + name
        let fileContents = FileManager.default.contents(atPath: filePath)
        let fileContentsAsString = String(bytes: fileContents!, encoding: .utf8)
        print(fileContentsAsString!)
        return fileContentsAsString!
    }
    
    func deleteFile(at path: AppDirectories, withName name: String) -> Bool
    {
        let filePath = buildFullPath(forFileName: name, inDirectory: path)
        do
        {
            try FileManager.default.removeItem(at: filePath)
            return true
        }
        catch
        {
            print(error)
        }
        return false
    }
    
   func renameFile(at path: AppDirectories, with oldName: String, to newName: String) -> Bool
    {
        let oldPath = getURL(for: path).appendingPathComponent(oldName)
        let newPath = getURL(for: path).appendingPathComponent(newName)
        do {
            try FileManager.default.moveItem(at: oldPath, to: newPath)
            return true
        } catch {
            return false
        }
    }
    
    func moveFile(withName name: String, inDirectory: AppDirectories, toDirectory directory: AppDirectories) -> Bool
    {
        let originURL = buildFullPath(forFileName: name, inDirectory: inDirectory)
        let destinationURL = buildFullPath(forFileName: name, inDirectory: directory)
        try! FileManager.default.moveItem(at: originURL, to: destinationURL)
        return true
    }
    
    func copyFile(withName name: String, inDirectory: AppDirectories, toDirectory directory: AppDirectories) -> Bool
    {
        let originURL = buildFullPath(forFileName: name, inDirectory: inDirectory)
        let destinationURL = buildFullPath(forFileName: name+"1", inDirectory: directory)
        try! FileManager.default.copyItem(at: originURL, to: destinationURL)
        return true
    }
    
    func changeFileExtension(withName name: String, inDirectory: AppDirectories, toNewExtension newExtension: String) -> Bool
    {
        var newFileName = NSString(string:name)
        newFileName = newFileName.deletingPathExtension as NSString
        newFileName = (newFileName.appendingPathExtension(newExtension) as NSString?)!
        let finalFileName:String =  String(newFileName)
        
        let originURL = buildFullPath(forFileName: name, inDirectory: inDirectory)
        let destinationURL = buildFullPath(forFileName: finalFileName, inDirectory: inDirectory)
        
        try! FileManager.default.moveItem(at: originURL, to: destinationURL)
        
        return true
    }
}


class AppFileManager: NSObject, AppFileStatusChecking, AppFileManipulation, AppFileSystemMetaData
{
    static let sharedInstance: AppFileManager = {
        let instance = AppFileManager()
        return instance
    }()
    
    override init() {
        super.init()
    }
    
    func savefile(folder: String, fileName: String, image: Data) -> Bool
        {
            if folder == ""
            {
                return writeFile(containing: image, to: .Documents, withName: fileName)
            }
            
            return writeFileIn(folder: folder, containing: image, to: .Documents, withName: fileName)
        }

    func fileExist(folder: String, file: String) -> Bool
        {
            return exists(file: buildFullPath(forFileName: file, inDirectory: .Documents))
        }
     
    func deleteFile(folder: String, fileName: String) -> Bool
        {
            let filePath = buildFullPath(forFileName: fileName, inDirectory: .Documents)
            if fileExist(folder: folder, file: fileName)
            {
                do
                {
                    try FileManager.default.removeItem(at: filePath)
                    return true
                }
                catch
                {
                    print(error)
                }
            }
            return false
        }

    func getFileList() -> [String]
        {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            do {
                // Get the directory contents urls (including subfolders urls)
                let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
                print(directoryContents)
                
                // if you want to filter the directory contents you can do like this:
                var pdfList = directoryContents.filter{ $0.pathExtension == "pdf"} as [URL]
                let txtList = directoryContents.filter{ $0.pathExtension == "txt"} as [URL]
                let csvList = directoryContents.filter{ $0.pathExtension == "csv"} as [URL]
                let gpxList = directoryContents.filter{ $0.pathExtension == "gpx"} as [URL]
                pdfList.append(contentsOf: txtList)
                pdfList.append(contentsOf: csvList)
                pdfList.append(contentsOf: gpxList)
                var fileList: [String] = []
                for item in pdfList {
                    let str = item.absoluteString.components(separatedBy: "/")
                    fileList.append(str.last!)
                }
                print("PDF list:", fileList)
                return fileList
                
            } catch {
                print(error.localizedDescription)
            }
            return []
        }
    

}

