//
//  TZAnimateOperation.h
//  Tian
//
//  Created by Khaos Tian on 4/8/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AnimationExtraBlock)(CALayer *layer);

@interface TZAnimateOperation : NSOperation

@property (nonatomic, readwrite) BOOL removeAfterFinish;
@property (nonatomic, readwrite) BOOL cleanBeforeStart;
@property (nonatomic, readwrite) BOOL fadeWhenClean;

@property (nonatomic, readwrite) BOOL insertAtBack;

@property (nonatomic, strong) NSArray *layersToFade;
@property (nonatomic, readwrite) CGFloat fadeDuration;

@property (nonatomic, strong) CALayer *layer;
@property (nonatomic, strong) CAAnimation *animation;
@property (nonatomic, assign) CALayer *animatedLayer;

@property (nonatomic, copy) AnimationExtraBlock extraBlock;

@end
