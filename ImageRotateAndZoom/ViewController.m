//
//  ViewController.m
//  ImageRotateAndZoom
//
//  Created by Admin on 10.12.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "ViewController.h"
#import "ChangeableImageView.h"
#import "AddImageView.h"
#include <math.h>
#import "SelectImageView.h"
#import "AlphaSlider.h"
#import "UIImage+ImageEditingMethods.h"
#import "UIImageView+ImageViewFrameManager.h"
#import "BackgroundImageView.h"
#import "ColorsView.h"
#import "SWRevealViewController.h"

@interface ViewController ()<UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>
{
    BOOL isBottomScrollViewScrolling;
    BackgroundImageView             *backgroundImageView;
    SelectImageView                 *selectImageView;
    ChangeableImageView             *changeableImageView;
    AddImageView                    *addImage;
    ColorsView                      *colorsView;

    AlphaSlider                     *alphaSlider;
    
    CGFloat                         rotateImageWithRadians;
    UIRotationGestureRecognizer     *rotateScroll;
    UIPinchGestureRecognizer        *zoomScroll;
    NSNotificationCenter            *notificationCenter;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@property (weak, nonatomic) IBOutlet UIScrollView                   *scrollView;
@property (weak, nonatomic) IBOutlet UIScrollView                   *bottomScrollView;
@property (weak, nonatomic) IBOutlet UIButton                       *cutButton;
@property (weak, nonatomic) IBOutlet UIButton                       *addButton;
@property (weak, nonatomic) IBOutlet UIButton                       *openAlbumButton;
@property (weak, nonatomic) IBOutlet UIButton                       *saveImageButton;
@property (weak, nonatomic) IBOutlet UIButton                       *selectAndCutButton;
@property (weak, nonatomic) IBOutlet UIButton                       *saveImageInAlbum;

@property (weak, nonatomic) IBOutlet UIButton                       *replaceBackgroundButton;

@property (strong, nonatomic) IBOutletCollection(UIButton)NSArray   *buttons;
@property (weak, nonatomic) IBOutlet UIButton                       *lastImageButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.menuButton setTarget: self.revealViewController];
        [self.menuButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    isBottomScrollViewScrolling = NO;
    changeableImageView = [[ChangeableImageView alloc] init];
    
    [_scrollView addSubview:changeableImageView];
    [_scrollView setScrollEnabled:NO];
    [_scrollView setClipsToBounds:YES];
    
    rotateScroll = [[UIRotationGestureRecognizer alloc] initWithTarget: self
                                                               action: @selector(rotateScroll:)];
    zoomScroll   = [[UIPinchGestureRecognizer alloc] initWithTarget: self
                                                            action: @selector(zoomView:)];
    [_scrollView addGestureRecognizer:zoomScroll];
}
- (IBAction)addButtonDragInside:(id)sender {
    isBottomScrollViewScrolling = YES;
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    [self constraintImageViewNormall];
    [_scrollView setDelegate:self];
    
    notificationCenter = [NSNotificationCenter defaultCenter];
    /*[[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(removeSubViews:)
                                                 name: @"romoveSubviews"
                                               object: nil];*/
}

//scroll view rotate action
- (void)rotateScroll:(UIRotationGestureRecognizer *)rotate
{
    changeableImageView.transform = CGAffineTransformRotate(changeableImageView.transform, rotate.rotation);
    if(rotate.rotation != 0)
    {
        rotateImageWithRadians = rotateImageWithRadians + rotate.rotation;
    }
    rotate.rotation = 0.0;
}

//scroll view zoom action
- (void)zoomView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    changeableImageView.transform = CGAffineTransformScale(changeableImageView.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
    if(selectImageView)
        selectImageView.transform = CGAffineTransformScale(changeableImageView.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
    pinchGestureRecognizer.scale = 1.0;
}


#pragma mark - scrollView delegate functions
//////////////////////////////////////////////////////////////////
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return changeableImageView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    [_scrollView setScrollEnabled:NO];
    if ([scrollView isEqual: _bottomScrollView]) {
        
    }
}
//////////////////////////////////////////////////////////////////

