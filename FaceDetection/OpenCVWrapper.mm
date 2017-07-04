//
//  OpenCVWrapper.m
//  FaceDetection
//
//  Created by Vitaly Plivachuk on 20.03.17.
//  Copyright © 2017 Vitaly Plivachuk. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import "OpenCVWrapper.h"
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/face.hpp>

@implementation OpenCVWrapper

+(NSString *) openvcVersionString {
    return [NSString stringWithFormat:@CV_VERSION];
}

-(cv::Mat) returnGrayscaleImage:(cv::Mat)image{
    //Are image gray?
    if (image.channels() == 1) return image;
    
    //Transform to gray
    cv::Mat imageGray;
    cv::cvtColor(image, imageGray, CV_BGR2GRAY);
    
    //Return
    return imageGray;
}

-(std::vector<cv::Rect>) locateFaces:(cv::Mat)matImage{
    cv::CascadeClassifier face_cascade;
    
    //Finding path to haarcascade file
    NSString *faceCascadePath = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_alt"
                                                                ofType:@"xml"
                                                           inDirectory:@"haarcascades"];
    const CFIndex CASCADE_NAME_LEN = 2048;
    char *CASCADE_NAME = (char *) malloc(CASCADE_NAME_LEN);
    CFStringGetFileSystemRepresentation( (CFStringRef)faceCascadePath, CASCADE_NAME, CASCADE_NAME_LEN);
    
    //Loading cascade file
    face_cascade.load(CASCADE_NAME);
    
    // Detecting faces
    std::vector<cv::Rect> faces;
    face_cascade.detectMultiScale( matImage, faces, 1.1, 2, 0|CV_HAAR_SCALE_IMAGE, cv::Size(30, 30) );
    
    //Return
    return faces;
}

-(NSArray *) recognizeEmotions:(cv::Mat)image withFaces: (std::vector<cv::Rect>)faces{
    
    NSMutableArray *recognizingResultArray = [NSMutableArray new];
    NSString *emotions[6] = {@"neutral", @"anger", @"disgust", @"happy", @"sadness", @"surprise"};
    cv::Mat gray = [self returnGrayscaleImage:image];
    
    //Finding path to model file
    NSString *emotionsModelPath = [[NSBundle mainBundle] pathForResource:@"emotion_detection_model"
                                                                  ofType:@"xml"
                                                             inDirectory:@"haarcascades"];
    const CFIndex MODEL_NAME_LEN = 2048;
    char *MODEL_NAME = (char *) malloc(MODEL_NAME_LEN);
    CFStringGetFileSystemRepresentation( (CFStringRef)emotionsModelPath, MODEL_NAME, MODEL_NAME_LEN);
    
    //Loading model for Fisher Face Recognizer
    cv::Ptr<cv::face::FaceRecognizer> modelForFisherFaceRecognizer = cv::face::createFisherFaceRecognizer();
    modelForFisherFaceRecognizer -> load(MODEL_NAME);
    
    
    for(int i = 0; i < faces.size(); i++) {
        RecognizingResult *recognizingResult = [RecognizingResult new];
        cv::Rect faceRect = faces[i];       //Face borders
        cv::Mat faceImage = gray(faceRect); //Cutted face
        
        //Resizing face image in accordance with database used for model training
        cv::Mat faceImageResized;
        cv::resize(faceImage, faceImageResized, cv::Size(350, 350), 1.0, 1.0, cv::INTER_CUBIC);
        
        //Recognizing emotion
        int prediction = modelForFisherFaceRecognizer->predict(faceImageResized);
        
        //Prepearing result
        CGRect rect = CGRectMake(faceRect.x, faceRect.y, faceRect.width, faceRect.height);
        NSString *emotion = emotions[prediction];
        [recognizingResult setRect:rect];
        [recognizingResult setEmotion:emotion];
        [recognizingResultArray addObject:recognizingResult];
    }
    
    //Return
    return recognizingResultArray;
}

-(NSArray *) detectFacesAndEmotions:(UIImage *)image{
    //Converting UIImage to Mat
    cv::Mat matImage;
    UIImageToMat(image, matImage);
    
    //Locating faces using Haar cascades
    std::vector<cv::Rect> faces =[self locateFaces:matImage];
    
    //Returning array with detection results
    return [self recognizeEmotions:matImage withFaces:faces];
}



@end
