//
//  ImageProcessing.swift
//  FaceDetection
//
//  Created by Vitaly Plivachuk on 02.02.17.
//  Copyright © 2017 Vitaly Plivachuk. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

class ImageProcessing {
    static func fixScale(rect:CGRect,imageView:UIImageView) -> CGRect {
        var fixedRect = rect
        let detectedImageSize = imageView.image?.size
        let viewSize = imageView.bounds.size
        let scale = min(viewSize.width / (detectedImageSize?.width)!,
                        viewSize.height / (detectedImageSize?.height)!)
        let offsetX = (viewSize.width - (detectedImageSize?.width)! * scale) / 2
        let offsetY = (viewSize.height - (detectedImageSize?.height)! * scale) / 2
        fixedRect = fixedRect.applying(CGAffineTransform(scaleX: scale, y: scale))
        fixedRect.origin.x += offsetX
        fixedRect.origin.y += offsetY
        return fixedRect
    }
    
    static func convertCoordinatesForCI (image:CIImage,rect:CGRect) -> CGRect {
        let detectedImageSize = image.extent.size
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -detectedImageSize.height)
        return rect.applying(transform)
    }
    
    static func fixOrientation(img:UIImage) -> UIImage {
        
        if (img.imageOrientation == UIImageOrientation.up) {
            return img;
        }
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return normalizedImage;
    }
    
    static func indicateFaceOnImageView (imageView:UIImageView, faceRectangle:CGRect){
        
    }
    
    static func indicateFaceOnImageViewWithLabel (imageView:UIImageView, faceRectangle:CGRect, label:String){
        
    }

}
