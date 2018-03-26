//
//  SelectImageView.h
//  ImageRotateAndZoom
//
//  Created by Admin on 26.12.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectImageView : UIView

@property (nonatomic, strong)UIBezierPath *path;
@property (nonatomic, strong)UIBezierPath *secondPath;
@property (nonatomic, assign)CGFloat ratioImageAndView;
-(id)init;

@end
