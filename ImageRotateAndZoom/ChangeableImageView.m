//
//  ChangeableImageView.m
//  ImageRotateAndZoom
//
//  Created by Admin on 29.12.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "ChangeableImageView.h"
#import "AddImageView.h"
#import "UIImage+ImageEditingMethods.h"
#import "UIImageView+ImageViewFrameManager.h"

@interface ChangeableImageView()
{
    
}
@end

@implementation ChangeableImageView

- (id)init
{
    self = [super init];
    if(self)
    {
        [self setClipsToBounds:YES];
        [self setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f]];
        [self setContentMode:UIViewContentModeScaleAspectFit];
        _moveGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveImageView:)];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(addSubviewAddImageView:)
                                                     name: @"clickedAddImageView"
                                                   object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(savePresentImage)
                                                     name: @"addingAlphaSlider" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(imageChanging)
                                                     name: @"changeableImageViewLastImage"
                                                   object: nil];
    }
    return self;
}

- (void)imageChanging
{
   self.image = _lastImage;
}

-(void)rotateImage : (CGFloat)radian
{
    CGRect rect = self.frame;
    self.image = [self.image rotateImageInRadians:radian];
    self.transform = CGAffineTransformRotate(self.transform, -radian);
    self.frame = rect;
}

- (void)concatImage: (UIImageView *)concatImageView
{
    self.image = [concatImageView.image concatenateImage2:self.image ratioRectImage1Image2:[self ratioConcatenateImagesWithImageView:concatImageView]];
}

- (void)selectRectImage: (UIBezierPath *)aPath
{

    if(![aPath isEmpty])
    {
        self.image = [self.image selectRectImage:aPath];
    
        self.image = [self.image imageCreateWithImageInRect :CGRectMake(aPath.bounds.origin.x, aPath.bounds.origin.y, aPath.bounds.size.width,aPath.bounds.size.height)];
    
        self.frame = CGRectMake(0, 0, aPath.bounds.size.width/self.ratioImageAndView, aPath.bounds.size.height/self.ratioImageAndView);
    }

}

//clicked AddImageView notification function
- (void) addSubviewAddImageView:(NSNotification *)notification
{
    [self addSubview:[notification object]];
}

- (void)rotateAddImageViews
{
    for(AddImageView *addView in self.subviews)
    {
        [addView rotationImage];
    }
}

//add AlphaSlider notification function
- (void)savePresentImage
{
    _lastImage = self.image;
}

- (void)changhedImageAlpha : (CGFloat)alpha
{
    UIImage *image = [[UIImage alloc] init];
    image = [_lastImage changhedImageAlpha:alpha];
    self.image = image;
}

//-(UIImage *)changeColorTo:(NSMutableArray*) array Transparent: (UIImage *)image
//{
//    CGImageRef rawImageRef=image.CGImage;
//    
//    const CGFloat colorMasking[6] = {222, 255, 222, 255, 222, 255};
//    
//    //const float colorMasking[6] = {[[array objectAtIndex:0] floatValue], [[array objectAtIndex:1] floatValue], [[array objectAtIndex:2] floatValue], [[array objectAtIndex:3] floatValue], [[array objectAtIndex:4] floatValue], [[array objectAtIndex:5] floatValue]};
//    
//    
//    UIGraphicsBeginImageContext(image.size);
//    CGImageRef maskedImageRef=CGImageCreateWithMaskingColors(rawImageRef, colorMasking);
//    {
//        //if in iphone
//        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, image.size.height);
//        CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
//    }
//    
//    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height), maskedImageRef);
//    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
//    CGImageRelease(maskedImageRef);
//    UIGraphicsEndImageContext();
//    return result;
//}
//
//-(CGImageRef)createMask:(UIImage*)temp
//{
//    CGImageRef ref=temp.CGImage;
//    long int mWidth=CGImageGetWidth(ref);
//    long int mHeight=CGImageGetHeight(ref);
//    long int count=mWidth*mHeight*4;
//    void *bufferdata=malloc(count);
//    
//    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
//    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
//    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
//    
//    CGContextRef cgctx = CGBitmapContextCreate (bufferdata,mWidth,mHeight, 8,mWidth*4, colorSpaceRef, kCGImageAlphaPremultipliedFirst);
//    
//    CGRect rect = {0,0,mWidth,mHeight};
//    CGContextDrawImage(cgctx, rect, ref);
//    bufferdata = CGBitmapContextGetData (cgctx);
//    
//    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bufferdata, mWidth*mHeight*4, NULL);
//    CGImageRef savedimageref = CGImageCreate(mWidth,mHeight, 8, 32, mWidth*4, colorSpaceRef, bitmapInfo,provider , NULL, NO, renderingIntent);
//    CFRelease(colorSpaceRef);
//    return savedimageref;
//}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
@end
