//
//  ViewController.swift
//  Moodie
//
//  Created by Rahul Ranjan on 2/5/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import Cocoa


class ViewController: NSViewController, AFDXDetectorDelegate {
    
    @IBOutlet weak var imageLabel: NSTextField!
    @IBOutlet weak var imageView: NSImageView!
    
    var detector: AFDXDetector!
    var emojiView: NSImageView!
    
    // facepoint can be nil
    var facePoints: NSArray?
    var imageBound: CGRect?
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        // launch the detector
        createDetector()
        
        // add subviews
        self.addEmojiView()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        killDetector()
    }
    
    
    func createDetector() {
        detector = AFDXDetector.init(delegate: self, using: AFDX_CAMERA_FRONT, maximumFaces: 5)
        // detector specific settings
        // http://developer.affectiva.com/v3_1_1/osx/analyze-camera/
        detector.maxProcessRate = 2.0;
        // detector.setDetectAllEmotions(true)
        // detector.setDetectAllExpressions(true)
        detector.setDetectEmojis(true)
        
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
        print("New Face Detected!")
    }
    
    func detectorDidStopDetectingFace(face : AFDXFace) {
        // handle loss of existing face
        print("Stopped Face Detection!")
    }
    
    
    func rectangleBound(points: NSArray) {
        
        // This line literally killed me
        // two level type casting
        // let point = (points[0] as! NSValue) as CGPoint
        let points = points.map{$0 as! CGPoint}
        
        // This will give the bounds as the Affdex API don't have face bounds
        let minX = points.sorted(by: {$0.x < $1.x})[0].x
        let maxX = points.sorted(by: {$0.x > $1.x})[0].x
        let minY = points.sorted(by: {$0.y < $1.y})[0].y
        let maxY = points.sorted(by: {$0.y > $1.y})[0].y
        
        self.imageBound = CGRect(x: minX, y: minY, width: (maxX-minX), height: (maxY-minY))
    }
    
    func addEmojiView() {
        self.emojiView = NSImageView(frame: self.imageBound ?? CGRect())
        self.imageView.addSubview(emojiView)
    }
    
    func addEmojiImage(emotion: String) {
        self.emojiView.frame = self.imageBound ?? CGRect()
        let image  = NSImage(named: emotion)
        emojiView.image = image!
    }
    
    func removeEmojiImage() {
        self.emojiView.image = nil
    }
    
    func detector(_ detector: AFDXDetector!, hasResults faces: NSMutableDictionary!, for image: NSImage!, atTime time: TimeInterval) {
        
        if faces != nil {
            // enumrate the dictionary of faces and process each one
            for (_, face ) in faces! {
                
                // set the face point
                self.facePoints = (face as AnyObject).facePoints
                
                let emoji = (face as AnyObject).emojis!.dominantEmoji
                
                switch emoji.rawValue {
                case 128515:
                    self.addEmojiImage(emotion: "smiley")
                case 128518:
                    self.addEmojiImage(emotion: "laughing")
                case 128535:
                    self.addEmojiImage(emotion: "kissing")
                case 128545:
                    self.addEmojiImage(emotion: "rage")
                case 128561:
                    self.addEmojiImage(emotion: "scream")
                case 128539:
                    self.addEmojiImage(emotion: "tongue")
                case 9786:
                    self.addEmojiImage(emotion: "relaxed")
                default:
                    self.removeEmojiImage()
                }
            }
        } else {
            // handle unprocessed image in this block of code
            // get the rectangle bounds for face
            if facePoints != nil {
                // calculate face bound
                self.rectangleBound(points: facePoints!)
                
                let rectImage = AFDXDetector.image(byDrawingPoints: nil, andRectangles: nil, andImages: nil, withRadius: 2.0, usingPointColor: NSColor.white, usingRectangleColor: NSColor.green, usingImageRects: nil, on: image)
            
                self.imageView.image = rectImage
            }
        }
    }
}

