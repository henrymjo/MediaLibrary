//
//  AddMetadata.swift
//  MediaLibraryGUI
//
//  Created by Joseph McManamon on 10/1/18.
//  Copyright © 2018 Henry Morrison-Jones. All rights reserved.
//

import Cocoa

/**
 * Class specifies window contents so that new key/value pairs can be added to a file.
 */
class AddMetadata: NSViewController {

    // Stored properties
    var fileIndex: Int!
    var parentController: DisplayMetadata!
    var thisFile: MMFile!
    
    // Outlets
    @IBOutlet weak var keyField: NSTextField!
    @IBOutlet weak var valueField: NSTextField!

    /**
     * Instanties the correct file based on the fileIndex.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        thisFile = library.all()[fileIndex]
    }
    
    /**
     * Changes the window titles and stops it from being resizeable.
     */
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.title = "Add Data To \(thisFile.filename)"
        self.view.window?.styleMask.remove(.resizable)
    }
    
    // Actions
    /**
     * Adds a the new values from the NSTextFields to the file in the library. Then tells the
     * parentController to update its metadata and update its view of the table.
     * Then closes window.
     */
    @IBAction func addData(_ sender: NSButton) {
        
        // To add metadata from text fields and update the ParentController view
        library.add(file: thisFile, keyword: keyField.stringValue, value: valueField.stringValue)
        parentController.thisFile = library.all()[fileIndex]
        parentController.metadata = thisFile.metadata
        parentController.metadataTableView.insertRows(at: [(parentController.metadata.count - 1)], withAnimation: NSTableView.AnimationOptions.slideRight)        
        // Close
        self.view.window?.close()
    }
    /**
     *Closes window
     */
    @IBAction func cancelData(_ sender: NSButton) {
        self.view.window?.close()
    }
}