//cut image
- (void) cutImage
{
    [self constraintImageViewNormall];

    CGFloat haraberutyun = changeableImageView.ratioImageAndView/(CGFloat)_scrollView.zoomScale;
    CGRect rect = CGRectMake(-(changeableImageView.frame.origin.x)*haraberutyun, -(changeableImageView.frame.origin.y)*haraberutyun, self.scrollView.frame.size.width * haraberutyun, self.scrollView.frame.size.height * haraberutyun);
    changeableImageView.image = [changeableImageView.image imageCreateWithImageInRect:rect];
    
}

//cut and zoom(move) button clicked
- (IBAction)cutButtonClicked:(id)sender {
    if(changeableImageView.image)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName: @"addingAlphaSlider"
                                                            object: self];
        [self setImageViewBackgroundImage:changeableImageView.image];

        [self buttonsEnabledYesOrNo:_cutButton];
        [_scrollView addGestureRecognizer:zoomScroll];
        [changeableImageView addGestureRecognizer:changeableImageView.moveGestureRecognizer];
        [_scrollView addGestureRecognizer:rotateScroll];
        [self addAlphaSlider];
        /*colorsView = [[ColorsView alloc] initWithFrame:CGRectMake(alphaSlider.frame.origin.x , alphaSlider.frame.origin.y + alphaSlider.frame.size.height + 10, alphaSlider.frame.size.width, 30)];
        [self.view addSubview:colorsView];*/
    }
}
- (IBAction)replaceBackgroundButtonClicked:(id)sender {
    [self buttonsEnabledYesOrNo: _replaceBackgroundButton];
    [self setImageViewBackgroundImage:changeableImageView.image];
    colorsView = [[ColorsView alloc] initWithFrame:CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y  + _scrollView.frame.size.height + 1 , alphaSlider.frame.size.width, 30)];
    [self.view addSubview:colorsView];
}

- (IBAction)addImageButtonClicked:(id)sender {
    if(changeableImageView.image && !isBottomScrollViewScrolling)
    {
        [_scrollView removeGestureRecognizer:rotateScroll];
        [changeableImageView removeGestureRecognizer:changeableImageView.moveGestureRecognizer];
        [self presenPickerViewController];
        [self constraintImageViewNormall];
        [self buttonsEnabledYesOrNo:_addButton];
    }
}

//reload and save new image with image view
- (IBAction)saveImageButtonClecked:(id)sender {
    if([_cutButton tag] == 1)
    {
        [changeableImageView rotateImage:rotateImageWithRadians];
        rotateImageWithRadians = 0.0f;
        [changeableImageView concatImage:backgroundImageView];
        [self cutImage];
    }
    if([_replaceBackgroundButton tag] == 1) {
        [changeableImageView rotateImage:rotateImageWithRadians];
        rotateImageWithRadians = 0.0f;
        [changeableImageView concatImage:backgroundImageView];
    }
    if ([_addButton tag] == 1) {
        [changeableImageView rotateAddImageViews];
    }
    if([_selectAndCutButton tag] == 1)
    {
        [changeableImageView selectRectImage:selectImageView.secondPath];
        [self constraintImageViewNormall];
    }
    [self buttonsEnabledYesOrNo: nil];
    [_saveImageButton setHidden: YES];
    [_lastImageButton setHidden: YES];
    [_openAlbumButton setHidden: NO];
    [_saveImageInAlbum setHidden: NO];
    [_scrollView removeGestureRecognizer:rotateScroll];
    [changeableImageView removeGestureRecognizer:changeableImageView.moveGestureRecognizer];
    [notificationCenter postNotificationName: @"removeViewNotification"
                                      object: self];
}

- (void)constraintImageViewNormall
{
    [_scrollView setZoomScale:1.0];
    [changeableImageView constraintFromSuperview];
    [_scrollView setZoomScale:1.0];
}

#pragma mark - save image with album
- (IBAction)saveInAlbum:(id)sender {
    UIImageWriteToSavedPhotosAlbum(changeableImageView.image, nil, nil, nil);
}

#pragma mark - open album
- (IBAction)openAlbumButtonClicked:(id)sender {
    [self presenPickerViewController];
    changeableImageView.transform = CGAffineTransformRotate(changeableImageView.transform, -rotateImageWithRadians);
    rotateImageWithRadians = 0.0f;
    _scrollView.zoomScale = 1.0;
    [self buttonsEnabledYesOrNo: nil];
    [_lastImageButton setHidden: YES];
    [_saveImageButton setHidden: YES];
    [_openAlbumButton setHidden: NO];
    [_saveImageInAlbum setHidden: NO];
}

