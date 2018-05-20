//
//  UIView+ViewMethods.m
//  ImageRotateAndZoom
//
//  Created by Admin on 12.01.17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "UIView+ViewMethods.h"

@implementation UIView (ViewMethods)


//notification function
- (void)removeFromSuperview : (NSNotification *)notification
{
    [[NSNotificationCenter  defaultCenter] postNotificationName: @"romoveSubviews"
                                                         object: self];
    [self removeFromSuperview];
}

@end
