//
//  ChangeableImageVIew.h
//  ImageRotateAndZoom
//
//  Created by Admin on 29.12.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeableImageView : UIImageView

@property (nonatomic, strong)UIPanGestureRecognizer *moveGestureRecognizer;
@property (nonatomic, strong) UIImage *lastImage;

- (void)rotateImage : (CGFloat)radian;
- (void)selectRectImage:(UIBezierPath *)aPath;
- (void)rotateAddImageViews;
- (void)changhedImageAlpha : (CGFloat)alpha;
- (void)concatImage : (UIImageView *)concatImageView;
//-(UIImage *)changeColorTo:(NSMutableArray*) array Transparent: (UIImage *)image;
//-(CGImageRef)createMask:(UIImage*)temp;

@end
