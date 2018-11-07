//
//  ViewController.swift
//  MediaLibraryGUI
//
//  Created by Henry Morrison-Jones on 26/09/18.
//  Copyright © 2018 Henry Morrison-Jones. All rights reserved.
//

import Cocoa
import AVFoundation



class ViewController: NSViewController {
    
    // Stored properties
    var items: [MMFile]?
    var bookmarkedItems: [MMFile] = []
    var notes: [String: String] = [:]
    var bookmarks = [Group]()
    
    // Four groups, one for bookmarking each media type.
    var videoBookmarks = Group(name: "Videos")
    var imageBookmarks = Group(name: "Images")
    var documentBookmarks = Group(name: "Documents")
    var audioBookmarks = Group(name: "Audio")
    
    // Outlets
    @IBOutlet var notesDisplay: NSTextView!
    @IBOutlet weak var myOutlineView: NSOutlineView!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var fileTitle: NSTextField!
    @IBOutlet weak var searchBar: NSSearchField!
    @IBOutlet weak var previewOutlet: NSImageView!
    @IBOutlet weak var metadataOutlet: NSTextField!
    @IBOutlet weak var metadataOutlet2: NSTextFieldCell!
    
    
    /**
     * Initialisation of the tableView, outlineView and the bookmark array that stores ALL bookmark subarrays.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        notesDisplay.delegate = self
        myOutlineView.delegate = self
        myOutlineView.dataSource = self
        myOutlineView.target = self
        myOutlineView.doubleAction = #selector(outlineViewDoubleClick(_:))
        
        bookmarks.append(videoBookmarks)
        bookmarks.append(imageBookmarks)
        bookmarks.append(audioBookmarks)
        bookmarks.append(documentBookmarks)
        
        myOutlineView.reloadData()
        
        tableView.target = self
        tableView.doubleAction = #selector(tableViewDoubleClick(_:))
    }
    
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
    // ACTIONS
    /**
     * Search function updates searches array by VALUE and updates the items array
     * so that the view of the table can update.
     * @param the searchfield when it has a value.
     */
    @IBAction func search(_ sender: NSSearchField) {
        // Makes the notes dissappear
        notesDisplay.string = ""
        print(searchBar.stringValue)
        // if value in search bar, search. Else display everything.
        if(!(searchBar.stringValue.isEmpty)){
            items = library.search(term: searchBar.stringValue)
        }else{
            items = library.all()
        }
        tableView.reloadData()
    }
    
    
    /**
     * Save opens up a panel and lets user choose the directory that they will save in. Can be anywhere but user can't currently
     * enter the name of the file they'd like to save it as.
     * @param NSMenu Item (Command S)
     */
    @IBAction func saveLibrary(_ sender: NSMenuItem) {
        if let url = NSOpenPanel().saveFile{
            // Get the url as a string
            let string = url.absoluteString
            let index = string.index(string.startIndex, offsetBy: 7)
            let subString = string.suffix(from: index)
            let pathString = String(subString)
            let fullpath = pathString + "MediaFiles.json"
            library.save(filename: fullpath)
            
        } else {
            print("Save was cancelled")
        }
        
    }
    
    @IBAction func loadtestLibrary(_ sender: NSMenuItem) {
        let path = Bundle.main.resourcePath
        library.load(filename: path! + "/test2.json")
        items = library.all()
        tableView.reloadData()
    }
    
    
    /**
     * Opens up a panel that lets you pick any json file in the computer. Can load multiple
     * @param sender NSLoadButton or the open MenuItem (Command O).
     */
    @IBAction func loadClicked(_ sender: Any) {
        
        if let urls = NSOpenPanel().selectUrls{
            //Operations needed to conform the url string to the format used by the Library's load function
            for url in urls {
                let string = url.absoluteString
                let index = string.index(string.startIndex, offsetBy: 7)
                let subString = string.suffix(from: index)
                let pathString = String(subString)
                //Load the file into the library
                library.load(filename: pathString)
                items = library.all()
                for item in items!{
                    notes[item.filename] = "No notes"
                }
                tableView.reloadData()
            }
        } else {
            print("File selection was canceled")
        }
    }
    
    
    // Functions
    /**
     * Responds when a user highlights a file in the main tableView. File path must actually exist to be displayed i.e. the row must be created.
     * @param notification sent when the table notices a click.
     */
    func tableViewSelectionDidChange(_ notification: Notification) {
        // If you click somewhere else, deselect.
        if(tableView.selectedRow > -1){
            myOutlineView.deselectAll(self)
        }
        updateStatus()
    }
    
