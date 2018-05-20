//
//  AddImageView.m
//  ImageRotateAndZoom
//
//  Created by Admin on 22.12.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "AddImageView.h"
#import "ViewController.h"
#import "ChangeableImageView.h"
#import "UIImage+ImageEditingMethods.h"
#import "UIImageView+ImageViewFrameManager.h"
#import "UIView+ViewMethods.h"


@interface AddImageView()
{
    //UIView *zoomView;
    //UIView *rotateView;
    CGFloat rotateimageWithRadians;

}
@end

@implementation AddImageView

-(id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if(self)
    {
        [self setBackgroundColor:[UIColor yellowColor]];
        self.image = image;
        [self setContentMode:UIViewContentModeScaleAspectFit];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(removeFromSuperview:)
                                                     name: @"removeViewNotification"
                                                   object: nil];
    }
    return self;
}

- (void) setFrameWithSuperView:(UIImageView *)imageView
{
    CGFloat a = self.image.size.height / (float)self.image.size.width;
    if(a > 1)
    {
        [self setFrame:CGRectMake(20, 20, imageView.frame.size.height/2/(float)a, imageView.frame.size.height/2)];
    }
    else
    {
        [self setFrame:CGRectMake(20, 20,  imageView.frame.size.width/2, imageView.frame.size.width/2*(float)a)];
    }
    
    //[self addZoomView];
    [self addRotateView];
}

//- (void)addZoomView
//{
//    zoomView = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width, self.frame.size.height, -10, -10)];
//    [zoomView setBackgroundColor:[UIColor greenColor]];
//    [zoomView setUserInteractionEnabled:YES];
//    [self addSubview:zoomView];
//
//    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self  action:@selector(moveZoomButton:)];
//    [zoomView addGestureRecognizer:panGestureRecognizer];
//}

-(void)addRotateView
{
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget: self action:@selector(rotationImageView:)];
    
    [self addGestureRecognizer:rotationGestureRecognizer];
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget: self action:@selector(zoomImageView:)];
    
    [self addGestureRecognizer:pinchGestureRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self  action:@selector(moveImageView:)];
        [self addGestureRecognizer:panGestureRecognizer];
}

-(void)rotationImageView:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    self.transform = CGAffineTransformRotate(self.transform, rotationGestureRecognizer.rotation);
    if( rotationGestureRecognizer.rotation != 0.0f)
        rotateimageWithRadians = rotateimageWithRadians + rotationGestureRecognizer.rotation ;
    
    rotationGestureRecognizer.rotation = 0.0f;
}
     
- (void)rotationImage
{
    CGRect rect = self.frame;
    self.image = [self.image rotateImageInRadians:rotateimageWithRadians];

    self.transform = CGAffineTransformRotate(self.transform, -rotateimageWithRadians);
    self.frame = rect;
    rotateimageWithRadians = 0.0f;
    for(UIGestureRecognizer *gestureRecognizer in [self gestureRecognizers])
        [self removeGestureRecognizer:gestureRecognizer];
    [self concatImageWithSuperViewImage];
}

- (void)concatImageWithSuperViewImage
{
    ((ChangeableImageView *)self.superview).image = [((ChangeableImageView *)self.superview).image concatenateImage2 : self.image  ratioRectImage1Image2 : [self ratioConcatenateImagesWithImageView : (ChangeableImageView *)self.superview] ];
    [self removeFromSuperview];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickedAddImageView" object:self];
}
//-(void)moveZoomButton:(UIPanGestureRecognizer *)panGestureRecognizer
//{
//    static CGFloat firstX = 0;
//    static CGFloat firstY = 0;
//    CGPoint translitedPoint = [panGestureRecognizer translationInView:self];
//    if([(UIGestureRecognizer *)panGestureRecognizer state] == UIGestureRecognizerStateBegan)
//    {
//         firstX = [panGestureRecognizer view].center.x;
//         firstY = [panGestureRecognizer view].center.y;
//    }
//    
//    translitedPoint = CGPointMake(firstX + translitedPoint.x, firstY + translitedPoint.y);
// 
// 
//    translitedPoint.x = self.image.size.width/(float)self.image.size.height*translitedPoint.y;
//    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, translitedPoint.x + 10, translitedPoint.y + 10)];
//    [[panGestureRecognizer view] setCenter:CGPointMake(self.frame.size.width-5, self.frame.size.height-5)];
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