//present picker view controller(Album)
- (void)presenPickerViewController
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:NO completion:nil];
}

#pragma mark - get image with album
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:NO completion:nil];
    UIImage *image = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if([_openAlbumButton tag] == 1)
    {
        changeableImageView.image = image;
        [self constraintImageViewNormall];
    }
    else if([_addButton tag] == 1)
    {
        _scrollView.zoomScale = 1.0f;
        addImage = [[AddImageView alloc] initWithImage:image];
        [addImage setUserInteractionEnabled:YES];
        [changeableImageView addSubview:addImage];
        [addImage setFrameWithSuperView:changeableImageView];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:NO completion:nil];
}

//add scroll view background image
- (void) setImageViewBackgroundImage: (UIImage *)image
{
    backgroundImageView = [[BackgroundImageView alloc] initWithImage:image];
    
    backgroundImageView.image = [backgroundImageView.image drawInGraphicsRect:CGRectMake(0, 0, _scrollView.frame.size.width * changeableImageView.ratioImageAndView,  _scrollView.frame.size.height * changeableImageView.ratioImageAndView)];
    
    backgroundImageView.frame = (CGRect){.size = (CGSize){.width = _scrollView.frame.size.width, .height = _scrollView.frame.size.height }};

    [changeableImageView removeFromSuperview];
    [_scrollView addSubview: backgroundImageView];
    [_scrollView addSubview: changeableImageView];
}

- (IBAction)selectAndCutButtonClicked:(id)sender {
    if(!selectImageView && changeableImageView.image)
    {
        [self constraintImageViewNormall];
        selectImageView = [[SelectImageView alloc] init];
        selectImageView.frame =  changeableImageView.frame;
        [selectImageView addConstraints:[changeableImageView constraints]];
        [self.scrollView addSubview:selectImageView];
        selectImageView.ratioImageAndView = [changeableImageView ratioImageAndView];
        [self buttonsEnabledYesOrNo:_selectAndCutButton];
    }
}

- (void)addAlphaSlider
{
    if(!alphaSlider)
    {
        alphaSlider= [[AlphaSlider alloc] init ];
        [alphaSlider setFrame:CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y + _scrollView.frame.size.height + 10, _scrollView.frame.size.width, 10)];
        [self.view addSubview:alphaSlider];
        [alphaSlider addTarget:self action:@selector(changedImageAlpha) forControlEvents:UIControlEventValueChanged];
    }
}

- (void)changedImageAlpha
{
    [changeableImageView changhedImageAlpha:1 - alphaSlider.value/100.0f];
}

- (IBAction)lastImageButtonClicked:(id)sender {
    [_saveImageButton setHidden: YES];
    [_lastImageButton setHidden: YES];
    [_openAlbumButton setHidden: NO];
    [_saveImageInAlbum setHidden: NO];

    if(alphaSlider)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName: @"changeableImageViewLastImage"
                                                            object: self];
    }
    [self buttonsEnabledYesOrNo: nil];
    changeableImageView.transform = CGAffineTransformRotate(changeableImageView.transform, -rotateImageWithRadians);
    [self constraintImageViewNormall];
    [notificationCenter postNotificationName: @"removeViewNotification"
                                      object: self];
}

