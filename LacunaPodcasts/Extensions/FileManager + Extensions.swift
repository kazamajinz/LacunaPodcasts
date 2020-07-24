//
//  FileManager + Extensions.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-14.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import Foundation

extension FileManager {
    static var documentDirectoryUrl: URL {
        `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

extension URL {
    func localFilePath() -> URL {
      return FileManager.documentDirectoryUrl.appendingPathComponent(self.lastPathComponent)
    }
}
