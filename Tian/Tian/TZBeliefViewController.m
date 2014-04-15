//
//  TZBeliefViewController.m
//  Tian
//
//  Created by Khaos Tian on 4/6/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "TZBeliefViewController.h"
#import "TZAnimateOperation.h"

#import "TZStage1Creator.h"
#import "TZStage2Creator.h"
#import "TZStage3Creator.h"
#import "TZStage4Creator.h"
#import "TZStage5Creator.h"
#import "TZStage6Creator.h"
#import "TZStage7Creator.h"

@interface TZBeliefViewController (){
    NSOperationQueue *_animationQueue;
}

@end

@implementation TZBeliefViewController

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
    self.view.clipsToBounds = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_animationQueue) {
        [_animationQueue setSuspended:YES];
    }
}

- (void)preloadAnimations
{
    if (!_animationQueue) {
        _animationQueue = [[NSOperationQueue alloc] init];
        [_animationQueue setSuspended:YES];
        
        //Stage1
        TZStage1Creator *stage1 = [[TZStage1Creator alloc]init];
        NSArray *operations1 = [stage1 groupOfAnimationsToLayer:self.view.layer];
        TZAnimateOperation *opt1_L = [operations1 lastObject];
        [_animationQueue addOperations:operations1 waitUntilFinished:NO];
        
        //Stage2
        TZStage2Creator *stage2 = [[TZStage2Creator alloc]init];
        NSArray *operations2 = [stage2 groupOfAnimationsToLayer:self.view.layer];
        TZAnimateOperation *opt2_F = [operations2 objectAtIndex:0];
        TZAnimateOperation *opt2_L = [operations2 lastObject];
        [opt2_F addDependency:opt1_L];
        [_animationQueue addOperations:operations2 waitUntilFinished:NO];
        
        //Stage3
        TZStage3Creator *stage3 = [[TZStage3Creator alloc]init];
        NSArray *operations3 = [stage3 groupOfAnimationsToLayer:self.view.layer];
        TZAnimateOperation *opt3_F = [operations3 objectAtIndex:0];
        TZAnimateOperation *opt3_L = [operations3 lastObject];
        [opt3_F addDependency:opt2_L];
        [_animationQueue addOperations:operations3 waitUntilFinished:NO];
        
        //Stage4
        TZStage4Creator *stage4 = [[TZStage4Creator alloc]init];
        NSArray *operations4 = [stage4 groupOfAnimationsToLayer:self.view.layer];
        TZAnimateOperation *opt4_F = [operations4 objectAtIndex:0];
        TZAnimateOperation *opt4_L = [operations4 lastObject];
        [opt4_F addDependency:opt3_L];
        [_animationQueue addOperations:operations4 waitUntilFinished:NO];
        
        //Stage5
        TZStage5Creator *stage5 = [[TZStage5Creator alloc]init];
        NSArray *operations5 = [stage5 groupOfAnimationsToLayer:self.view.layer];
        TZAnimateOperation *opt5_F = [operations5 objectAtIndex:0];
        TZAnimateOperation *opt5_L = [operations5 lastObject];
        [opt5_F addDependency:opt4_L];
        [_animationQueue addOperations:operations5 waitUntilFinished:NO];
        
        //Stage6
        TZStage6Creator *stage6 = [[TZStage6Creator alloc]init];
        NSArray *operations6 = [stage6 groupOfAnimationsToLayer:self.view.layer];
        TZAnimateOperation *opt6_F = [operations6 objectAtIndex:0];
        TZAnimateOperation *opt6_L = [operations6 lastObject];
        [opt6_F addDependency:opt5_L];
        [_animationQueue addOperations:operations6 waitUntilFinished:NO];
        
        //Stage7
        TZStage7Creator *stage7 = [[TZStage7Creator alloc]init];
        NSArray *operations7 = [stage7 groupOfAnimationsToLayer:self.view.layer];
        TZAnimateOperation *opt7_F = [operations7 objectAtIndex:0];
        [opt7_F addDependency:opt6_L];
        [_animationQueue addOperations:operations7 waitUntilFinished:NO];
    }
}

- (void)viewShouldStartAnimate
{
    if (_animationQueue) {
        [_animationQueue setSuspended:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