- (void)buttonsEnabledYesOrNo : (UIButton *)selectedButton
{
    [_saveImageButton setHidden: NO];
    [_lastImageButton setHidden: NO];
    [_openAlbumButton setHidden: YES];
    [_saveImageInAlbum setHidden: YES];

    for(UIButton *button in _buttons)
    {
        if([button isEqual:selectedButton]) {
            [button setUserInteractionEnabled: YES];
            [button setTitleColor: [UIColor colorWithRed:128 green:0 blue:128 alpha:1]
                         forState: UIControlStateNormal];
            [button setTag: 1];
        } else if (selectedButton != nil){
            [button setUserInteractionEnabled: NO];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [button setTag: 0];
        } else {
            [button setUserInteractionEnabled: YES];
            [button setTitleColor: [UIColor colorWithRed:128 green:0 blue:128 alpha:1]
                         forState: UIControlStateNormal];
            [button setTag: 1];
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(removeSubViews:)
                                                 name: @"romoveSubviews"
                                               object: nil];
}

- (void)removeSubViews:(NSNotification *)notification
{
    if([[notification object] isKindOfClass:[BackgroundImageView class]])
    {
        [backgroundImageView removeFromSuperview];
        backgroundImageView = nil;
    }
    else if([[notification object] isKindOfClass:[AddImageView class]])
    {
        [addImage removeFromSuperview];
        addImage = nil;
    }

    else if([[notification object] isKindOfClass:[SelectImageView class]])
    {
        [selectImageView removeFromSuperview];
        selectImageView = nil;
    }
    else if([[notification object] isKindOfClass:[AlphaSlider class]])
    {
        [alphaSlider removeFromSuperview];
        alphaSlider = nil;
    }
}
- (IBAction)replaceColorButtonClicked:(id)sender {
    changeableImageView.image = [ self replaceColor:[UIColor greenColor] inImage:changeableImageView.image withTolerance: 0.0];//[changeableImageView.image gaussBlur:0.2];
}

- (UIImage*) replaceColor:(UIColor*)color inImage:(UIImage*)image withTolerance:(float)tolerance {
    CGImageRef imageRef = [image CGImage];
    
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    NSUInteger bitmapByteCount = bytesPerRow * height;
    
    unsigned char *rawData = (unsigned char*) calloc(bitmapByteCount, sizeof(unsigned char));
    
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    CGColorRef cgColor = [color CGColor];
    const CGFloat *components = CGColorGetComponents(cgColor);
    float r = components[0];
    float g = components[1];
    float b = components[2];
    //float a = components[3]; // not needed
    
    r = r * 255.0;
    g = g * 255.0;
    b = b * 255.0;
    
    const float redRange[2] = {
        MAX(r - (tolerance / 2.0), 0.0),
        MIN(r + (tolerance / 2.0), 255.0)
    };
    
    const float greenRange[2] = {
        MAX(g - (tolerance / 2.0), 0.0),
        MIN(g + (tolerance / 2.0), 255.0)
    };
    
    const float blueRange[2] = {
        MAX(b - (tolerance / 2.0), 0.0),
        MIN(b + (tolerance / 2.0), 255.0)
    };
    
    int byteIndex = 0;
    
    while (byteIndex < bitmapByteCount) {
        unsigned char red   = rawData[byteIndex];
        unsigned char green = rawData[byteIndex + 1];
        unsigned char blue  = rawData[byteIndex + 2];
        
        if (((red >= redRange[0]) && (red <= redRange[1])) &&
            ((green >= greenRange[0]) && (green <= greenRange[1])) &&
            ((blue >= blueRange[0]) && (blue <= blueRange[1]))) {
            // make the pixel transparent
            //
            rawData[byteIndex] = 0;
            rawData[byteIndex + 1] = 0;
            rawData[byteIndex + 2] = 0;
            rawData[byteIndex + 3] = 0;
        }
        
        byteIndex += 4;
    }
    
    UIImage *result = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    
    CGContextRelease(context);
    free(rawData);
    
    return result;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//alevtController
//if(_saveImageButton.hidden == NO)
//{
//    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@""
//                                                                                 message:@"Pahpanel popoxutyunner@ ?"
//                                                                          preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault
//                                                     handler:^(UIAlertAction * _Nonnull action) {
//                                                         [_changeableImageView rotateAddImageViews];
//                                                         [alertViewController dismissViewControllerAnimated:NO completion:nil];
//                                                     }];
//    
//    UIAlertAction *canelAction = [UIAlertAction actionWithTitle:@"cancel"
//                                                          style:UIAlertActionStyleDefault
//                                                        handler:^(UIAlertAction * _Nonnull action) {
//                                                            [_changeableImageView removeAddImageViews];
//                                                            [alertViewController dismissViewControllerAnimated:NO completion:nil];
//                                                        }];
//    
//    [alertViewController addAction:okAction];
//    [alertViewController addAction:canelAction];
//    [self presentViewController:alertViewController animated:NO completion:nil];
//    
//}

@end
