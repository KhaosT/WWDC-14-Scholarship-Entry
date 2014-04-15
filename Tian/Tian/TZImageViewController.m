//
//  TZImageViewController.m
//  Tian
//
//  Created by Khaos Tian on 4/5/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "TZImageViewController.h"

@interface TZImageViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *singleTapGesture;

- (IBAction)tapView:(id)sender;

@end

@implementation TZImageViewController

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
    [_imageView setImage:_image];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapGesture];
    [_singleTapGesture requireGestureRecognizerToFail:tapGesture];
}

- (void)doubleTapped:(UITapGestureRecognizer *)tapGesture {
    if (_contentScrollView.zoomScale == 1) {
        [_contentScrollView zoomToRect:[self zoomRectForScale:2.0 withCenter:[tapGesture locationInView:_imageView]] animated:YES];
    }else {
        [_contentScrollView setZoomScale:1 animated:YES];
    }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    zoomRect.size.height = [_imageView frame].size.height / scale;
    zoomRect.size.width  = [_imageView frame].size.width  / scale;
    
    center = [_imageView convertPoint:center fromView:_contentScrollView];
    
    zoomRect.origin.x    = center.x - ((zoomRect.size.width / 2.0));
    zoomRect.origin.y    = center.y - ((zoomRect.size.height / 2.0));
    
    return zoomRect;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat top = 0, left = 0;
    if (scrollView.contentSize.width < scrollView.bounds.size.width) {
        left = (scrollView.bounds.size.width-scrollView.contentSize.width) * 0.5f;
    }
    if (scrollView.contentSize.height < scrollView.bounds.size.height) {
        top = (scrollView.bounds.size.height-scrollView.contentSize.height) * 0.5f;
    }
    scrollView.contentInset = UIEdgeInsetsMake(top, left, top, left);
}

- (IBAction)tapView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
