//
//  OpenCVWrapper.h
//  FaceDetection
//
//  Created by Vitaly Plivachuk on 20.03.17.
//  Copyright © 2017 Vitaly Plivachuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface OpenCVWrapper : NSObject

{
    
}
//Define interface of OpenCV

//Get OCV version:
+(NSString *) openvcVersionString;

//HAAR Detect
-(NSArray *) detectFacesAndEmotions:(UIImage *)image;




@end


//Faces.h
@interface RecognizingResult : NSObject
@property (nonatomic) CGRect rect;
@property (nonatomic) NSString *emotion;
@end

//Faces.m
@implementation RecognizingResult

@end
