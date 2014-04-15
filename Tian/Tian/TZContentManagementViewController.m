//
//  TZContentManagementViewController.m
//  Tian
//
//  Created by Khaos Tian on 4/4/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "TZContentManagementViewController.h"
#import "TZIntroViewController.h"
#import "TZProjectsViewController.h"
#import "TZTagViewController.h"
#import "TZBeliefViewController.h"

@interface TZContentManagementViewController ()<UIScrollViewDelegate>{
    UIScrollView    *_contentView;
    
    TZIntroViewController *_introVC;
    TZProjectsViewController *_projectVC;
    TZTagViewController      *_tagVC;
    
    TZBeliefViewController   *_beliefVC;
}

@end

@implementation TZContentManagementViewController

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
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    _contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.pagingEnabled = YES;
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.contentSize = CGSizeMake(screenSize.width*4, screenSize.height);
    _contentView.delegate = self;
    
    _introVC = [[TZIntroViewController alloc]initWithNibName:nil bundle:nil];
    [self addChildViewController:_introVC];
    [_contentView addSubview:_introVC.view];
    
    _projectVC = [[TZProjectsViewController alloc]initWithNibName:nil bundle:nil];
    _projectVC.view.frame = CGRectMake(screenSize.width*1, 0, screenSize.width, screenSize.height);
    [self addChildViewController:_projectVC];
    [_contentView addSubview:_projectVC.view];

    
    _tagVC = [[TZTagViewController alloc]initWithNibName:nil bundle:nil];
    _tagVC.view.frame = CGRectMake(screenSize.width*2, 0, screenSize.width, screenSize.height);
    [self addChildViewController:_tagVC];
    [_contentView addSubview:_tagVC.view];
    
    [self.view addSubview:_contentView];
    // Do any additional setup after loading the view.
}

- (void)preloadBeliefViewController
{
    if (!_beliefVC) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        _beliefVC = [[TZBeliefViewController alloc]initWithNibName:nil bundle:nil];
        _beliefVC.view.frame = CGRectMake(screenSize.width*3, 0, screenSize.width, screenSize.height);
        [_beliefVC preloadAnimations];
        [self addChildViewController:_beliefVC];
        [_contentView addSubview:_beliefVC.view];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = (scrollView.contentOffset.x / scrollView.bounds.size.width);
    switch (page) {
        case 1:
        {
            [_projectVC viewShouldStartAnimate];
            if (_beliefVC) {
                [_beliefVC viewDidDisappear:NO];
            }
        }
            break;
            
        case 2:
        {
            [_tagVC viewShouldStartAnimate];
            [self preloadBeliefViewController];
            if (_beliefVC) {
                [_beliefVC viewDidDisappear:NO];
            }
        }
            break;
        
        case 3:
        {
            [self preloadBeliefViewController];
            if (_beliefVC) {
                [_beliefVC viewShouldStartAnimate];
            }
        }
            break;
            
        default:
        {
            if (_beliefVC) {
                [_beliefVC viewDidDisappear:NO];
            }
        }
            break;
    }
}

@end
