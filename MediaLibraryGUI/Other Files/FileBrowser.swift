//
//  FileBrowser.swift
//  MediaGUIApplication
//
//  Created by Joseph McManamon on 9/24/18.
//  Copyright © 2018 Joseph McManamon. All rights reserved.
//
//
import Foundation
import Cocoa

/**
 Possible crediting/referencing for this code?
 Opens up a panel that is either used for loading or saving files.
 */
extension NSOpenPanel {
    
    // For loading, we want to be able to load multiple, and the files must be of JSONs
    var selectUrls: [URL]? {
        title = "Select files"
        allowsMultipleSelection = true
        canChooseDirectories = false
        canChooseFiles = true
        canCreateDirectories = false
        allowedFileTypes = ["json"]  // only json
        return runModal() == .OK ? urls : nil
    }
    
    // For saving, we want to be able to select only one location and it must be a directory
    // (as the name is not currently able to be selected by the user)
    var saveFile: URL? {
        title = "Select file"
        allowsMultipleSelection = false
        canChooseDirectories = true
        canChooseFiles = false
        canCreateDirectories = true
        nameFieldStringValue = "default.json"
        allowedFileTypes = ["json"]
        return runModal() == .OK ? urls.first : nil
    }
}

