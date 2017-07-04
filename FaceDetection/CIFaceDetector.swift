//
//  FaceDetector.swift
//  FaceDetection
//
//  Created by Vitaly Plivachuk on 21.01.17.
//  Copyright © 2017 Vitaly Plivachuk. All rights reserved.
//

import Foundation
import CoreImage
import UIKit


class CIFaceDetector {
    
    private class DetectionResult {
        var foundFaces: [CIFaceFeature] = []
        var detectedImage = CIImage()
        var imageView = UIImageView()
    }
    
    private var detectionResult = DetectionResult()
    private var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.whiteLarge)
    
    
    func detectingFacesAndEmotions(pictureView: UIImageView) {
        detectionResult.imageView = pictureView
        
        //Convert UIImage to Core Image
        guard let detectedImage = CIImage(image: detectionResult.imageView.image!) else {
            print("image not detected")
            return
        }
        
        //Setting up activity indicator
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.center = detectionResult.imageView.center;
        activityIndicator.startAnimating()
        detectionResult.imageView.superview?.addSubview(activityIndicator)
        
        //Setting up CI Detector
        let detectionAccuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: detectionAccuracy)
        var foundFaces = [CIFaceFeature]()
        
        //Detecting faces
        let queue = DispatchQueue.global(qos: .utility)
        queue.async{
            foundFaces = faceDetector?.features(in: detectedImage,options:[CIDetectorSmile: true, CIDetectorEyeBlink: true]) as! [CIFaceFeature]
            DispatchQueue.main.async {
                //Testing
                for face in foundFaces {
                    print("Found bounds are \(face.bounds)")
                    if face.hasLeftEyePosition {
                        print("Left eye is at : \(face.leftEyePosition)")
                    }
                    if face.hasRightEyePosition {
                        print("Right eye is at : \(face.rightEyePosition)")
                    }
                    if face.hasMouthPosition {
                        print("Mouth at : \(face.mouthPosition)")
                    }
                    if face.hasSmile {
                        print("Smile at : \(face.mouthPosition)")
                    }
                }
                
                //Saving result
                self.detectionResult.foundFaces = (foundFaces)
                self.detectionResult.detectedImage = detectedImage
                self.detectionResult.imageView = pictureView
                self.activityIndicator.stopAnimating()
                self.indicateFeachuresOnView()
                print("Show image data")
            }
        }
        
    }
    
    
    func indicateFeachuresOnView() {
        detectionResult.imageView.subviews.forEach { $0.removeFromSuperview() }
        for face in detectionResult.foundFaces {
            let convertedBounds = ImageProcessing.convertCoordinatesForCI(image: detectionResult.detectedImage, rect: face.bounds)
            let fixedBounds = ImageProcessing.fixScale(rect:convertedBounds,imageView: detectionResult.imageView )
            let faceRect = UIView(frame: fixedBounds)
            let text = UILabel.init(frame: CGRect.init(x: fixedBounds.origin.x, y: fixedBounds.origin.y-18, width: fixedBounds.width, height: 20))
            faceRect.backgroundColor = UIColor.clear
            faceRect.layer.borderWidth = 3
            
            if face.hasSmile{
                faceRect.layer.borderColor = UIColor.green.cgColor
                text.text = "Smiled Face"
            }else{
                faceRect.layer.borderColor = UIColor.red.cgColor
                text.text = "Smile not found"
            }
            text.backgroundColor=UIColor.init(cgColor: faceRect.layer.borderColor!)
            text.textColor = UIColor.white
            
            
            detectionResult.imageView.addSubview(faceRect)
            detectionResult.imageView.addSubview(text)
        }
    }
}
