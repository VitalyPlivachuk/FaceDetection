//
//  CSFaceDetector.swift
//  FaceDetection
//
//  Created by Vitaly Plivachuk on 02.02.17.
//  Copyright © 2017 Vitaly Plivachuk. All rights reserved.
//

import Foundation
import UIKit
class CSFaceDetector: AnalyzeImageDelegate {
    
    private class DetectionResult {
        var pickedImage = UIImageView()
        var analyzeImageObject = AnalyzeImage.AnalyzeImageObject()
        var tag = 0
    }
    
    private var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.whiteLarge)
    private var detectionResult = DetectionResult()
    
    func detectingFacesAndEmotions(pickedImage:UIImageView) {
        detectionResult.pickedImage = pickedImage
        
        //Setting up activity indicator
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.center = detectionResult.pickedImage.center;
        activityIndicator.startAnimating()
        detectionResult.pickedImage.superview?.addSubview(activityIndicator)

        
        let analyzeImage = CognitiveServices.sharedInstance.analyzeImage
        analyzeImage.delegate = self
        
        //let visualFeatures: [AnalyzeImage.AnalyzeImageVisualFeatures] = [.Categories, .Description, .Faces, .ImageType, .Color, .Adult]
        let visualFeatures: [AnalyzeImage.AnalyzeImageVisualFeatures] = [.Faces]
        let requestObject: AnalyzeImageRequestObject = (pickedImage.image!, visualFeatures)
        
        try! analyzeImage.analyzeImageWithRequestObject(requestObject, completion: { (response) in
            DispatchQueue.main.async(execute: {
            })
        })
        
    }
    
    
    func indicateFeachuresOnView() {
        detectionResult.pickedImage.subviews.forEach { $0.removeFromSuperview() }
        for face in detectionResult.analyzeImageObject.faces! {
            
            let faceBounds = ImageProcessing.fixScale(rect: face.faceRectangle!, imageView: detectionResult.pickedImage)
            let faceRect = UIView(frame: faceBounds)
            faceRect.backgroundColor=UIColor.clear
            faceRect.layer.borderWidth=3
            let emotion = face.emotion!
            let description = ("\(emotion.uppercaseFirst) \(face.gender!) \(face.age!)")
            
            let text = UILabel.init(frame: CGRect.init(x: faceBounds.origin.x, y: faceBounds.origin.y, width: faceBounds.width, height: 18.0))
            
            switch emotion {
            case "happiness":faceRect.layer.borderColor=UIColor.green.cgColor
            case "disgust":faceRect.layer.borderColor=UIColor.purple.cgColor
            case "neutral":faceRect.layer.borderColor=UIColor.gray.cgColor
            case "anger":faceRect.layer.borderColor=UIColor.red.cgColor
            case "sadness":faceRect.layer.borderColor=UIColor.darkGray.cgColor
            case "surprise":faceRect.layer.borderColor=UIColor.orange.cgColor
            case "contempt":faceRect.layer.borderColor=UIColor.brown.cgColor
            case "fear":faceRect.layer.borderColor=UIColor.black.cgColor
            default: faceRect.layer.borderColor=UIColor.white.cgColor
            }
            
            text.text = description
            text.backgroundColor=UIColor.init(cgColor: faceRect.layer.borderColor!)
            text.textColor = UIColor.white
            detectionResult.pickedImage.addSubview(faceRect)
            detectionResult.pickedImage.addSubview(text)
            
        }
    }
    
    
    internal func finnishedGeneratingObject(_ analyzeImageObject: AnalyzeImage.AnalyzeImageObject) {
        
        print(analyzeImageObject)
        detectionResult.analyzeImageObject = analyzeImageObject
        indicateFeachuresOnView()
        activityIndicator.stopAnimating()
    }
}






