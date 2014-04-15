//
//  TZStage7Creator.m
//  Tian
//
//  Created by Khaos Tian on 4/10/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "TZStage7Creator.h"
#import "TZAnimateOperation.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@implementation TZStage7Creator

- (NSArray *)groupOfAnimationsToLayer:(CALayer *)layer
{
    NSMutableArray *animationArray = [[NSMutableArray alloc]init];
    
    NSArray *strings = @[@"Write the code.",@"Change the world."];
    
    UIFont *font = [UIFont fontWithName: @"HelveticaNeue-Thin" size: 30.f];
    
    __block CGFloat currentX = 20;
    __block CGFloat currentY = CGRectGetMidY([UIScreen mainScreen].bounds) + 20;
    __block TZAnimateOperation *lastOperation = nil;

    NSString *title = @"WWDC 14";
    
    CGSize size = [self getSizeForText:title forFont:font];
    currentX = (CGRectGetWidth([UIScreen mainScreen].bounds)/2) - (size.width/2);
    
    TZAnimateOperation *titleAnimation = [self animationForText:title
                                                  animatedLayer:layer
                                                          frame:CGRectMake(currentX, CGRectGetMidY([UIScreen mainScreen].bounds) - size.height - 20, size.width, size.height)
                                                       withFont:font];
    
    titleAnimation.cleanBeforeStart = YES;
    titleAnimation.fadeWhenClean = YES;
    
    [animationArray addObject:titleAnimation];
    
    lastOperation = titleAnimation;
    
    TZAnimateOperation *bgOperation = [self animationForImage:[UIImage imageNamed:@"end.png"] animatedLayer:layer];
    
    bgOperation.insertAtBack = YES;
    
    if (lastOperation) {
        [bgOperation addDependency:lastOperation];
        [animationArray addObject:bgOperation];
    }
    
    [strings enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGSize size = [self getSizeForText:obj forFont:font];
        currentX = (CGRectGetWidth([UIScreen mainScreen].bounds)/2) - (size.width/2);

        TZAnimateOperation *operation = [self animationForText:obj
                                                 animatedLayer:layer
                                                         frame:CGRectMake(currentX, currentY, size.width, size.height)
                                                      withFont:font];
        currentY += size.height + 10;
        
        if (lastOperation) {
            [operation addDependency:lastOperation];
        }else{
            operation.fadeWhenClean = YES;
            operation.cleanBeforeStart = YES;
        }
        
        lastOperation = operation;
        [animationArray addObject:operation];
    }];
    
    CAShapeLayer *atom = [CAShapeLayer layer];
    
    UIBezierPath* bezierPath = [self pathForAtom];
    
    atom.path = bezierPath.CGPath;
    atom.position = CGPointMake(CGRectGetMidX(layer.bounds) - 20,CGRectGetMaxY(layer.bounds) - 60);
    atom.lineWidth = 0.5;
    
    atom.fillColor = [UIColor clearColor].CGColor;
    atom.strokeColor = [UIColor blackColor].CGColor;
    
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = 1.0;
    drawAnimation.repeatCount         = 1.0;
    
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *fillAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    fillAnimation.duration            = 1.5;
    fillAnimation.repeatCount         = 1.0;
    
    fillAnimation.fromValue = (__bridge id)([UIColor colorWithWhite:0.0 alpha:0.0].CGColor);
    fillAnimation.toValue   = (__bridge id)([UIColor colorWithWhite:0.0 alpha:1.0].CGColor);
    
    fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 1.5;
    animationGroup.animations = @[fillAnimation,drawAnimation];
    
    TZAnimateOperation *endOperation = [[TZAnimateOperation alloc]init];
    endOperation.layer = atom;
    endOperation.animatedLayer = layer;
    endOperation.animation = animationGroup;
    endOperation.extraBlock = ^(CALayer *blockLayer){
        [(CAShapeLayer *)blockLayer setFillColor:[UIColor colorWithWhite:0.0 alpha:1.0].CGColor];
    };
    
    [endOperation addDependency:lastOperation];
    
    [animationArray addObject:endOperation];
    
    lastOperation = endOperation;
    
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
    fadeIn.duration = 0.66;
    fadeIn.fromValue = [NSNumber numberWithFloat:0.0];
    fadeIn.toValue = [NSNumber numberWithFloat:1.0];
    fadeIn.beginTime = 0;
    
    animation.animation = fadeIn;
    animation.layer = layer;
    animation.animatedLayer = animatedLayer;
    
    return animation;
}

