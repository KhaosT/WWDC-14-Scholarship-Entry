//
//  TZStage4Creator.m
//  Tian
//
//  Created by Khaos Tian on 4/10/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "TZStage4Creator.h"
#import "TZAnimateOperation.h"
#import <QuartzCore/QuartzCore.h>

#define ANIMATION_DURATION 1.8f

@implementation TZStage4Creator

- (NSArray *)groupOfAnimationsToLayer:(CALayer *)layer
{
    NSMutableArray *animationArray = [[NSMutableArray alloc]init];
    
    NSString *script = @"People changed their way to";
    NSArray  *strings = [script componentsSeparatedByString:@" "];
    
    UIFont *font = [UIFont fontWithName: @"HelveticaNeue-Thin" size: 30.f];
    
    __block CGFloat currentX = 20;
    __block CGFloat currentY = 40;
    
    __block TZAnimateOperation *lastOperation = nil;
    
    [strings enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGSize size = [self getSizeForText:obj forFont:font];
        if (currentX + size.width >= 300) {
            currentX = 20;
            currentY = currentY + size.height + 10;
        }
        TZAnimateOperation *operation = [self animationForText:obj
                                                 animatedLayer:layer
                                                         frame:CGRectMake(currentX, currentY, size.width, size.height)
                                                      withFont:font];
        if (lastOperation) {
            [operation addDependency:lastOperation];
        }else{
            operation.fadeWhenClean = YES;
            operation.cleanBeforeStart = YES;
        }
        
        currentX += size.width + 5;
        
        lastOperation = operation;
        [animationArray addObject:operation];
    }];
    
    TZAnimateOperation *bgOperation = [self animationForImage:[UIImage imageNamed:@"connect.png"] animatedLayer:layer];
    
    bgOperation.insertAtBack = YES;
    
    if (lastOperation) {
        [bgOperation addDependency:lastOperation];
        [animationArray addObject:bgOperation];
    }
    
    currentX += 2;
    
    NSArray *stringObjects = @[@"capture",@"share",@"connect"];
    
    [stringObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGSize size = [self getSizeForText:obj forFont:font];
        if (currentX + size.width >= 300) {
            currentX = 20;
            currentY = currentY + size.height + 10;
        }
        TZAnimateOperation *operation = [self animationForText:obj
                                                 animatedLayer:layer
                                                         frame:CGRectMake(currentX, currentY, size.width, size.height)
                                                      withFont:font];
        CAAnimation *textAnimation = operation.animation;
        
        CAKeyframeAnimation *moveInAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        {
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(currentX+(size.width/2.0), currentY+(size.height/2.0) + 40)];
            [path addLineToPoint:CGPointMake(currentX+(size.width/2.0), currentY+(size.height/2.0))];
            moveInAnimation.path = path.CGPath;
        }
        moveInAnimation.beginTime = 0.0f;
        moveInAnimation.duration = 0.33f;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(currentX+(size.width/2.0), currentY+(size.height/2.0))];
        [path addLineToPoint:CGPointMake(currentX+(size.width/2.0), currentY+(size.height/2.0) - 40)];
        
        CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnimation.path = path.CGPath;
        moveAnimation.beginTime = 0;
        moveAnimation.duration = 0.33f;
        
        CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        fadeOut.duration = 0.33;
        fadeOut.fromValue = [NSNumber numberWithFloat:1.0];
        fadeOut.toValue = [NSNumber numberWithFloat:0.0];
        fadeOut.beginTime = 0;
        
        if (idx == 0) {
            CAAnimationGroup *animationGroupIn = [CAAnimationGroup animation];
            animationGroupIn.duration = ANIMATION_DURATION;
            animationGroupIn.animations = @[textAnimation];
            operation.animation = animationGroupIn;
        }
        
        if (idx != 0) {
            CAAnimationGroup *animationGroupIn = [CAAnimationGroup animation];
            animationGroupIn.duration = ANIMATION_DURATION;
            animationGroupIn.animations = @[moveInAnimation,textAnimation];
            operation.animation = animationGroupIn;
        }
        
        CAAnimationGroup *animationGroupOut = [CAAnimationGroup animation];
        animationGroupOut.duration = 0.33;
        animationGroupOut.animations = @[moveAnimation,fadeOut];
        
        if (lastOperation) {
            [operation addDependency:lastOperation];
        }
        
        lastOperation = operation;
        
        [animationArray addObject:operation];
        
        if (idx != 2) {
            TZAnimateOperation *secondOperation = [[TZAnimateOperation alloc]init];
            secondOperation.animation = animationGroupOut;
            secondOperation.animatedLayer = layer;
            secondOperation.layer = operation.layer;
            secondOperation.removeAfterFinish = YES;
            secondOperation.extraBlock = ^(CALayer *blockLayer){
                [blockLayer setOpacity:0.0];
            };
            [secondOperation addDependency:operation];
            [animationArray addObject:secondOperation];
            lastOperation = secondOperation;
        }
        
    }];
    
    
    return animationArray;
}

- (TZAnimateOperation *)animationForImage:(UIImage *)image animatedLayer:(CALayer*)animatedLayer
{
    TZAnimateOperation *animation = [[TZAnimateOperation alloc]init];
    
    CALayer *imageLayer = [[CALayer alloc]init];
    if ([imageLayer respondsToSelector:@selector(setContentsScale:)])
    {
        imageLayer.contentsScale = [[UIScreen mainScreen] scale];
    }
    imageLayer.frame = CGRectMake(0, 0, image.size.width*(CGRectGetHeight([UIScreen mainScreen].bounds)/image.size.height), CGRectGetHeight([UIScreen mainScreen].bounds));
    imageLayer.contents = (__bridge id)(image.CGImage);
    
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    fadeIn.duration = 1.0f;
    fadeIn.fromValue = [NSNumber numberWithFloat:0.0];
    fadeIn.toValue = [NSNumber numberWithFloat:1.0];
    fadeIn.beginTime = 0;
    
    animation.layer = imageLayer;
    animation.animatedLayer = animatedLayer;
    animation.animation = fadeIn;
    
    return animation;
}

- (TZAnimateOperation *)animationForText:(NSString *)text animatedLayer:(CALayer*)animatedLayer frame:(CGRect)frame withFont:(UIFont *)font
{
    TZAnimateOperation *animation = [[TZAnimateOperation alloc]init];
    
    CATextLayer *layer = [[CATextLayer alloc]init];
    if ([layer respondsToSelector:@selector(setContentsScale:)])
    {
        layer.contentsScale = [[UIScreen mainScreen] scale];
    }
    layer.frame = frame;
    layer.font = (__bridge CFTypeRef)(font);
    layer.fontSize = font.pointSize;
    layer.string = text;
    layer.foregroundColor = [UIColor blackColor].CGColor;
    
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    fadeIn.duration = 0.33;
    fadeIn.fromValue = [NSNumber numberWithFloat:0.0];
    fadeIn.toValue = [NSNumber numberWithFloat:1.0];
    fadeIn.beginTime = 0;
    
    animation.animation = fadeIn;
    animation.layer = layer;
    animation.animatedLayer = animatedLayer;
    
    return animation;
}

-(CGSize)getSizeForText:(NSString *)text forFont:(UIFont *)font
{
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:font forKey: NSFontAttributeName];
    CGSize size = [text boundingRectWithSize:CGSizeMake(200.f, 200.f)
                                     options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                  attributes:stringAttributes context:nil].size;
    return CGSizeMake(size.width + 1, size.height + 1);
}

@end
