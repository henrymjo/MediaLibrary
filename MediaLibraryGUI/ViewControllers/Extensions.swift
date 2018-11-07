//
//  Extensions.swift
//  MediaLibraryGUI
//
//  Created by Joseph McManamon on 10/5/18.
//  Copyright © 2018 Henry Morrison-Jones. All rights reserved.
//

import Cocoa

/**
 * Detemines the number of rows to be created in the tableview (our main file box).
 */
extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return items?.count ?? 0
    }
    
}

/**
 * Extensions specifies what the tableView will be populated with. Lets the cells be identified so they get the correct values placed in them
 */
extension ViewController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let NameCell = NSUserInterfaceItemIdentifier("NameCellID")
        static let AuthorCell = NSUserInterfaceItemIdentifier("AuthorCellID")
        static let TypeCell = NSUserInterfaceItemIdentifier("TypeCellID")
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text: String = ""
        var cellIdentifier: NSUserInterfaceItemIdentifier
        
        guard let item = items?[row] else{
            return nil
        }
        
        if tableColumn == tableView.tableColumns[0] {
            text = item.filename
            cellIdentifier = CellIdentifiers.NameCell
            
            
        } else if tableColumn == tableView.tableColumns[1] {
            text = "Default Author"  //Fix this
            for data in item.metadata{
                if (data.keyword == "creator"){
                    text = data.value
                }
            }
            cellIdentifier = CellIdentifiers.AuthorCell
        } else {
            text = "Default Type"
            let ext = trimAfter(path: item.filename, character: ".")
            text = getType(type: ext)
            cellIdentifier = CellIdentifiers.TypeCell
        }
        
        if let cell = tableView.makeView(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            let bundlepath = Bundle.main.resourcePath
            cell.textField?.stringValue = text
            let type = getType(type: trimAfter(path: item.fullpath, character: "."))
            var path = ""
            
            if type == "Audio"{
                path = "/files/resources/black/png/music_icon&16.png"
            } else if type == "Document" {
                path = "/files/resources/black/png/document_icon&16.png"
            } else if type == "Video" {
                path = "/files/resources/black/png/movie_icon&16.png"
            } else if type == "Image" {
                path = "/files/resources/black/png/picture_icon&16.png"
            }
            
            cell.imageView?.image = NSImage(contentsOfFile: bundlepath! + path)
            return cell
        }
        return nil
    }
}

/**
 * Extensions specifies what the outlineView will be populated with. Lets the cells be identified so they get the correct values placed in them
 */
extension ViewController: NSOutlineViewDelegate{
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var view: NSTableCellView?
        if let group = item as? Group{
            view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("GroupCellID"), owner: self) as? NSTableCellView
            if let textField = view?.textField{
                textField.stringValue = group.name
            }
        }else if let file = item as? MMFile{
            view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("FileCellID"), owner: self) as? NSTableCellView
            if let textField = view?.textField{
                textField.stringValue = file.filename
            }
        }
        return view
    }
}

/**
 * Detemines the number of headers and rows that need to be created so the file typess are logically separated
 */
extension ViewController: NSOutlineViewDataSource{
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        print("Entering first function for datasource")
        if let group = item as? Group{
            return group.files.count
        }
        print("Number of bookmarks: ", bookmarks.count)
        return bookmarks.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        print("Entering second function for datasource")
        if let group = item as? Group{
            return group.files[index]
        }
        print("next item: ", bookmarks[index].name)
        return bookmarks[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let group = item as? Group{
            return group.files.count > 0
        }
        return false
    }
}

/**
 * Makes sure the correct notes are updated when you change the selected file.
 */
extension ViewController: NSTextViewDelegate{
    func textDidChange(_ notification: Notification) {
        if(tableView.selectedRow > -1){
            notes[items![tableView.selectedRow].filename] = notesDisplay.string
        }
    }
}


