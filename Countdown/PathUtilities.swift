//
//  PathUtilities.swift
//  Workbench
//
//  Created by Brent on 2016-12-08.
//  Copyright © 2016 Brent Marykuca. All rights reserved.
//

import Foundation

private var documentsFolderURL: URL! = {

    do {
        return try FileManager.default.url(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
    }
    catch {
        fatalError("Cannot get a reference to the documents folder.")
    }
} ()


public extension URL
{
    public static var appResources: URL
    {
        return Bundle.main.resourceURL!
    }
    
    public static var userCacheFolder: URL
    {
        do {
            return try FileManager.default.url(for: .cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
        }
        catch {
            fatalError("Cannot get a reference to the user's caches folder.")
        }
    }
    
    public static var userDocumentsFolder: URL
    {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
        }
        catch {
            fatalError("Cannot get a reference to the user's documents folder.")
        }
    }
        
    public static var appSupportFolder: URL
    {
        do {
            return try FileManager.default.url(for: .applicationSupportDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
        }
        catch {
            fatalError("Cannot get a reference to the application support folder.")
        }
    }
    
    
    public var parentFolder: URL
    {
        return self.appendingPathComponent("..") // Surprisingly, this works.
    }
    
    /// Returns true if the URL refers to a folder that exists.

    public var isFolder: Bool
    {
        // hasDirectoryPath returns true if a folder is a directory, or if it isn't a directory but the path looks
        // like a directory (i.e. ends with a /).
        
        guard self.hasDirectoryPath == true else {
            return false
        }
        
        return FileManager.default.fileExists(atPath: self.path, isDirectory: nil)
    }

    public var isFile: Bool
    {
        guard self.hasDirectoryPath == false else {
            return false
        }
        return FileManager.default.fileExists(atPath: self.path, isDirectory: nil)
    }
    
    /// Returns true if the URL refers to a file system object that exists
    public var isExisting: Bool
    {
        return FileManager.default.fileExists(atPath: self.path, isDirectory: nil)
    }
    
    public init(_ parent: URL, child: String)
    {
        let isFolder = child.hasSuffix("/")
        self.init(fileURLWithPath: child, isDirectory: isFolder, relativeTo: parent)
    }
    
    /// If the object that the URL refers to exists, do nothing. If the referenced object is a folder,
    /// create it and all necessary parent folders. If the referenced object is a file, then create
    /// the file's parent.
    ///
    public func ensureFoldersExist() throws
    {
        guard isExisting == false else {
            return
        }
        // Object does not exist
        if self.hasDirectoryPath
        {
            do {
                try FileManager.default.createDirectory(at: self, withIntermediateDirectories: true, attributes: nil)
            }
            catch let error
            {
                print(error)
                throw error
            }
        }
        else
        {
            try self.parentFolder.ensureFoldersExist()
        }
    }

    // Remove the item. If the item is a folder, remove all its contents too.
    public func removeItem()
    {
        do {
            try FileManager.default.removeItem(at: self)
        }
        catch let error
        {
            print(error)
        }
    }
    
    public func readJSON(options: JSONSerialization.ReadingOptions = []) -> Any? // really either Dictionary or Array
    {
        do {
            let data = try Data(contentsOf: self)
            let result = try JSONSerialization.jsonObject(with: data, options: options)
            return result
        }
        catch let error
        {
            print("Error in readJSON: \(error)")
            return nil
        }
    }
    
    public func readJSONDictionary(options: JSONSerialization.ReadingOptions = []) -> [String: Any]?
    {
        return readJSON(options: options) as? [String:Any]
    }
    
    public func writeJSON(dictionary: [String: Any], options: JSONSerialization.WritingOptions = [])
    {
        try! self.ensureFoldersExist()
        if let stream = OutputStream(url: self, append: false)
        {
            stream.open()
            var error: NSError?
            JSONSerialization.writeJSONObject(dictionary, to: stream, options: options, error: &error)
            stream.close()
        }
    }
}

