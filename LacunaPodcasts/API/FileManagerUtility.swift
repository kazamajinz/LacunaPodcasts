//
//  FileManager.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-10.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import Foundation

struct FileManagerUtility {
    
    static func getDirectorySize(directory: URL, for key: FileAttributeKey) -> Int64? {

        let attributeDictionary = try? FileManager.default.attributesOfFileSystem(forPath: directory.path)
        
        if let size = attributeDictionary?[key] as? NSNumber {
            return size.int64Value
        } else { return nil }
    }
}
