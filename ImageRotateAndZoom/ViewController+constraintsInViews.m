//
//  ViewController+constraintsInViews.m
//  ImageRotateAndZoom
//
//  Created by Admin on 21.12.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "ViewController+constraintsInViews.h"

@implementation ViewController (constraintsInViews)

//-(void)constraintImageView:(ChangeableImageView *)imageView scrollView:(UIScrollView *)scrollView
//{
//    if(imageView.image)
//    {
//        CGFloat f = imageView.image.size.width/(float)imageView.image.size.height;
//        if(imageView.image.size.width < imageView.image.size.height)
//        {
//            
//            CGFloat b = (scrollView.frame.size.width - scrollView.frame.size.width*f)/(CGFloat)2;
//            [imageView setFrame:CGRectMake(b, 0, f * scrollView.frame.size.width, scrollView.frame.size.height)];
//        }
//        else
//        {
//            CGFloat a = (scrollView.frame.size.height - scrollView.frame.size.height/(CGFloat)f)/2.0f;
//            [imageView setFrame:CGRectMake(0, a, scrollView.frame.size.width, scrollView.frame.size.height/(CGFloat)f)];
//        }
//    }
//}

@end
