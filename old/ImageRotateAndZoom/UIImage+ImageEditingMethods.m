//
//  UIImageView+ImageViewEditingMethods.m
//  ImageRotateAndZoom
//
//  Created by Admin on 09.01.17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "UIImage+ImageEditingMethods.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (ImageEditingMethods)

- (UIImage *)imageCreateWithImageInRect : (CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    return [UIImage imageWithCGImage:imageRef];
}

- (UIImage *)drawInGraphicsRect : (CGRect)rect
{
    UIImage *imageCopy = self;
    
    UIGraphicsBeginImageContext(rect.size);
    [imageCopy drawInRect:rect];
    imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

- (UIImage *)concatenateImage2 : (UIImage *)concatenateImage  ratioRectImage1Image2 : (CGRect)ratioRect
{
    UIImage *imageCopy = self;
    CGRect rect = CGRectMake(ratioRect.origin.x, ratioRect.origin.y, ratioRect.size.width, ratioRect.size.height);
    CGSize graphicSize = imageCopy.size;
    
    UIGraphicsBeginImageContext(graphicSize);
    [imageCopy drawInRect:CGRectMake(0, 0, graphicSize.width, graphicSize.height)];
    imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    [concatenateImage drawInRect:rect];
    concatenateImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return concatenateImage;
}

- (UIImage *)rotateImageInRadians : (CGFloat)radian
{
    UIImage *imageCopy = self;
    CGAffineTransform transform = CGAffineTransformMakeRotation(radian);
    CGRect sizeRect = (CGRect){.size = self.size};
    CGRect destRect = CGRectApplyAffineTransform(sizeRect, transform);
    CGSize destinationSize = destRect.size;
    UIGraphicsBeginImageContext(destinationSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, destinationSize.width/2.0f, destinationSize.height/2.0f);
    CGContextRotateCTM(context, radian);
    [imageCopy drawInRect:CGRectMake(-imageCopy.size.width/2.0f, -imageCopy.size.height/2.0f, imageCopy.size.width, imageCopy.size.height)];
    imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

- (UIImage *)selectRectImage:(UIBezierPath *)aPath
{
    UIImage *imageCopy = self;
    
    UIGraphicsBeginImageContext(imageCopy.size);
    UIBezierPath *path = [UIBezierPath bezierPath];
    path = aPath;
    [path closePath];
    [path addClip];
    
    
    CGRect rect = (CGRect){.origin = CGPointZero,.size = imageCopy.size};
    [imageCopy drawInRect:rect];

    imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

- (UIImage *)changhedImageAlpha : (CGFloat)alpha
{
    CGSize size = self.size;
    
    UIImage *imageCopy = self;
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [imageCopy drawInRect:rect blendMode:kCGBlendModeHardLight alpha:alpha];
    imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

- (UIImage*)gaussBlur:(CGFloat)blurLevel
{
    blurLevel = MIN(1.0, MAX(0.0, blurLevel));
    
    int boxSize = (int)(blurLevel * 0.1 * MIN(self.size.width, self.size.height));
    boxSize = boxSize - (boxSize % 2) + 1;
    
    NSData *imageData = UIImageJPEGRepresentation(self, 1);
    UIImage *tmpImage = [UIImage imageWithData:imageData];
    
    CGImageRef img = tmpImage.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    //create vImage_Buffer with data from CGImageRef
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    NSInteger windowR = boxSize/2;
    CGFloat sig2 = windowR / 3.0;
    if(windowR>0){ sig2 = -1/(2*sig2*sig2); }
    
    int16_t *kernel = (int16_t*)malloc(boxSize*sizeof(int16_t));
    int32_t  sum = 0;
    for(NSInteger i=0; i<boxSize; ++i){
        kernel[i] = 255*exp(sig2*(i-windowR)*(i-windowR));
        sum += kernel[i];
    }
    
    // convolution
    error = vImageConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, kernel, boxSize, 1, sum, NULL, kvImageEdgeExtend)?:
    vImageConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, kernel, 1, boxSize, sum, NULL, kvImageEdgeExtend);
    outBuffer = inBuffer;
    
    free(kernel);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGBitmapAlphaInfoMask & kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}


@end
