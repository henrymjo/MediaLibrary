//
//  DisplayImage.swift
//  MediaLibraryGUI
//
//  Created by Henry Morrison-Jones on 9/28/18.
//  Copyright © 2018 Henry Morrison-Jones. All rights reserved.
//

import Cocoa


/**
 * View controller for image file formats. Some stored properties are instantiated in the ParentController
 * (ViewController.swift) so that the window knows where it lies in the library and what file to open.
 */
class DisplayImage: NSViewController {

    // Stored properties
    var file: MMFile!
    var itemsIndex: Int!
    var parentController: ViewController!
    var zoomConstant: Double = 1
    var listItems: [MMFile]?
    var origin: String!
    
    
    // Outlets
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var zoomInButton: NSButton!
    @IBOutlet weak var zoomOutButton: NSButton!
    
    
    
    /**
     * Initialises zoom buttons and the imageView with their appropriate images.
     * A monitor that listens for key events in also added to the view in case a
     * arrow key is used.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundlePath = Bundle.main.resourcePath
        zoomInButton.image? = NSImage(contentsOfFile:
            bundlePath!+"/files/resources/black/png/zoom_icon&24.png")!
        zoomOutButton.image? = NSImage(contentsOfFile:
            bundlePath!+"/files/resources/black/png/zoomOut.png")!
        imageView.image=NSImage(contentsOfFile:
            bundlePath!+file.fullpath)
        
        // Listens for key events in frame.
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            if self.myKeyDown(with: $0) {
                return nil
            } else {
                return $0
            }
        }
    }
    
    
    // Buttons
    /**
     * Scales an image so that it takes up a smaller part of the window view
     * @param sender zoom out button
     */
    @IBAction func zoomOut(_ sender: NSButton) {
        zoomConstant = 2
        
        imageView.imageScaling = NSImageScaling(rawValue: UInt(zoomConstant))!
        print(zoomConstant, " : ", imageView.imageScaling.rawValue)

        
    }
    /**
     * Scales an image so that it takes up a bigger part of the window view
     * @param sender zoom out button
     */
    @IBAction func zoomIn(_ sender: Any) {
        zoomConstant = 1

        imageView.imageScaling = NSImageScaling(rawValue: UInt(zoomConstant))!
        print(zoomConstant, " : ", imageView.imageScaling.rawValue)
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
        switch Int(event.keyCode) {
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


