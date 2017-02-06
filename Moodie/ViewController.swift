//
//  ViewController.swift
//  Moodie
//
//  Created by Rahul Ranjan on 2/5/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import Cocoa


class ViewController: NSViewController, AFDXDetectorDelegate {
    
    var detector: AFDXDetector!
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        // launch the detector
        createDetector()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        killDetector()
    }
    
    
    func createDetector() {
        detector = AFDXDetector.init(delegate: self, using: AFDX_CAMERA_FRONT, maximumFaces: 1)
        // detector specific settings
        // http://developer.affectiva.com/v3_1_1/osx/analyze-camera/
        detector.maxProcessRate = 8.0;
        detector.setDetectAllEmotions(true)
        detector.setDetectEmojis(true)
        detector.setDetectAllExpressions(true)
        
        let error = detector.start()
        
        if error != nil {
            // display a window alert box
            let alert = NSAlert.init()
            alert.messageText = "Detector Error"
            alert.informativeText = "Please try to run again"
            alert.addButton(withTitle: "OK")
            alert.addButton(withTitle: "Cancel")
            alert.runModal()
        }
    }
    
    func killDetector() {
        detector.stop()
    }
    
    // delegates methods
    func detectorDidStartDetectingFace(face : AFDXFace) {
        // handle new face
    }
    
    func detectorDidStopDetectingFace(face : AFDXFace) {
        // handle loss of existing face
    }
    
    
    func detector(_ detector: AFDXDetector!, hasResults faces: NSMutableDictionary!, for image: NSImage!, atTime time: TimeInterval) {
        
        if faces != nil {
            // enumrate the dictionary of faces and process each one
            for (_, face) in faces! {
                let emoji : AFDXEmoji = (face as AnyObject).emojis
                print(emoji)
            }
        } else {
            // handle unprocessed image in this block of code
        }
    }
}

