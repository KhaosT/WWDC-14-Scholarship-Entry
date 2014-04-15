//
//  TZAnimateOperation.m
//  Tian
//
//  Created by Khaos Tian on 4/8/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "TZAnimateOperation.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/message.h>

@interface TZAnimateOperation (){
    BOOL _isFinished;
    
    BOOL _removeInProgress;
    
    int  _itemInRemoving;
}

@end

@implementation TZAnimateOperation

- (id)init
{
    self = [super init];
    if (self) {
        _isFinished = NO;
        _itemInRemoving = 0;
        _fadeDuration = 0.33;
    }
    return self;
}

- (void)main
{
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    if (_animatedLayer && _cleanBeforeStart) {
        if (_fadeWhenClean) {
            if (_animatedLayer.sublayers && _animatedLayer.sublayers.count > 0) {
                _removeInProgress = YES;
                for (CALayer *layer in _animatedLayer.sublayers) {
                    [self fadeOutLayer:layer];
                }
            }
        }
        while (_removeInProgress) {
            
        }
        _animatedLayer.sublayers = nil;
    }
    
    if (_layersToFade && _layersToFade.count > 0) {
        _removeInProgress = YES;
        for (CALayer *layer in _layersToFade) {
            [self fadeOutLayer:layer];
        }
    }
    while (_removeInProgress) {
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_animatedLayer && _cleanBeforeStart) {
            _animatedLayer.sublayers = nil;
        }
        if (_layer && _animation) {
            _animation.delegate = self;
            if (_extraBlock) {
                _extraBlock(_layer);
            }
            [_layer addAnimation:_animation forKey:@"animation"];
            if (![[_animatedLayer sublayers]containsObject:_layer]) {
                if (_insertAtBack) {
                    [_animatedLayer insertSublayer:_layer atIndex:0];
                }else{
                    [_animatedLayer addSublayer:_layer];
                }
            }
        }
    });
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)fadeOutLayer:(CALayer *)layer
{
    _itemInRemoving++;
    CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    fadeOut.duration = _fadeDuration;
    fadeOut.fromValue = [NSNumber numberWithFloat:1.0];
    fadeOut.toValue = [NSNumber numberWithFloat:0.0];
    fadeOut.beginTime = 0;
    fadeOut.removedOnCompletion = NO;
    fadeOut.delegate = self;
    [fadeOut setValue:@"1" forKey:@"FadeOutAnimation"];
    layer.opacity = 0.0;
    dispatch_async(dispatch_get_main_queue(), ^{
        [layer addAnimation:fadeOut forKey:@"FadeOut"];
    });
}

- (BOOL)isExecuting
{
    return !_isFinished;
}

- (BOOL)isFinished
{
    return _isFinished;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([anim valueForKey:@"FadeOutAnimation"]) {
        _itemInRemoving--;
        if (_itemInRemoving == 0) {
            if (_layersToFade) {
                for (CALayer *layer in _layersToFade) {
                    [layer removeFromSuperlayer];
                }
                _layersToFade = nil;
            }
            _removeInProgress = NO;
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_layer) {
                if (_removeAfterFinish) {
                    [_layer removeFromSuperlayer];
                    _layer = nil;
                    _animatedLayer = nil;
                }
            }
        });
        [self willChangeValueForKey:@"isFinished"];
        _isFinished = YES;
        [self didChangeValueForKey:@"isFinished"];
    }
}

@end
