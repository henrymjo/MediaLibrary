//
//  DisplayDocument.swift
//  MediaLibraryGUI
//
//  Created by Joe on 28/09/18.
//  Copyright © 2018 Henry Morrison-Jones. All rights reserved.
//

import Cocoa


/**
 * View controller for image file formats. Some stored properties are instantiated in the ParentController
 * (ViewController.swift) so that the window knows where it lies in the library and what file to open.
 */
class DisplayDocument: NSViewController {

    // Stored properties
    var file: MMFile!
    var itemsIndex: Int!
    var parentController: ViewController!
    var listItems: [MMFile]?
    var origin: String!

    // Outlets
    @IBOutlet var textView: NSTextView!

    /**
     * Initialises the outletPlayer with the asset at the correct path.
     * A monitor that listens for key events in also added to the view in case a
     * arrow key is used.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        let pathNoExtension = trimBefore(path: file.fullpath, character: ".")
        let filepath = Bundle.main.path(forResource: pathNoExtension, ofType: "txt")
        let contents = try! String(contentsOfFile: filepath!)
        textView.string = contents;
        textView.isEditable = false
        
        // Listens for key events in frame.
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            if self.myKeyDown(with: $0) {
                return nil
            } else {
                return $0
            }
        }
    }
    
    /**
     * Ensures the text view contains nothing on exit.
     */
    override func viewWillDisappear() {
        textView = nil
    }

    /**
     * Responds when a key event is registered. Determines whether the key pressed was for the current view
     * and then determines whether it was a left or right arow key.
     * If so, opens up the next media type in the 'items' list and closes the current window.
     * @param keyEvent when key is pressed.
     * @returns true if valid key, else false.
     */
    func myKeyDown(with event: NSEvent) -> Bool {
        guard let locWindow = self.view.window,
            NSApplication.shared.keyWindow === locWindow else { return false }
        switch Int( event.keyCode) {
        case 124:
            if(itemsIndex + 1 == listItems?.count){
                itemsIndex = -1
            }
            parentController.open(index: itemsIndex + 1, origin: origin)
            self.view.window?.close()
            return true
        case 123:
            if (itemsIndex - 1 == -1){
                itemsIndex = listItems?.count
            }
            parentController.open(index: itemsIndex - 1, origin: origin)
            self.view.window?.close()
            return true
        default:
            return false
        }
    }
    
    /**
     * Assigns the current open window with the appropriate title
     */
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.title = file.filename
    }
}