    /**
     * Responds when a user highlights a file in the main myOutlineView (Bookmarks). File path must actually exist to be displayed.
     * @param notification sent when the table notices a click.
     */
    func outlineViewSelectionDidChange(_ notification: Notification) {
        if(myOutlineView.selectedRow > -1){
            tableView.deselectAll(self)
        }
    }
    
    
    /**
     * Function determines what row has been clicked on. If there is a file, the notesDisplays is activated so that users can enter information.
     */
    func updateStatus() {
        let index = tableView.selectedRow
        if index >= 0 {
            displayPreview(item: items![index])
            notesDisplay.isEditable = true
            notesDisplay.string = notes[items![index].filename]!
        }else{
            notesDisplay.string = ""
            notesDisplay.isEditable = false
        }
    }
    
    
    /**
     * There's a lot happening here... The function ultimately decides what view controller to open depending on what parameters are passed.
     * The origin parameter is currently one of five values: Table, Video, Image, Audio or Document which help determine what array to use to
     * select the file.
     * If passed Table, everything proceeds as NORMAl
     * If passed a media type e.g. image, the file to open is pulled from the correspending bookmark array.
     * This is required as 'index' could refer to something from the normal table view OR something from the bookmarks outlineView (which has weird indexing).
     * @param index of file to open
     * @param origin the list of files we're referring to.
     * More below...
     */
    func open(index: Int, origin: String){
        var ext: String
        switch origin {
        case "Video":
            // trims after the . character then passes the extension to a function that determines if
            // it what media type it is i.e. image, video etc.
            ext = trimAfter(path: videoBookmarks.files[index].filename, character: ".")
        case "Image":
            ext = trimAfter(path: imageBookmarks.files[index].filename, character: ".")
        case "Audio":
            ext = trimAfter(path: audioBookmarks.files[index].filename, character: ".")
        case "Document":
            ext = trimAfter(path: documentBookmarks.files[index].filename, character: ".")
        default:
            ext = trimAfter(path: items![index].filename, character: ".")
        }
        
        // currentType is determined from the 'ext' extension, this is necessary only when items are selected from the
        // normal table view. Slightly redundant but still REQUIRED
        let currentType = getType(type: ext)
        
        
        // Four cases here, all identical aside from instantiating a different viewController
        switch currentType {
        case "Video":
            let videoViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("VideoView")) as? DisplayVideo
            // If origin was 'Table', this is where we make sure we use the items array. otherwise use the corresponding bookmarks array.
            // This lets us instantiate the view controllers reference to file and listItems correctly, meaning we can scroll
            // through the bookmarks using arrow keys.
            
            videoViewController!.parentController = self    // reference to who opened the controller
            if origin == "Table"{
                videoViewController!.file = items![index]
                videoViewController!.itemsIndex = index
                videoViewController!.listItems = items
            } else {
                videoViewController!.file = videoBookmarks.files[index]
                videoViewController!.itemsIndex = index
                videoViewController!.listItems = videoBookmarks.files
            }
            videoViewController!.origin = origin
            let newWindow = NSWindow(contentViewController: videoViewController!)
            let controller = VideoWindowController(window: newWindow)
            controller.showWindow(self)
        case "Image":
            
            // Same as comment above
            let imageViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("ImageView")) as? DisplayImage
            imageViewController!.parentController = self
            if origin == "Table"{
                imageViewController!.file = items![index]
                imageViewController!.itemsIndex = index
                imageViewController!.listItems = items
            } else {
                imageViewController!.file = imageBookmarks.files[index]
                imageViewController!.itemsIndex = index
                imageViewController!.listItems = imageBookmarks.files
            }
            imageViewController!.origin = origin
            let newWindow = NSWindow(contentViewController: imageViewController!)
            let controller = ImageWindowController(window: newWindow)
            controller.showWindow(self)
        case "Audio":
            
