//
//  DisplayAudio.swift
//  MediaLibraryGUI
//
//  Created by Joe on 29/09/18.
//  Copyright © 2018 Henry Morrison-Jones. All rights reserved.
//

import Cocoa
import AVKit

/**
 * View controller for audio file formats. Some stored properties are instantiated in the ParentController
 * (ViewController.swift) so that the window knows where it lies in the library and what file to open.
 */
class DisplayAudio: NSViewController {

    // Stored properties
    var file: MMFile!
    var itemsIndex: Int!
    var parentController: ViewController!
    var listItems: [MMFile]?
    var origin: String!
    
    // Outlets
    @IBOutlet weak var audioPlayer: AVPlayerView!
    
    /**
     * Initialises the outletPlayer with the asset at the correct path.
     * A monitor that listens for key events in also added to the view in case a
     * arrow key is used.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
            let fullpath = file.fullpath
            let bundlePath = Bundle.main.resourcePath
            let fileURL = URL(fileURLWithPath:
                bundlePath!+fullpath)
            audioPlayer.player = AVPlayer(url: fileURL)
            audioPlayer.player?.play()
        
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
     * Ensures the audio stops playing when you exit out of a frame.
     */
    override func viewWillDisappear() {
        audioPlayer.player?.pause()
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
            audioPlayer.player?.pause()

            if(itemsIndex + 1 == listItems?.count){
                itemsIndex = -1
            }
            parentController.open(index: itemsIndex + 1, origin: origin)
            self.view.window?.close()
            return true
        case 123:
            audioPlayer.player?.pause()

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
