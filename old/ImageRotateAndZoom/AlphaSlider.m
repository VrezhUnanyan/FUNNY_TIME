//
//  AlphaSlider.m
//  ImageRotateAndZoom
//
//  Created by Admin on 04.01.17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "AlphaSlider.h"
#import "UIView+ViewMethods.h"


@implementation AlphaSlider

-(id)init
{
    self = [super init];
    if(self)
    {
        [self setMinimumValue:0.0f];
        [self setMaximumValue:100.0f];
        self.continuous = YES;
        [[NSNotificationCenter defaultCenter] addObserver:  self
                                                 selector:  @selector(removeFromSuperview : )
                                                     name:  @"removeViewNotification"
                                                   object:  nil];
    }
    return self;
}



@end
