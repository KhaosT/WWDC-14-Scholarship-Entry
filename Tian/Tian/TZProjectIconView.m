//
//  TZProjectIconView.m
//  Tian
//
//  Created by Khaos Tian on 4/4/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "TZProjectIconView.h"

#import <QuartzCore/QuartzCore.h>

@interface TZProjectIconView (){
    UIImageView     *_imageView;
    UILabel         *_titleLabel;
}

@end

@implementation TZProjectIconView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.clipsToBounds = YES;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [_imageView setImage:image];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.alpha = 0.0;
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
        _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.f];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.alpha = 0.0;
        [_titleLabel setText:title];
        [self addSubview:_titleLabel];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_imageView]-0-[_titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView,_titleLabel)]];
        [NSLayoutConstraint constraintWithItem:_titleLabel
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeCenterX
                                    multiplier:1.f constant:0.f];
        
        [UIView animateWithDuration:2.0f animations:^{
            _imageView.alpha = 1.0;
            _titleLabel.alpha = 1.0;
        }];
        
        for (int i = 0; i < 5; i++) {
            CAShapeLayer *grid = [CAShapeLayer layer];
            
            UIBezierPath* bezierPath = [self pathForIndex:i];
            
            grid.path = bezierPath.CGPath;
            grid.position = CGPointMake(0,0);
            grid.lineWidth = 0.5;
            
            grid.fillColor = [UIColor clearColor].CGColor;
            grid.strokeColor = [UIColor grayColor].CGColor;
            
            
            [self.layer addSublayer:grid];
            [self drawLayerWithAnimation:grid duration:1.0f];
            [self fadeAnimationWithLayer:grid duration:2.0f];
        }
    }
    return self;
}

