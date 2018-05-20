//
//  SelectImageView.m
//  ImageRotateAndZoom
//
//  Created by Admin on 26.12.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "SelectImageView.h"
#import "UIView+ViewMethods.h"

@implementation SelectImageView

-(id)init
{
    self = [super init];
    if(self)
    {
        [self setUserInteractionEnabled:YES];
        [self setNeedsDisplay];
        _path = [UIBezierPath bezierPath];
        [_path setLineWidth:1.0f];
        [_path setLineJoinStyle:kCGLineJoinBevel];
        
        //////////
        _secondPath = [UIBezierPath bezierPath];;
        [_secondPath setLineWidth:1.0f];
        ////////
        [self setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.0]];
        self.layer.borderColor = [UIColor blueColor].CGColor;
        self.layer.borderWidth = 1.0f;
        [self setNeedsDisplay];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(removeFromSuperview:)
                                                     name:@"removeViewNotification"
                                                   object:nil];
    }
    return self;
}


-(CGPoint)getPoint : (NSSet<UITouch *> *)touches
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    return point;
}

-(void)drawRect:(CGRect)rect
{
    [_path stroke];
    //[_secondPath stroke];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [self getPoint:touches];
    [_path moveToPoint:point];
    [_path addLineToPoint:point];
    ////////
    [_secondPath moveToPoint:(CGPoint){.x = point.x * self.ratioImageAndView,.y = point.y * self.ratioImageAndView}];
    [_secondPath addLineToPoint:(CGPoint){.x = point.x * self.ratioImageAndView,.y = point.y * self.ratioImageAndView}];
    ////////
    [self setNeedsDisplay];

}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [self getPoint:touches];
    [_path addLineToPoint:point];
    ////////
    [_secondPath addLineToPoint:(CGPoint){.x = point.x * self.ratioImageAndView,.y = point.y * self.ratioImageAndView}];
    ////////
    [self setNeedsDisplay];

}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [self getPoint:touches];
    [_path addLineToPoint:point];
    ////////
    [_secondPath addLineToPoint:(CGPoint){.x = point.x * self.ratioImageAndView,.y = point.y* self.ratioImageAndView}];
    ////////
    [self setNeedsDisplay];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