- (TZAnimateOperation *)animationForTitle:(NSString *)title animatedLayer:(CALayer*)animatedLayer frame:(CGRect)frame withFont:(UIFont *)drawFont
{
    TZAnimateOperation *animation = [[TZAnimateOperation alloc]init];
    CGMutablePathRef letters = CGPathCreateMutable();
    
    CGFloat size = drawFont.pointSize;
    
    
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)drawFont.fontName, size, NULL);
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)font, kCTFontAttributeName,
                           nil];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:title
                                                                     attributes:attrs];
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
	CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
    {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            
            {
                CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(letters, &t, letter);
                CGPathRelease(letter);
            }
        }
    }
    CFRelease(line);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    
    CGPathRelease(letters);
    CFRelease(font);
    
    CGRect pathRect = CGPathGetBoundingBox(path.CGPath);
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
	pathLayer.bounds = pathRect;
    pathLayer.frame = frame;
    pathLayer.geometryFlipped = YES;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [[UIColor blackColor] CGColor];
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 0.5f;
    pathLayer.lineJoin = kCALineJoinBevel;
    
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = 1.0;
    
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    animation.animatedLayer = animatedLayer;
    animation.layer = pathLayer;
    animation.animation = drawAnimation;
    
    return animation;
}

-(CGSize)getSizeForText:(NSString *)text forFont:(UIFont *)font
{
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:font forKey: NSFontAttributeName];
    CGSize size = [text boundingRectWithSize:CGSizeMake(2000.f, 2000.f)
                                     options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                  attributes:stringAttributes context:nil].size;
    return CGSizeMake(size.width + 1, size.height + 1);
}

