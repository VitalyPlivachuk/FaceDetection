//
//  ViewController.swift
//  FaceDetection
//
//  Created by Vitaly Plivachuk on 17.01.17.
//  Copyright © 2017 Vitaly Plivachuk. All rights reserved.
//

import UIKit
import CoreImage

class FaceDetectorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIGestureRecognizerDelegate, UIScrollViewDelegate {
    //MARK: - Outlets
    @IBOutlet weak var pickedImageScrollView: UIScrollView!
    @IBOutlet weak var pickedImage: UIImageView!
    @IBOutlet weak var ciDetectionBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var csDetectionBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var ocvDetectionBarButtonItem: UIBarButtonItem!
    
    //MARK: - Declaration
    let imagePicker = UIImagePickerController()
    let ciFaceDetector = CIFaceDetector()
    let csFaceDetector = CSFaceDetector()
    let ocvFaceDetector = OCVFaceDetector()
    var lastUsedDetector = "none"
    
    //MARK: - Override
    override func viewDidLoad() {
        self.pickedImageScrollView.minimumZoomScale = 1.0
        self.pickedImageScrollView.maximumZoomScale = 6.0
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
                pickedImage.subviews.forEach { $0.removeFromSuperview() }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        //pickedImage.subviews.forEach { $0.removeFromSuperview() }
        switch lastUsedDetector {
        case "CIFaceDetector":
            ciFaceDetector.indicateFeachuresOnView()
        case "CSFaceDetector":
            csFaceDetector.indicateFeachuresOnView()
        case "OCVFaceDetector":
            ocvFaceDetector.indicateFeachuresOnView()
        default:break
        }
        print ("im rotated")
    }
    
    //MARK: - Functions

    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        pickedImage.subviews.forEach { $0.removeFromSuperview() }
        pickedImage.image = ImageProcessing.fixOrientation(img: image)
        self.dismiss(animated: true, completion: nil);
        ciDetectionBarButtonItem.isEnabled = true
        csDetectionBarButtonItem.isEnabled = true
        ocvDetectionBarButtonItem.isEnabled = true
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return (self.pickedImage)
    }
    
    
    //MARK: - Action
    @IBAction func ciDetectAction(_ sender: UIBarButtonItem) {
        pickedImage.subviews.forEach { $0.removeFromSuperview() }
        ciFaceDetector.detectingFacesAndEmotions(pictureView: pickedImage)
        //ciFaceDetector.indicateFeachuresOnView()
        lastUsedDetector = "CIFaceDetector"
    }
    
    @IBAction func cvDetectAction(_ sender: UIBarButtonItem) {
        pickedImage.subviews.forEach { $0.removeFromSuperview() }
        ocvFaceDetector.detectingFacesAndEmotions(pictureView: pickedImage)
        //ocvFaceDetector.indicateFeachuresOnView()
        lastUsedDetector = "OCVFaceDetector"
    }
    
    @IBAction func csDetectAction(_ sender: UIBarButtonItem) {
        pickedImage.subviews.forEach { $0.removeFromSuperview() }
        csFaceDetector.detectingFacesAndEmotions(pickedImage: pickedImage)
        lastUsedDetector = "CSFaceDetector"
    }
    
    @IBAction func selectFromCameraAction(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
    
    @IBAction func selectFromGalleryAction(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
}

