//
//  AddImageView.h
//  ImageRotateAndZoom
//
//  Created by Admin on 22.12.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddImageView : UIImageView <UIGestureRecognizerDelegate>

- (id)initWithImage:(UIImage *)image;
- (void) setFrameWithSuperView:(UIImageView *)imageView;
- (void)rotationImage;

@end
