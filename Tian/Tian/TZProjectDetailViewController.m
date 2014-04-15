//
//  TZProjectDetailViewController.m
//  Tian
//
//  Created by Khaos Tian on 4/5/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "TZProjectDetailViewController.h"
#import "TZHWProject.h"
#import "TZAppProject.h"
#import "TZImageViewController.h"
#import "TZBlurTransitionAnimator.h"

@interface TZProjectDetailViewController ()<UIViewControllerTransitioningDelegate>{
    NSMutableArray      *_imageViews;
}
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

- (IBAction)closeDetailView:(id)sender;

@end

@implementation TZProjectDetailViewController

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
    
    _contentScrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    _contentScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0);
    
    _imageViews = [[NSMutableArray alloc]initWithCapacity:5];
    _imageScrollView.alwaysBounceHorizontal = YES;
    
    if ([_project isKindOfClass:[TZAppProject class]]) {
        //Customize View for App
        
        TZAppProject *project = (TZAppProject *)_project;
        
        [_nameLabel setText:project.name];
        [_descriptionTextView setText:project.detailDescription];
        
        [_iconView setImage:project.icon];
        [_statusLabel setText:@"In Progress"];
        
        [self setupAppImageView];
        
    }else{
        //Customize View for HW
        TZHWProject *project = (TZHWProject *)_project;
        
        [_nameLabel setText:project.name];
        [_descriptionTextView setText:project.detailDescription];
        [_iconView setImage:project.icon];
        [_statusLabel setText:@""];
        
        [self setupHWImageView];
    }

}

- (void)setupHWImageView
{
    TZHWProject *project = (TZHWProject *)_project;
    
    _imageScrollView.pagingEnabled = YES;
    
    //Setup Image Views;
    NSInteger numberOfImages = 0;
    if (project.images != nil) {
        numberOfImages = project.images.count;
    }
    
    
    for (int i = 0; i < numberOfImages; i++) {
        UIImage *image = [UIImage imageNamed:[[project images]objectAtIndex:i]];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(320*i, 0, 320, 240)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.image = image;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayLargeImage:)]];
        [_imageScrollView addSubview:imageView];
        _imageViews[i] = imageView;
        
    }
    _imageScrollView.contentSize = CGSizeMake(320*numberOfImages, 240);
}

- (void)setupAppImageView
{
    TZAppProject *project = (TZAppProject *)_project;
    
    //Setup Image Views;
    NSInteger numberOfImages = 0;
    if (project.images != nil) {
        numberOfImages = project.images.count;
    }
    
    
    CGFloat contentWidth = 10;
    
    for (int i = 0; i < numberOfImages; i++) {
        UIImage *image = [UIImage imageNamed:[[project images]objectAtIndex:i]];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(contentWidth, 2, (image.size.width*(236.0/image.size.height)), 236)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView.image = image;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayLargeImage:)]];
        [_imageScrollView addSubview:imageView];
        _imageViews[i] = imageView;
        
        contentWidth += CGRectGetWidth(imageView.bounds) + 10;
    }
    _imageScrollView.contentSize = CGSizeMake(contentWidth, 240);
}

- (void)displayLargeImage:(UIGestureRecognizer *)sender
{
    UIImageView *view = (UIImageView *)sender.view;
    TZImageViewController *vc = [[TZImageViewController alloc]initWithNibName:nil bundle:nil];
    [vc setImage:view.image];
    vc.transitioningDelegate = self;
    vc.modalPresentationCapturesStatusBarAppearance = YES;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeDetailView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    
    TZBlurTransitionAnimator *animator = [TZBlurTransitionAnimator new];
    animator.presenting = YES;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    TZBlurTransitionAnimator *animator = [TZBlurTransitionAnimator new];
    return animator;
}

@end
