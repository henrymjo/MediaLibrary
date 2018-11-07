//
//  DisplayMetadata.swift
//  MediaLibraryGUI
//
//  Created by Joseph McManamon on 10/1/18.
//  Copyright © 2018 Henry Morrison-Jones. All rights reserved.
//

import Cocoa


/**
 * View controller for the viewing/editing of metadata. Some stored properties are instantiateted in the
 * ParentController (ViewController.swift) so that the window knows what file the metadata belongs to and
 * where it lies in the library.
 */
class DisplayMetadata: NSViewController {
    
    // Stored properties
    var metadata: [MMMetadata]!
    var thisFile: MMFile!
    var fileIndex: Int!
    
    // Outlets
    @IBOutlet weak var metadataTableView: NSTableView!
    
    

    /**
     * Initialises the file to be edited using the fileIndex and instatiates the metadata property
     * A delegate and datasource are assigned so that the metadataTableView has reference to what it is
     * populating its table with
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        thisFile = library.all()[fileIndex]
        metadata = thisFile.metadata
        
        // Delegate and data source
        self.metadataTableView.delegate = self
        self.metadataTableView.dataSource = self
        
    }
    
    
    /**
     * Sets the window name and prevents the window from resizing
     */
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.title = "Metadata For \(thisFile.filename)"
        self.view.window?.styleMask.remove(.resizable)
    }
    
    
    /**
     * Action event when the + button is pressed, instantiates and new view controller (AddMetadata.swift)
     * and gives it a reference to itself so that the subview can update the table as new metadata values are
     * added.
     */
    @IBAction func addMetadata(_ sender: NSButton) {
            let addMetadataViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("AddMetadataView")) as? AddMetadata
            addMetadataViewController?.fileIndex = fileIndex
            addMetadataViewController?.parentController = self
            let newWindow = NSWindow(contentViewController: addMetadataViewController!)
            let controller = MetadataAddContoller(window: newWindow)
            controller.showWindow(self)
    }
    /**
     * Removes the metadata at the selected row in the table. This index is used to first delete the metadata
     * in the library and then uses the removeRows function to update the metadataTableView (so you don't
     * have to reload the window).
     */
    @IBAction func removeMetadata(_ sender: NSButton) {
        let index = metadataTableView.selectedRow
        
        // Only if an item is selected
        if (index >= 0) {
            let indexSet:IndexSet = [index]
            metadataTableView.removeRows(at: indexSet, withAnimation: NSTableView.AnimationOptions.slideLeft)
            library.delete(file: thisFile, keyword: metadata[index].keyword , value: metadata[index].value)
            thisFile = library.all()[fileIndex]
            metadata = thisFile.metadata
        }

        
    }
}

/**
 * Extension determines how many rows will have to be created in the table.
 */
extension DisplayMetadata: NSTableViewDataSource {
    
    // Returns the number of items in metadata.
    func numberOfRows(in metadataTableView: NSTableView) -> Int {
        return metadata?.count ?? 0
    }
}


/**
 * Extension to populate the table with the correct values in the correct location
 */
extension DisplayMetadata: NSTableViewDelegate {
    
    // Metadata rows can be identified by 2 varaibles (for values and keys).
    fileprivate enum CellIdentifiers {
        static let KeyCell = NSUserInterfaceItemIdentifier("KeyCellID")
        static let ValueCell = NSUserInterfaceItemIdentifier("ValueCellID")
    }
    
    
    func tableView(_ metadataTableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text: String = ""
        // To determine what cell we're populating
        var cellIdentifier: NSUserInterfaceItemIdentifier
        
        // tableColumn[0] is for keys, tableColumn[1] is for values
        if tableColumn == metadataTableView.tableColumns[0] {
            
            // Update the text variable
            text = thisFile.metadata[row].keyword
            cellIdentifier = CellIdentifiers.KeyCell
        } else {
            
            // Update the text variable
            text = thisFile.metadata[row].value
            cellIdentifier = CellIdentifiers.ValueCell
        }
        
        // Populate the table with the value from this iteration
        if let cell = metadataTableView.makeView(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
    
}
