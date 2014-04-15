//
//  TZTagViewController.m
//  Tian
//
//  Created by Khaos Tian on 4/6/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "TZTagViewController.h"
#import "TZProjectSectionTitleView.h"
#import "TZCore.h"
#import "TZTagCell.h"
#import "TZEduCell.h"

@interface TZTagViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    UICollectionView        *_detailTagsViewController;
    NSDictionary            *_details;
        
    CFTimeInterval  _lastAnimationTime;
}

@end

@implementation TZTagViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _details = [[TZCore sharedCore]tags];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.headerReferenceSize = CGSizeMake(160, 44);
    layout.minimumInteritemSpacing = 5.0f;
    layout.minimumLineSpacing = 1.0f;
    layout.sectionInset = UIEdgeInsetsMake(7, 7, 7, 7);
    
    _detailTagsViewController = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
    _detailTagsViewController.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
    _detailTagsViewController.backgroundColor = [UIColor whiteColor];
    [_detailTagsViewController registerClass:[TZEduCell class] forCellWithReuseIdentifier:@"EduCell"];
    [_detailTagsViewController registerClass:[TZTagCell class] forCellWithReuseIdentifier:@"TagCell"];
    [_detailTagsViewController registerClass:[TZProjectSectionTitleView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    _detailTagsViewController.delegate = self;
    _detailTagsViewController.dataSource = self;
    
    [self.view addSubview:_detailTagsViewController];
}

- (void)viewShouldStartAnimate
{
    [self performSelector:@selector(nextButtonAnimation) withObject:nil afterDelay:1.0];
}

- (void)nextButtonAnimation
{
    CAShapeLayer *next = [CAShapeLayer layer];
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(57, 16)];
    [bezierPath addLineToPoint: CGPointMake(41, 41)];
    [bezierPath addLineToPoint: CGPointMake(57, 66)];
    [bezierPath addLineToPoint: CGPointMake(41, 41)];
    [bezierPath closePath];
    bezierPath.lineWidth = 2;
    
    next.path = bezierPath.CGPath;
    next.position = CGPointMake(CGRectGetWidth(self.view.bounds) - 80,
                                CGRectGetHeight(self.view.bounds)- 120);
    
    next.fillColor = [UIColor clearColor].CGColor;
    next.strokeColor = [UIColor blackColor].CGColor;
    
    [self.view.layer addSublayer:next];
    
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = 0.6;
    drawAnimation.repeatCount         = 1.0;
    
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [next addAnimation:drawAnimation forKey:@"drawNextAnimation"];
    
    
    __weak id weakSelf = self;
    
    [self addBreathAnimationForLayer:next beginTime:0];
    [[NSNotificationCenter defaultCenter]addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        _lastAnimationTime = [next convertTime:CACurrentMediaTime() fromLayer:nil];
        [next removeAllAnimations];
    }];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [weakSelf addBreathAnimationForLayer:next beginTime:[next convertTime:CACurrentMediaTime() fromLayer:nil] - _lastAnimationTime];
    }];
}

- (void)addBreathAnimationForLayer:(CALayer *)layer beginTime:(CFTimeInterval)time
{
    CABasicAnimation *breathAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    breathAnimation.duration = 2;
    breathAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    breathAnimation.toValue = [NSNumber numberWithFloat:1.0];
    breathAnimation.beginTime = time;
    breathAnimation.repeatCount = HUGE_VALF;
    breathAnimation.autoreverses = YES;
    [layer addAnimation:breathAnimation forKey:nil];
}

- (void)fillColorAnimation:(CAShapeLayer *)layer duration:(CFTimeInterval)duration
{
    CABasicAnimation *fillAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    fillAnimation.duration            = duration;
    fillAnimation.repeatCount         = 1.0;
    
    fillAnimation.fromValue = (__bridge id)([UIColor colorWithWhite:0.0 alpha:0.0].CGColor);
    fillAnimation.toValue   = (__bridge id)([UIColor colorWithWhite:0.0 alpha:1.0].CGColor);
    
    fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [layer addAnimation:fillAnimation forKey:@"fillAnimation"];
    layer.fillColor = [UIColor colorWithWhite:0.0 alpha:1.0].CGColor;
}

-(CGSize)getSizeForText:(NSString *)text
{
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName: @"Avenir-Light" size: 14.0f] forKey: NSFontAttributeName];
    CGSize size = [text boundingRectWithSize:CGSizeMake(200.0f, 2000.0f)
                                     options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                  attributes:stringAttributes context:nil].size;
    return size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(300, 45);
    }else{
        NSString *text;
        switch (indexPath.section) {
            case 1:
            {
                text = [[_details objectForKey:@"skills"]objectAtIndex:indexPath.row];
            }
                break;
                
            case 2:
            {
                text = [[_details objectForKey:@"interests"]objectAtIndex:indexPath.row];
            }
                break;
                
            default:
                break;
        }
        CGSize size = [self getSizeForText:text];
        size.width = size.width + 10;
        size.height = size.height + 8;
        return size;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return [[_details objectForKey:@"skills"]count];
            break;
            
        case 2:
            return [[_details objectForKey:@"interests"]count];
            break;
            
        default:
            return 0;
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EduCell" forIndexPath:indexPath];
            return cell;
        }
            break;
            
        case 1:
        {
            TZTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TagCell" forIndexPath:indexPath];
            [cell setText:[[_details objectForKey:@"skills"]objectAtIndex:indexPath.row]];
            return cell;
        }
            break;
            
        case 2:
        {
            TZTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TagCell" forIndexPath:indexPath];
            [cell setText:[[_details objectForKey:@"interests"]objectAtIndex:indexPath.row]];
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    TZProjectSectionTitleView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            header.title.text = @"Education";
            break;
            
        case 1:
            header.title.text = @"Skills";
            break;
            
        case 2:
            header.title.text = @"Interests";
            break;
            
        default:
            break;
    }
    return header;
}

@end
