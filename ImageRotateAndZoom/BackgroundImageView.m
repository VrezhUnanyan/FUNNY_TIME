//
//  BackgroundImageView.m
//  ImageRotateAndZoom
//
//  Created by Admin on 12.01.17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "BackgroundImageView.h"
#import "UIImage+ImageEditingMethods.h"
#import "UIImageView+ImageViewFrameManager.h"
#import "UIView+ViewMethods.h"


@implementation BackgroundImageView

 - (id)initWithImage:(UIImage *)image
{
    self = [super init];
    if(self)
    {
        CGFloat a = image.size.width / image.size.height;
        CGFloat b;
        CGRect rect;
        if(a >= 1)
        {
            b = (image.size.width - image.size.height) / 2.0f;
            rect = CGRectMake(b, 0, image.size.width - 2*b, image.size.height);
        }
        else
        {
            b = -(image.size.width - image.size.height) / 2.0f;
            rect = CGRectMake(0, b, image.size.width, image.size.height - 2*b);
        }
        self.image = [image imageCreateWithImageInRect:rect];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(removeFromSuperview:)
                                                     name:@"removeViewNotification"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(selectColorButton:)
                                                     name:@"colorButtonClicked"
                                                   object:nil];
    }
    return self;
}

- (void)selectColorButton:(NSNotification *)notification {
    UIImage *image = self.image;
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    CGSize size = self.image.size;
    
    UIGraphicsBeginImageContext(size);
    [[(UIButton *)([notification object]) backgroundColor] setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.image = image;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

@end