            // Same as comment above above
            let audioViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("AudioView")) as? DisplayAudio
            audioViewController!.parentController = self
            if origin == "Table"{
                audioViewController!.file = items![index]
                audioViewController!.itemsIndex = index
                audioViewController!.listItems = items
            } else {
                audioViewController!.file = audioBookmarks.files[index]
                audioViewController!.itemsIndex = index
                audioViewController!.listItems = audioBookmarks.files
            }
            audioViewController!.origin = origin
            let newWindow = NSWindow(contentViewController: audioViewController!)
            let controller = AudioWindowController(window: newWindow)
            controller.showWindow(self)
            
        case "Document":
            
            // Same as comment above above above
            let documentViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("DocumentView")) as? DisplayDocument
            documentViewController!.parentController = self
            if origin == "Table"{
                documentViewController!.file = items![index]
                documentViewController!.itemsIndex = index
                documentViewController!.listItems = items
            } else {
                documentViewController!.file = documentBookmarks.files[index]
                documentViewController!.itemsIndex = index
                documentViewController!.listItems = documentBookmarks.files
            }
            documentViewController!.origin = origin
            let newWindow = NSWindow(contentViewController: documentViewController!)
            let controller = DocumentWindowController(window: newWindow)
            controller.showWindow(self)
        default:
            
            // Just in case something went wrong.
            metadataOutlet.stringValue = "Can't open file"
            metadataOutlet2.stringValue = "Unsupported type"
            return
        }
    }
    
    /**
     * Response when a double click is registered on the tableView.
     * @param sender is double mouse click.
     */
    @objc func tableViewDoubleClick(_ sender:AnyObject) {
        let index = tableView.selectedRow
        if index < 0 {
            return
        }else{
            open(index: index, origin: "Table")
        }
    }
    
    /**
     * Response when a double click is registered on the bookmark outlineView. This one is slightly more complicated
     * due to the strange indexing on outlineViews
     * @param sender is double mouse click.
     */
    @objc func outlineViewDoubleClick(_ sender: AnyObject){
        var index = myOutlineView.selectedRow
        
        if index < 0 {
            return
        }else{
            
            // Buffer the index
            let c1 = videoBookmarks.files.count
            let c2 = imageBookmarks.files.count
            let c3 = audioBookmarks.files.count
            let c4 = documentBookmarks.files.count
            
            // prevents crashing if you click an empty header
            if ((index == 0) || index == (1+c1) || index == (2+c1+c2) || index == (3+c1+c2+c3)){
                return
            }
            
            // Figures out where in the outlineView you're clicking on so that the correct index for the correct type of file
            // is passed to the open function i.e. a buffer for the extra header indexes
            if index <= (0+c1){
                index = index-1
                open(index: index, origin: "Video")
            } else if index <= (1+c1+c2){
                index = index-2-c1
                open(index: index, origin: "Image")
                
            } else if index <= (2+c1+c2+c3){
                index = index-3-c2-c1
                open(index: index, origin: "Audio")
                
            } else if index <= (3+c1+c2+c3+c4){
                index = index-4-c3-c2-c1
                open(index: index, origin: "Document")
            }
            
        }
    }
    
    /**
     * Menu item action for when you right click on a file in the tableView
     */
    @IBAction func addToBookmarks(_ sender: NSMenuItem) {
        let index = tableView.clickedRow
        let currentItem = items![index]
        let type = getType(type: trimAfter(path: currentItem.filename, character: "."))
        
        // Depending on type, add to bookmark bar.
        switch type {
        case "Image":
            imageBookmarks.files.append(currentItem)
            bookmarkedItems.append(currentItem)
        case "Video":
            videoBookmarks.files.append(currentItem)
            bookmarkedItems.append(currentItem)
        case "Audio":
            audioBookmarks.files.append(currentItem)
            bookmarkedItems.append(currentItem)
        case "Document":
            documentBookmarks.files.append(currentItem)
            bookmarkedItems.append(currentItem)
        default:
            print("Unrecognised filetype")
            return
        }
        
        myOutlineView.reloadData()
        
    }
    
    
    /**
     * Action for when you right click on a file and selct 'edit metadata'.
     * @param sender is a MenuItem.
     */
    @IBAction func editMetadata(_ sender: Any) {
        print("right click")
        var index = tableView.clickedRow
        print(index)
        
        // Hack - needs to be optimised or edit metadata changed. Possibly extend MMFile?
        // Helps to identify what file you're editing when you change the tableView (with the search function).
        var i: Int = 0
        for item in library.all(){
            if item.filename == items![index].filename && item.fullpath == items![index].fullpath{
                index = i
            }else{
                i = i+1
            }
        }
        
        // Instantiates the DisplayMetadata view controller when you right click on a file and selct the option.
        if index >= 0 {
            let metadataViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("MetadataView")) as? DisplayMetadata
            metadataViewController?.fileIndex = index
            let newWindow = NSWindow(contentViewController: metadataViewController!)
            let controller = MetadataWindowController(window: newWindow)
            controller.showWindow(self)
        }
    }
    
    
    /**
     * Displays a preview of the file when you single click a file. Offers a dynamic preview of videos and images
     * but is a static constant image for audio and text.
     */
    func displayPreview(item: MMFile){
        
        // Gets the row, finds the relevant item
        let index = self.tableView.selectedRow
        let currentItem = items![index]
        let type = getType(type: trimAfter(path: currentItem.filename, character: "."))
        
        if type == "Video"{
            previewOutlet.image = videoPreviewImage(fullpath: currentItem.fullpath)
        } else if type == "Image"{
            let bundlePath = Bundle.main.resourcePath
            previewOutlet.image=NSImage(contentsOfFile:
                bundlePath!+currentItem.fullpath)
        } else if type == "Document" {
            // Only displays a static image
            let bundlePath = Bundle.main.resourcePath
            previewOutlet.image=NSImage(contentsOfFile:
                bundlePath!+"/files/resources/textPreview.png")
        } else if type == "Audio" {
            let bundlePath = Bundle.main.resourcePath
            previewOutlet.image=NSImage(contentsOfFile:
                bundlePath!+"/files/resources/audioPreview.png")
        }
        else {
            previewOutlet.image = nil
        }
        
        // Preview metadata
        if currentItem.metadata.count == 1 {
            metadataOutlet.stringValue = currentItem.metadata[0].keyword + ": " + currentItem.metadata[0].value
            metadataOutlet2.stringValue = ""
        } else if currentItem.metadata.count > 1 {
            metadataOutlet.stringValue = currentItem.metadata[0].keyword + ": " + currentItem.metadata[0].value
            metadataOutlet2.stringValue = currentItem.metadata[1].keyword + ": " + currentItem.metadata[1].value
        } else {
            metadataOutlet.stringValue = ""
            metadataOutlet2.stringValue = ""
            
        }
    }
}


