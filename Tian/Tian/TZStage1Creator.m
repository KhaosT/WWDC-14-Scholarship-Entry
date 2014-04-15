//
//  TZStage1Creator.m
//  Tian
//
//  Created by Khaos Tian on 4/10/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "TZStage1Creator.h"
#import "TZAnimateOperation.h"
#import <QuartzCore/QuartzCore.h>

@implementation TZStage1Creator

- (NSArray *)groupOfAnimationsToLayer:(CALayer *)layer
{
    NSMutableArray *animationArray = [[NSMutableArray alloc]init];
    
    NSString *script = @"There is always something matters to us.";
    NSArray  *strings = [script componentsSeparatedByString:@" "];
    
    UIFont *font = [UIFont fontWithName: @"HelveticaNeue-Thin" size: 30.f];
    
    __block CGFloat currentX = 20;
    __block CGFloat currentY = CGRectGetMidY([UIScreen mainScreen].bounds) - 80;
    
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
        }
        
        currentX += size.width + 5;
        
        lastOperation = operation;
        [animationArray addObject:operation];
    }];

    lastOperation.animation.duration = 0.66;
    
    return animationArray;
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
