//
//  usefulFunctions.swift
//  MediaLibraryGUI
//
//  Created by Joe on 30/09/18.
//  Copyright © 2018 Henry Morrison-Jones. All rights reserved.
//

import Foundation
import Cocoa
import AVFoundation


/**
 * Removes all character before the specified character
 * @param string to be trimmed
 * @param character to trim before
 * @returns the updated string
 */
func trimBefore(path:String, character:String) -> String {
    var fullpath = ""
    if let index = path.range(of: character)?.lowerBound {
        let substring = path.prefix(upTo: index)
        fullpath = String(substring)
    }
    return fullpath
}

/**
 * Removes all character after the specified character
 * @param string to be trimmed
 * @param character to trim after
 * @returns the updated string
 */
func trimAfter(path:String, character:String) -> String {
    var fullpath = ""
    if let index = path.range(of: character)?.lowerBound {
        let substring = path.suffix(from: index)
        fullpath = String(substring)
    }
    return fullpath
}


/**
 * Determines the file type something is depending on its extension.
 * @param type file extension.
 * @param String to be returned.
 */
func getType(type:String) -> String{
    switch type {
    case ".jpg":
        return "Image"
    case ".png":
        return "Image"
    case ".mp4":
        return "Video"
    case ".mov":
        return "Video"
    case ".mp3":
        return "Audio"
    case ".m4a":
        return "Audio"
    case ".txt":
        return "Document"
    default:
        return "Unknown Type"
    }
}

func videoPreviewImage(fullpath: String) -> NSImage {
    let filePath = Bundle.main.resourcePath! + fullpath
    let vidURL = NSURL(fileURLWithPath:filePath)
    let asset = AVURLAsset(url: vidURL as URL)
    let generator = AVAssetImageGenerator(asset: asset)
    generator.appliesPreferredTrackTransform = true
    generator.requestedTimeToleranceAfter = kCMTimeZero;
    generator.requestedTimeToleranceBefore = kCMTimeZero;
    let timestamp = CMTime(seconds: 2, preferredTimescale: 60)
    do {
        let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
        let size = NSSize(width: 200, height: 150)
        return NSImage(cgImage: imageRef, size: size)
        
    }
    catch let error as NSError
    {
        print("Image generation failed with error \(error)")
        return NSImage()
    }
}

//funcdrawText(image :NSImage) ->NSImage
//    {
//        let text = "sample text"
//        let font = NSFont.boldSystemFont(ofSize: 18)
//        let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
//        let textRect = CGRect(x: 5, y: 5, width: image.size.width - 5, height: image.size.height - 5)
//        let textStyle = NSMutableParagraphStyle.default().mutableCopy() as! NSMutableParagraphStyle
//        let textFontAttributes = [
//            NSFontAttributeName: font,
//            NSForegroundColorAttributeName: NSColor.white,
//            NSParagraphStyleAttributeName: textStyle
//        ]
//        let im:NSImage = NSImage(size: image.size)
//        let rep:NSBitmapImageRep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(image.size.width), pixelsHigh: Int(image.size.height), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSCalibratedRGBColorSpace, bytesPerRow: 0, bitsPerPixel: 0)!
//        im.addRepresentation(rep)
//        im.lockFocus()
//        image.draw(in: imageRect)
//        text.draw(in: textRect, withAttributes: textFontAttributes)
//        im.unlockFocus()
//        return im
//} 

