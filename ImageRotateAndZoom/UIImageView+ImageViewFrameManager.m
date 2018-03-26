//
//  UIImageView+ImageViewFrameManager.m
//  ImageRotateAndZoom
//
//  Created by Admin on 09.01.17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "UIImageView+ImageViewFrameManager.h"

@implementation UIImageView (ImageViewFrameManager)

- (void)constraintFromSuperview
{
    if(self.image)
    {
        CGFloat f = self.image.size.width/(float)self.image.size.height;
        if(self.image.size.width < self.image.size.height)
        {
            
            CGFloat b = (self.superview.frame.size.width - self.superview.frame.size.height * f)/(CGFloat)2;
            [self setFrame:CGRectMake(b, 0, f * self.superview.frame.size.height, self.superview.frame.size.height)];
        }
        else
        {
            CGFloat a = (self.superview.frame.size.height  - self.superview.frame.size.width/(float)f)/(CGFloat)2.0f;
            [self setFrame:CGRectMake(0, a, self.superview.frame.size.width, self.superview.frame.size.width/(CGFloat)f)];
        }
    }
}

- (CGFloat)ratioImageAndView
{
    return self.image.size.width / self.bounds.size.width ;
}

- (CGRect)ratioConcatenateImagesWithImageView : (UIImageView *)imageView
{
    CGFloat ratio = imageView.ratioImageAndView;
    CGFloat x = self.frame.origin.x * ratio;
    CGFloat y = self.frame.origin.y * ratio;
    CGFloat width = self.frame.size.width * ratio;
    CGFloat height = self.frame.size.height * ratio;
    
    CGRect ratioRect = CGRectMake(x, y, width, height);
    return ratioRect;
}

- (void)moveImageView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    static CGFloat firstX = 0;
    static CGFloat firstY = 0;
    CGPoint translitedPoint = [panGestureRecognizer translationInView:[self superview]];
    if([(UIGestureRecognizer *)panGestureRecognizer state] == UIGestureRecognizerStateBegan)
    {
        firstX = [panGestureRecognizer view].center.x;
        firstY = [panGestureRecognizer view].center.y;
    }
    translitedPoint = CGPointMake(firstX + translitedPoint.x, firstY + translitedPoint.y);
    [[panGestureRecognizer view] setCenter:CGPointMake(translitedPoint.x, translitedPoint.y)];
}

- (void)zoomImageView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    self.transform = CGAffineTransformScale(self.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
    pinchGestureRecognizer.scale = 1.0f;
}


@end
