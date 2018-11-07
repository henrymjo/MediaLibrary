//
//  AppDelegate.swift
//  MediaLibraryGUI
//
//  Created by Henry Morrison-Jones on 26/09/18.
//  Copyright © 2018 Henry Morrison-Jones. All rights reserved.
//

import Cocoa

let library: Collection = Collection()
var last = MMResultSet()

// To help reference selected items in other windows. Usually get used on inialisation of the new window
var defaultMetadata:MMMetadata = Metadata.init(keyword: "Default key", value: "Default value")

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    


}

