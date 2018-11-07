//
//  MediaLibraryGUIUITests.swift
//  MediaLibraryGUIUITests
//
//  Created by Henry Morrison-Jones on 10/5/18.
//  Copyright © 2018 Henry Morrison-Jones. All rights reserved.
//

import XCTest

class MediaLibraryGUIUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddBookmarks() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }
    
    func testEditAddMetadata(){
        
    }
    
    func testOpenImage(){
        
    }
    
    func testOpenVideo(){
        
    }
    
    func testOpenDocument(){
        
    }
    
    func testOpenAudio(){
        
    }
    
    func testAddNote(){
        
    }
    
    func testSave(){
        
    }
    
    func testLibraryScroll(){
        
    }
    
}