- (UIBezierPath *)pathForIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            UIBezierPath* bezierPath = [UIBezierPath bezierPath];
            [bezierPath moveToPoint: CGPointMake(0, 0)];
            [bezierPath addLineToPoint: CGPointMake(60, 60)];
            [bezierPath closePath];
            [bezierPath moveToPoint: CGPointMake(0, 60)];
            [bezierPath addLineToPoint: CGPointMake(60, 0)];
            [bezierPath closePath];
            bezierPath.miterLimit = 4;
            bezierPath.usesEvenOddFillRule = YES;
            bezierPath.lineWidth = 1;
            return bezierPath;
        }
            break;
            
        case 1:
        {
            UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
            [bezier2Path moveToPoint: CGPointMake(30, 0.03)];
            [bezier2Path addLineToPoint: CGPointMake(30, 60.1)];
            [bezier2Path closePath];
            [bezier2Path moveToPoint: CGPointMake(56.15, 0.03)];
            [bezier2Path addLineToPoint: CGPointMake(56.15, 60.1)];
            [bezier2Path closePath];
            [bezier2Path moveToPoint: CGPointMake(3.88, 0.03)];
            [bezier2Path addLineToPoint: CGPointMake(3.88, 60.1)];
            [bezier2Path closePath];
            [bezier2Path moveToPoint: CGPointMake(18.68, 0.03)];
            [bezier2Path addLineToPoint: CGPointMake(18.68, 60.1)];
            [bezier2Path closePath];
            [bezier2Path moveToPoint: CGPointMake(41.45, 0.03)];
            [bezier2Path addLineToPoint: CGPointMake(41.45, 60.1)];
            [bezier2Path closePath];
            bezier2Path.miterLimit = 4;
            bezier2Path.usesEvenOddFillRule = YES;
            bezier2Path.lineWidth = 1;
            
            return bezier2Path;
        }
            break;
            
        case 2:
        {
            UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
            [bezier3Path moveToPoint: CGPointMake(0.03, 30.07)];
            [bezier3Path addLineToPoint: CGPointMake(60.1, 30.07)];
            [bezier3Path closePath];
            [bezier3Path moveToPoint: CGPointMake(0.03, 41.45)];
            [bezier3Path addLineToPoint: CGPointMake(60.1, 41.45)];
            [bezier3Path closePath];
            [bezier3Path moveToPoint: CGPointMake(0.03, 18.75)];
            [bezier3Path addLineToPoint: CGPointMake(60.1, 18.75)];
            [bezier3Path closePath];
            [bezier3Path moveToPoint: CGPointMake(0.03, 56.22)];
            [bezier3Path addLineToPoint: CGPointMake(60.1, 56.22)];
            [bezier3Path closePath];
            [bezier3Path moveToPoint: CGPointMake(0.03, 3.95)];
            [bezier3Path addLineToPoint: CGPointMake(60.1, 3.95)];
            [bezier3Path closePath];
            bezier3Path.miterLimit = 4;
            bezier3Path.usesEvenOddFillRule = YES;
            bezier3Path.lineWidth = 1;
            
            return bezier3Path;
        }
            break;
            
        case 3:
        {
            UIBezierPath* bezier4Path = [UIBezierPath bezierPath];
            [bezier4Path moveToPoint: CGPointMake(30.07, 3.95)];
            [bezier4Path addCurveToPoint: CGPointMake(56.18, 30.07) controlPoint1: CGPointMake(44.48, 3.95) controlPoint2: CGPointMake(56.18, 15.62)];
            [bezier4Path addCurveToPoint: CGPointMake(30.07, 56.18) controlPoint1: CGPointMake(56.18, 44.51) controlPoint2: CGPointMake(44.51, 56.18)];
            [bezier4Path addCurveToPoint: CGPointMake(3.95, 30.07) controlPoint1: CGPointMake(15.62, 56.18) controlPoint2: CGPointMake(3.95, 44.51)];
            [bezier4Path addCurveToPoint: CGPointMake(30.07, 3.95) controlPoint1: CGPointMake(3.95, 15.62) controlPoint2: CGPointMake(15.65, 3.95)];
            [bezier4Path closePath];
            [bezier4Path moveToPoint: CGPointMake(30.07, 13.92)];
            [bezier4Path addCurveToPoint: CGPointMake(46.21, 30.07) controlPoint1: CGPointMake(38.97, 13.92) controlPoint2: CGPointMake(46.21, 21.16)];
            [bezier4Path addCurveToPoint: CGPointMake(30.07, 46.21) controlPoint1: CGPointMake(46.21, 38.97) controlPoint2: CGPointMake(38.97, 46.21)];
            [bezier4Path addCurveToPoint: CGPointMake(13.92, 30.07) controlPoint1: CGPointMake(21.16, 46.21) controlPoint2: CGPointMake(13.92, 38.97)];
            [bezier4Path addCurveToPoint: CGPointMake(30.07, 13.92) controlPoint1: CGPointMake(13.92, 21.16) controlPoint2: CGPointMake(21.16, 13.92)];
            [bezier4Path closePath];
            bezier4Path.miterLimit = 4;
            bezier4Path.usesEvenOddFillRule = YES;
            bezier4Path.lineWidth = 1;
            return bezier4Path;
        }
            break;
            
        case 4:
        {
            UIBezierPath* bezier5Path = [UIBezierPath bezierPath];
            [bezier5Path moveToPoint: CGPointMake(30, 0)];
            [bezier5Path addLineToPoint: CGPointMake(18.5, 0)];
            [bezier5Path addCurveToPoint: CGPointMake(3.94, 3.93) controlPoint1: CGPointMake(11.98, 0) controlPoint2: CGPointMake(7.85, 0.03)];
            [bezier5Path addCurveToPoint: CGPointMake(0, 18.5) controlPoint1: CGPointMake(0.02, 7.85) controlPoint2: CGPointMake(0, 12)];
            [bezier5Path addLineToPoint: CGPointMake(0, 30)];
            [bezier5Path addCurveToPoint: CGPointMake(3.93, 56.06) controlPoint1: CGPointMake(0, 48.02) controlPoint2: CGPointMake(0.03, 52.15)];
            [bezier5Path addCurveToPoint: CGPointMake(18.5, 60) controlPoint1: CGPointMake(7.85, 59.98) controlPoint2: CGPointMake(12, 60)];
            [bezier5Path addLineToPoint: CGPointMake(30, 60)];
            [bezier5Path addCurveToPoint: CGPointMake(56.06, 56.07) controlPoint1: CGPointMake(48.02, 60) controlPoint2: CGPointMake(52.15, 59.98)];
            [bezier5Path addCurveToPoint: CGPointMake(60, 30) controlPoint1: CGPointMake(59.97, 52.15) controlPoint2: CGPointMake(60, 48)];
            [bezier5Path addLineToPoint: CGPointMake(60, 18.5)];
            [bezier5Path addCurveToPoint: CGPointMake(56.07, 3.94) controlPoint1: CGPointMake(60, 11.98) controlPoint2: CGPointMake(59.97, 7.85)];
            [bezier5Path addCurveToPoint: CGPointMake(30, 0) controlPoint1: CGPointMake(52.15, 0.02) controlPoint2: CGPointMake(48, 0)];
            [bezier5Path addLineToPoint: CGPointMake(30, 0)];
            bezier5Path.lineWidth = 1;
            return bezier5Path;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

- (void)fadeAnimationWithLayer:(CALayer *)layer duration:(CFTimeInterval)duration
{
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.duration = duration;
    fadeAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    fadeAnimation.toValue = [NSNumber numberWithFloat:0.0];
    [layer addAnimation:fadeAnimation forKey:nil];
    layer.opacity = 0.0;
}

- (void)drawLayerWithAnimation:(CAShapeLayer *)layer duration:(CFTimeInterval)duration
{
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = duration;
    drawAnimation.repeatCount         = 1.0;
    
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    drawAnimation.delegate = self;
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [layer addAnimation:drawAnimation forKey:@"drawNextAnimation"];
}

@end
