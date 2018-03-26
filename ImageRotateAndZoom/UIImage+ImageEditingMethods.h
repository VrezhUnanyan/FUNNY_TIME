//
//  UIImageView+ImageViewEditingMethods.h
//  ImageRotateAndZoom
//
//  Created by Admin on 09.01.17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageEditingMethods)

- (UIImage *)imageCreateWithImageInRect : (CGRect)rect;
- (UIImage *)concatenateImage2 : (UIImage *)concatenateImage  ratioRectImage1Image2 : (CGRect)ratioRect;
- (UIImage *)drawInGraphicsRect : (CGRect)rect;
- (UIImage *)rotateImageInRadians : (CGFloat)radian;
- (UIImage *)selectRectImage:(UIBezierPath *)aPath;
- (UIImage *)changhedImageAlpha : (CGFloat)alpha;
- (UIImage*)gaussBlur:(CGFloat)blurLevel;

@end
