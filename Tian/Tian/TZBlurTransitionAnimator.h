//
//  TZBlurTransitionAnimator.h
//  Tian
//
//  Created by Khaos Tian on 4/5/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TZBlurTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, getter = isPresenting) BOOL presenting;

@end