- (UIBezierPath *)pathForAtom
{
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(19.97, 18.41)];
    [bezierPath addCurveToPoint: CGPointMake(18.47, 19.9) controlPoint1: CGPointMake(19.22, 18.41) controlPoint2: CGPointMake(18.47, 19.01)];
    [bezierPath addCurveToPoint: CGPointMake(19.97, 21.39) controlPoint1: CGPointMake(18.47, 20.64) controlPoint2: CGPointMake(19.07, 21.39)];
    [bezierPath addCurveToPoint: CGPointMake(21.47, 19.9) controlPoint1: CGPointMake(20.72, 21.39) controlPoint2: CGPointMake(21.47, 20.79)];
    [bezierPath addCurveToPoint: CGPointMake(19.97, 18.41) controlPoint1: CGPointMake(21.47, 19.16) controlPoint2: CGPointMake(20.72, 18.41)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(33.78, 19.9)];
    [bezierPath addCurveToPoint: CGPointMake(37.38, 9.95) controlPoint1: CGPointMake(37.23, 16.04) controlPoint2: CGPointMake(38.74, 12.33)];
    [bezierPath addCurveToPoint: CGPointMake(26.88, 8.02) controlPoint1: CGPointMake(36.03, 7.57) controlPoint2: CGPointMake(31.98, 6.98)];
    [bezierPath addCurveToPoint: CGPointMake(19.97, 0) controlPoint1: CGPointMake(25.37, 3.12) controlPoint2: CGPointMake(22.82, 0)];
    [bezierPath addCurveToPoint: CGPointMake(13.06, 8.02) controlPoint1: CGPointMake(17.12, 0) controlPoint2: CGPointMake(14.57, 3.12)];
    [bezierPath addCurveToPoint: CGPointMake(2.56, 9.95) controlPoint1: CGPointMake(7.96, 6.98) controlPoint2: CGPointMake(3.91, 7.57)];
    [bezierPath addCurveToPoint: CGPointMake(6.16, 19.9) controlPoint1: CGPointMake(1.05, 12.33) controlPoint2: CGPointMake(2.71, 16.04)];
    [bezierPath addCurveToPoint: CGPointMake(2.56, 29.85) controlPoint1: CGPointMake(2.71, 23.76) controlPoint2: CGPointMake(1.2, 27.47)];
    [bezierPath addCurveToPoint: CGPointMake(13.06, 31.78) controlPoint1: CGPointMake(3.91, 32.23) controlPoint2: CGPointMake(7.96, 32.82)];
    [bezierPath addCurveToPoint: CGPointMake(19.97, 39.8) controlPoint1: CGPointMake(14.57, 36.68) controlPoint2: CGPointMake(17.12, 39.8)];
    [bezierPath addCurveToPoint: CGPointMake(26.88, 31.78) controlPoint1: CGPointMake(22.82, 39.8) controlPoint2: CGPointMake(25.37, 36.68)];
    [bezierPath addCurveToPoint: CGPointMake(37.38, 29.85) controlPoint1: CGPointMake(31.98, 32.82) controlPoint2: CGPointMake(36.03, 32.37)];
    [bezierPath addCurveToPoint: CGPointMake(33.78, 19.9) controlPoint1: CGPointMake(38.89, 27.47) controlPoint2: CGPointMake(37.23, 23.76)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(26.73, 14.11)];
    [bezierPath addCurveToPoint: CGPointMake(24.17, 12.62) controlPoint1: CGPointMake(25.98, 13.51) controlPoint2: CGPointMake(25.07, 13.07)];
    [bezierPath addCurveToPoint: CGPointMake(21.62, 11.29) controlPoint1: CGPointMake(23.27, 12.18) controlPoint2: CGPointMake(22.37, 11.73)];
    [bezierPath addCurveToPoint: CGPointMake(25.83, 9.8) controlPoint1: CGPointMake(23.12, 10.69) controlPoint2: CGPointMake(24.47, 10.25)];
    [bezierPath addCurveToPoint: CGPointMake(26.73, 14.11) controlPoint1: CGPointMake(26.28, 10.99) controlPoint2: CGPointMake(26.58, 12.47)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(19.97, 1.49)];
    [bezierPath addCurveToPoint: CGPointMake(25.52, 8.46) controlPoint1: CGPointMake(22.22, 1.49) controlPoint2: CGPointMake(24.32, 4.16)];
    [bezierPath addCurveToPoint: CGPointMake(19.97, 10.4) controlPoint1: CGPointMake(23.72, 8.76) controlPoint2: CGPointMake(21.92, 9.5)];
    [bezierPath addCurveToPoint: CGPointMake(14.42, 8.46) controlPoint1: CGPointMake(18.02, 9.5) controlPoint2: CGPointMake(16.22, 8.91)];
    [bezierPath addCurveToPoint: CGPointMake(19.97, 1.49) controlPoint1: CGPointMake(15.62, 4.16) controlPoint2: CGPointMake(17.72, 1.49)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(13.97, 9.65)];
    [bezierPath addCurveToPoint: CGPointMake(18.17, 11.14) controlPoint1: CGPointMake(15.32, 10.1) controlPoint2: CGPointMake(16.82, 10.54)];
    [bezierPath addCurveToPoint: CGPointMake(15.62, 12.47) controlPoint1: CGPointMake(17.27, 11.58) controlPoint2: CGPointMake(16.37, 12.03)];
    [bezierPath addCurveToPoint: CGPointMake(13.06, 13.96) controlPoint1: CGPointMake(14.72, 12.92) controlPoint2: CGPointMake(13.97, 13.51)];
    [bezierPath addCurveToPoint: CGPointMake(13.97, 9.65) controlPoint1: CGPointMake(13.36, 12.47) controlPoint2: CGPointMake(13.67, 10.99)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(3.76, 10.69)];
    [bezierPath addCurveToPoint: CGPointMake(12.61, 9.36) controlPoint1: CGPointMake(4.96, 8.76) controlPoint2: CGPointMake(8.26, 8.32)];
    [bezierPath addCurveToPoint: CGPointMake(11.56, 15.15) controlPoint1: CGPointMake(12.16, 11.14) controlPoint2: CGPointMake(11.71, 13.07)];
    [bezierPath addCurveToPoint: CGPointMake(7.06, 19.01) controlPoint1: CGPointMake(9.91, 16.34) controlPoint2: CGPointMake(8.26, 17.67)];
    [bezierPath addCurveToPoint: CGPointMake(3.76, 10.69) controlPoint1: CGPointMake(4.06, 15.74) controlPoint2: CGPointMake(2.71, 12.62)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(11.41, 22.87)];
    [bezierPath addCurveToPoint: CGPointMake(7.96, 19.9) controlPoint1: CGPointMake(10.06, 21.98) controlPoint2: CGPointMake(9.01, 20.94)];
    [bezierPath addCurveToPoint: CGPointMake(11.41, 16.93) controlPoint1: CGPointMake(9.01, 18.86) controlPoint2: CGPointMake(10.06, 17.97)];
    [bezierPath addCurveToPoint: CGPointMake(11.26, 19.9) controlPoint1: CGPointMake(11.41, 17.82) controlPoint2: CGPointMake(11.26, 18.86)];
    [bezierPath addCurveToPoint: CGPointMake(11.41, 22.87) controlPoint1: CGPointMake(11.41, 20.94) controlPoint2: CGPointMake(11.41, 21.83)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(3.76, 29.11)];
    [bezierPath addCurveToPoint: CGPointMake(7.06, 20.79) controlPoint1: CGPointMake(2.56, 27.18) controlPoint2: CGPointMake(4.06, 24.06)];
    [bezierPath addCurveToPoint: CGPointMake(11.56, 24.65) controlPoint1: CGPointMake(8.41, 22.13) controlPoint2: CGPointMake(9.91, 23.32)];
    [bezierPath addCurveToPoint: CGPointMake(12.61, 30.44) controlPoint1: CGPointMake(11.71, 26.73) controlPoint2: CGPointMake(12.16, 28.66)];
    [bezierPath addCurveToPoint: CGPointMake(3.76, 29.11) controlPoint1: CGPointMake(8.26, 31.48) controlPoint2: CGPointMake(4.96, 31.04)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(13.21, 25.69)];
    [bezierPath addCurveToPoint: CGPointMake(15.77, 27.18) controlPoint1: CGPointMake(13.97, 26.29) controlPoint2: CGPointMake(14.87, 26.73)];
    [bezierPath addCurveToPoint: CGPointMake(18.32, 28.51) controlPoint1: CGPointMake(16.67, 27.62) controlPoint2: CGPointMake(17.57, 28.07)];
    [bezierPath addCurveToPoint: CGPointMake(14.12, 30) controlPoint1: CGPointMake(16.82, 29.11) controlPoint2: CGPointMake(15.47, 29.55)];
    [bezierPath addCurveToPoint: CGPointMake(13.21, 25.69) controlPoint1: CGPointMake(13.67, 28.81) controlPoint2: CGPointMake(13.36, 27.33)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(19.97, 38.31)];
    [bezierPath addCurveToPoint: CGPointMake(14.42, 31.34) controlPoint1: CGPointMake(17.72, 38.31) controlPoint2: CGPointMake(15.62, 35.64)];
    [bezierPath addCurveToPoint: CGPointMake(19.97, 29.4) controlPoint1: CGPointMake(16.22, 30.89) controlPoint2: CGPointMake(18.17, 30.15)];
    [bezierPath addCurveToPoint: CGPointMake(25.52, 31.34) controlPoint1: CGPointMake(21.92, 30.3) controlPoint2: CGPointMake(23.72, 30.89)];
    [bezierPath addCurveToPoint: CGPointMake(19.97, 38.31) controlPoint1: CGPointMake(24.32, 35.64) controlPoint2: CGPointMake(22.22, 38.31)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(25.98, 30.15)];
    [bezierPath addCurveToPoint: CGPointMake(21.77, 28.66) controlPoint1: CGPointMake(24.62, 29.7) controlPoint2: CGPointMake(23.12, 29.26)];
    [bezierPath addCurveToPoint: CGPointMake(24.32, 27.33) controlPoint1: CGPointMake(22.67, 28.22) controlPoint2: CGPointMake(23.57, 27.77)];
    [bezierPath addCurveToPoint: CGPointMake(26.88, 25.84) controlPoint1: CGPointMake(25.22, 26.88) controlPoint2: CGPointMake(25.98, 26.29)];
    [bezierPath addCurveToPoint: CGPointMake(25.98, 30.15) controlPoint1: CGPointMake(26.58, 27.33) controlPoint2: CGPointMake(26.28, 28.81)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(27.03, 23.91)];
    [bezierPath addCurveToPoint: CGPointMake(23.57, 25.99) controlPoint1: CGPointMake(25.98, 24.65) controlPoint2: CGPointMake(24.77, 25.39)];
    [bezierPath addCurveToPoint: CGPointMake(19.97, 27.77) controlPoint1: CGPointMake(22.37, 26.73) controlPoint2: CGPointMake(21.17, 27.33)];
    [bezierPath addCurveToPoint: CGPointMake(16.37, 25.99) controlPoint1: CGPointMake(18.77, 27.18) controlPoint2: CGPointMake(17.57, 26.58)];
    [bezierPath addCurveToPoint: CGPointMake(12.91, 23.91) controlPoint1: CGPointMake(15.17, 25.25) controlPoint2: CGPointMake(13.97, 24.5)];
    [bezierPath addCurveToPoint: CGPointMake(12.76, 19.9) controlPoint1: CGPointMake(12.76, 22.57) controlPoint2: CGPointMake(12.76, 21.24)];
    [bezierPath addCurveToPoint: CGPointMake(12.91, 15.89) controlPoint1: CGPointMake(12.76, 18.56) controlPoint2: CGPointMake(12.91, 17.23)];
    [bezierPath addCurveToPoint: CGPointMake(16.37, 13.81) controlPoint1: CGPointMake(13.97, 15.15) controlPoint2: CGPointMake(15.17, 14.41)];
    [bezierPath addCurveToPoint: CGPointMake(19.97, 11.88) controlPoint1: CGPointMake(17.57, 13.22) controlPoint2: CGPointMake(18.77, 12.47)];
    [bezierPath addCurveToPoint: CGPointMake(23.57, 13.66) controlPoint1: CGPointMake(21.17, 12.47) controlPoint2: CGPointMake(22.37, 13.07)];
    [bezierPath addCurveToPoint: CGPointMake(27.03, 15.74) controlPoint1: CGPointMake(24.77, 14.41) controlPoint2: CGPointMake(25.98, 15.15)];
    [bezierPath addCurveToPoint: CGPointMake(27.18, 19.75) controlPoint1: CGPointMake(27.18, 17.08) controlPoint2: CGPointMake(27.18, 18.41)];
    [bezierPath addCurveToPoint: CGPointMake(27.03, 23.91) controlPoint1: CGPointMake(27.18, 21.24) controlPoint2: CGPointMake(27.03, 22.57)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(36.18, 10.69)];
    [bezierPath addCurveToPoint: CGPointMake(32.88, 19.01) controlPoint1: CGPointMake(37.38, 12.62) controlPoint2: CGPointMake(35.88, 15.74)];
    [bezierPath addCurveToPoint: CGPointMake(28.38, 15.15) controlPoint1: CGPointMake(31.53, 17.67) controlPoint2: CGPointMake(30.03, 16.48)];
    [bezierPath addCurveToPoint: CGPointMake(27.33, 9.36) controlPoint1: CGPointMake(28.23, 13.07) controlPoint2: CGPointMake(27.78, 11.14)];
    [bezierPath addCurveToPoint: CGPointMake(36.18, 10.69) controlPoint1: CGPointMake(31.68, 8.32) controlPoint2: CGPointMake(34.98, 8.76)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(28.53, 16.93)];
    [bezierPath addCurveToPoint: CGPointMake(31.98, 19.9) controlPoint1: CGPointMake(29.88, 17.82) controlPoint2: CGPointMake(30.93, 18.86)];
    [bezierPath addCurveToPoint: CGPointMake(28.53, 22.87) controlPoint1: CGPointMake(30.93, 20.94) controlPoint2: CGPointMake(29.88, 21.83)];
    [bezierPath addCurveToPoint: CGPointMake(28.68, 19.9) controlPoint1: CGPointMake(28.53, 21.98) controlPoint2: CGPointMake(28.68, 20.94)];
    [bezierPath addCurveToPoint: CGPointMake(28.53, 16.93) controlPoint1: CGPointMake(28.53, 18.86) controlPoint2: CGPointMake(28.53, 17.97)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(36.18, 29.11)];
    [bezierPath addCurveToPoint: CGPointMake(27.33, 30.44) controlPoint1: CGPointMake(34.98, 31.04) controlPoint2: CGPointMake(31.68, 31.48)];
    [bezierPath addCurveToPoint: CGPointMake(28.38, 24.65) controlPoint1: CGPointMake(27.78, 28.66) controlPoint2: CGPointMake(28.23, 26.73)];
    [bezierPath addCurveToPoint: CGPointMake(32.88, 20.79) controlPoint1: CGPointMake(30.03, 23.46) controlPoint2: CGPointMake(31.68, 22.13)];
    [bezierPath addCurveToPoint: CGPointMake(36.18, 29.11) controlPoint1: CGPointMake(35.88, 24.06) controlPoint2: CGPointMake(37.23, 27.18)];
    [bezierPath closePath];
    return bezierPath;
}

@end
