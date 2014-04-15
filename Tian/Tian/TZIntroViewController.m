//
//  TZIntroViewController.m
//  Tian
//
//  Created by Khaos Tian on 4/3/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "TZIntroViewController.h"

@interface TZIntroViewController ()<UIScrollViewDelegate>{
    BOOL    _hasAnimated;
    CFTimeInterval  _lastAnimationTime;
    
    CALayer *_nextLayer;
}

@property (weak, nonatomic) IBOutlet UILabel *line1Label;
@property (weak, nonatomic) IBOutlet UILabel *line2Label;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation TZIntroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _hasAnimated = NO;
    
    _line1Label.alpha = 0.0f;
    _line2Label.alpha = 0.0f;
    _nameLabel.alpha = 0.0f;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!_hasAnimated) {
        _hasAnimated = YES;
        [self performSelector:@selector(startAppearAnimationSequence) withObject:nil afterDelay:0.5];
    }
}

- (void)startAppearAnimationSequence
{
    [UIView animateWithDuration:0.5f animations:^{
        _line1Label.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.33f animations:^{
            _line2Label.alpha = 1.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5f animations:^{
                _nameLabel.alpha = 1.0;
            } completion:^(BOOL finished) {
                _nextLayer = [self nextButtonAnimation];
                [self performSelector:@selector(moveNextButton) withObject:nil afterDelay:1.5];
            }];
        }];
    }];
}

- (void)moveNextButton
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:_nextLayer.position];
    [path addLineToPoint:CGPointMake(20,
                                     CGRectGetHeight([UIScreen mainScreen].bounds)- 120)];
    
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnimation.path = path.CGPath;
    moveAnimation.beginTime = 0;
    moveAnimation.duration = 1.3f;
    
    CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    fadeOut.duration = 1.3f;
    fadeOut.fromValue = [NSNumber numberWithFloat:1.0];
    fadeOut.toValue = [NSNumber numberWithFloat:0.0];
    fadeOut.beginTime = 0;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 1.3f;
    animationGroup.animations = @[moveAnimation,fadeOut];
    
    animationGroup.delegate = self;
    
    _nextLayer.opacity = 0;
    [_nextLayer addAnimation:animationGroup forKey:@"animationGroup"];
}

- (void)addBreathAnimationForLayer:(CALayer *)layer beginTime:(CFTimeInterval)time
{
    CABasicAnimation *breathAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    breathAnimation.duration = 2;
    breathAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    breathAnimation.toValue = [NSNumber numberWithFloat:1.0];
    breathAnimation.beginTime = time;
    breathAnimation.repeatCount = HUGE_VALF;
    breathAnimation.autoreverses = YES;
    [layer addAnimation:breathAnimation forKey:nil];
}

- (CALayer *)nextButtonAnimation
{
    CAShapeLayer *next = [CAShapeLayer layer];
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(57, 16)];
    [bezierPath addLineToPoint: CGPointMake(41, 41)];
    [bezierPath addLineToPoint: CGPointMake(57, 66)];
    [bezierPath addLineToPoint: CGPointMake(41, 41)];
    [bezierPath closePath];
    bezierPath.lineWidth = 2;
    
    next.path = bezierPath.CGPath;
    next.position = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 80,
                                  CGRectGetHeight([UIScreen mainScreen].bounds)- 120);
    
    next.fillColor = [UIColor clearColor].CGColor;
    next.strokeColor = [UIColor blackColor].CGColor;
    
    [self.view.layer addSublayer:next];
    
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = 0.6;
    drawAnimation.repeatCount         = 1.0;
    
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [next addAnimation:drawAnimation forKey:@"drawNextAnimation"];
    
    return next;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    __weak id weakSelf = self;
    [self addBreathAnimationForLayer:_nextLayer beginTime:0];
    [[NSNotificationCenter defaultCenter]addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        _lastAnimationTime = [_nextLayer convertTime:CACurrentMediaTime() fromLayer:nil];
        [_nextLayer removeAllAnimations];
    }];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [weakSelf addBreathAnimationForLayer:_nextLayer beginTime:[_nextLayer convertTime:CACurrentMediaTime() fromLayer:nil] - _lastAnimationTime];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
