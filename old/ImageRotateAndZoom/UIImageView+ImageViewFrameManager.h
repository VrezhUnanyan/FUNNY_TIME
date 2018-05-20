//
//  UIImageView+ImageViewFrameManager.h
//  ImageRotateAndZoom
//
//  Created by Admin on 09.01.17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ImageViewFrameManager)

- (void)constraintFromSuperview;
- (CGFloat)ratioImageAndView;
- (CGRect)ratioConcatenateImagesWithImageView : (UIImageView *)imageView;
- (void)moveImageView:(UIPanGestureRecognizer *)panGestureRecognizer;
- (void)zoomImageView:(UIPinchGestureRecognizer *)pinchGestureRecognizer;

@end
