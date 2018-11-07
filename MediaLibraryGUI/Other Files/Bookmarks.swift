//
//  Bookmarks.swift
//  MediaLibraryGUI
//
//  Created by Henry Morrison-Jones on 10/4/18.
//  Copyright © 2018 Henry Morrison-Jones. All rights reserved.
//

import Cocoa

/**
 * For identifying the different bookmark groups. Contains a list of files associated with that media type
 */
class Group: NSObject {
    let name: String
    var files: [MMFile]
    
    init(name:String){
        self.name = name
        self.files = []
    }
}
