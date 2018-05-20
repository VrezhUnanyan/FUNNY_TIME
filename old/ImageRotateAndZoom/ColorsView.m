//
//  ColorsView.m
//  ImageRotateAndZoom
//
//  Created by Admin on 13.01.17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "ColorsView.h"
#import "AlphaSlider.h"
#import "UIView+ViewMethods.h"
#define Colors @[[UIColor whiteColor], [UIColor blueColor], [UIColor yellowColor], [UIColor orangeColor], [UIColor greenColor]]

@interface ColorsView()

@property (nonatomic, strong)  NSMutableArray *colorButtons;

@end

@implementation ColorsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self addButtons];
        [[NSNotificationCenter defaultCenter] addObserver:  self
                                                 selector:  @selector(removeFromSuperview : )
                                                     name:  @"removeViewNotification"
                                                   object:  nil];
    }
    return self;
}

- (void)addButtons
{
    _colorButtons = [[NSMutableArray alloc] init];
    for(int i = 0; i < Colors.count; i++)
    {
        if(i == 0)
        {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(2, 2, self.frame.size.height - 4, self.frame.size.height - 4)];
            [button setBackgroundColor:[UIColor blackColor]];
            [self addSubview:button];
            [_colorButtons addObject:button];
            [button addTarget:self action:@selector(colorButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        UIButton *lastButton = [_colorButtons objectAtIndex:i];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(lastButton.frame.size.width + lastButton.frame.origin.x + 2, 2, self.frame.size.height - 4, self.frame.size.height - 4)];
        [button setBackgroundColor:[Colors objectAtIndex:i]];
        [self addSubview:button];
        [_colorButtons addObject:button];
        [button addTarget:self action:@selector(colorButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)colorButtonClicked : (UIButton *)button
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"colorButtonClicked" object:button userInfo:@{@"color": button.backgroundColor}];
}

@end
