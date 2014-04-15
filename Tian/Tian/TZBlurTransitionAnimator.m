//
//  TZBlurTransitionAnimator.m
//  Tian
//
//  Created by Khaos Tian on 4/5/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "TZBlurTransitionAnimator.h"
#import "UIImage+Utilities.h"

@implementation TZBlurTransitionAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    CGRect endFrame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    
    if (self.presenting) {
        fromViewController.view.userInteractionEnabled = NO;
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        toViewController.view.alpha = 0.0;
        CGRect startFrame = endFrame;
        startFrame.origin.y += 240;
        
        toViewController.view.frame = startFrame;
        
        UIGraphicsBeginImageContextWithOptions(fromViewController.view.bounds.size, NO, 0);
        
        [fromViewController.view drawViewHierarchyInRect:fromViewController.view.bounds afterScreenUpdates:YES];
        
        UIImage *copied = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImage *backgroundBlurredImage = [copied blurredImageWithRadius:20 iterations:10 tintColor:[UIColor darkGrayColor]];
        
        UIImageView *blurView = nil;
        if (backgroundBlurredImage) {
            blurView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
            [blurView setImage:backgroundBlurredImage];
            blurView.alpha = 0.0;
            blurView.tag = 1258;
            [fromViewController.view addSubview:blurView];
        }
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
            if (blurView) {
                blurView.alpha = 1.0;
            }
            toViewController.view.alpha = 1.0;
            toViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    else {
        toViewController.view.userInteractionEnabled = YES;
        fromViewController.view.alpha = 1.0;
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];
        
        endFrame.origin.y += 240;
        
        UIView *blurView = [toViewController.view viewWithTag:1258];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
            if (blurView) {
                blurView.alpha = 0.0;
            }
            fromViewController.view.alpha = 0.0;
            fromViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            [blurView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
