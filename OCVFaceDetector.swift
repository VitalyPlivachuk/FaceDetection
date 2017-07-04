//
//  OCVFaceDetector.swift
//  FaceDetection
//
//  Created by Vitaly Plivachuk on 28.03.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit

class OCVFaceDetector {
    
    private class DetectionResult {
        var pickedImage = UIImageView()
        var faces =  [RecognizingResult]()
    }
    
    private let openCVWrapper = OpenCVWrapper()
    private let detectionResult = DetectionResult();
    private var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.whiteLarge)
    
    
    func detectingFacesAndEmotions(pictureView:UIImageView) {
        detectionResult.pickedImage = pictureView
        
        //Setting up activity indicator
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.center = detectionResult.pickedImage.center;
        activityIndicator.startAnimating()
        detectionResult.pickedImage.superview?.addSubview(activityIndicator)
        
        //Detecting emotions
        let queue = DispatchQueue.global(qos: .utility)
        queue.async{
            self.detectionResult.faces = self.openCVWrapper.detectFacesAndEmotions(pictureView.image) as! [RecognizingResult]
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.indicateFeachuresOnView()
                print("Show image data")
            }
        }
        
    }
    
    func indicateFeachuresOnView() {
        detectionResult.pickedImage.subviews.forEach { $0.removeFromSuperview() }
        for face in detectionResult.faces {
            let faceBounds = ImageProcessing.fixScale(rect: face.rect, imageView: detectionResult.pickedImage)
            let faceRect = UIView(frame: faceBounds)
            faceRect.backgroundColor=UIColor.clear
            faceRect.layer.borderWidth=3
            let emotion = face.emotion!
            
            let text = UILabel.init(frame: CGRect.init(x: faceBounds.origin.x, y: faceBounds.origin.y, width: faceBounds.width, height: 18.0))
            //"neutral", "anger", "disgust", "happy", "sadness", "surprise"
            switch emotion {
            case "happy":faceRect.layer.borderColor=UIColor.green.cgColor
            case "disgust":faceRect.layer.borderColor=UIColor.purple.cgColor
            case "neutral":faceRect.layer.borderColor=UIColor.gray.cgColor
            case "anger":faceRect.layer.borderColor=UIColor.red.cgColor
            case "sadness":faceRect.layer.borderColor=UIColor.darkGray.cgColor
            case "surprise":faceRect.layer.borderColor=UIColor.orange.cgColor
            default: faceRect.layer.borderColor=UIColor.white.cgColor
            }
            
            text.text = emotion.uppercaseFirst
            text.backgroundColor=UIColor.init(cgColor: faceRect.layer.borderColor!)
            text.textColor = UIColor.white
            detectionResult.pickedImage.addSubview(faceRect)
            detectionResult.pickedImage.addSubview(text)
            
        }
        
    }
    
}
