//
//  TZProjectsViewController.m
//  Tian
//
//  Created by Khaos Tian on 4/4/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "TZProjectsViewController.h"
#import <CoreText/CoreText.h>
#import <StoreKit/StoreKit.h>
#import "TZCore.h"
#import "TZProjectViewCell.h"
#import "TZProjectSectionTitleView.h"
#import "TZProjectDetailViewController.h"

@interface TZProjectsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,SKStoreProductViewControllerDelegate>{
    CAShapeLayer *_titleLayer;
    
    NSDictionary *_projects;
    
    NSIndexPath  *_lastPresentingIndex;
    CFTimeInterval  _lastAnimationTime;
}

@property (weak, nonatomic) IBOutlet UICollectionView *projectsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *projectsCollectionViewLayout;
@property (weak, nonatomic) IBOutlet UILabel *introText;

@end

@implementation TZProjectsViewController

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
    
    _projectsCollectionView.backgroundColor = [UIColor clearColor];
    [_projectsCollectionView registerClass:[TZProjectViewCell class] forCellWithReuseIdentifier:@"AppCell"];
    [_projectsCollectionView registerClass:[TZProjectSectionTitleView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeader"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewShouldStartAnimate
{
    if (!_titleLayer) {
        _titleLayer = [self drawText:@"Projects" onView:self.view atPosition:CGPointMake(0, 35) withFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:35.f] centered:YES duration:1.5f];
        [UIView animateWithDuration:1.33f animations:^{
            _introText.alpha = 0.0;
        } completion:^(BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_introText removeFromSuperview];
                _introText = nil;
                _projects = [[TZCore sharedCore] projects];
                [_projectsCollectionView reloadData];
                
                [self fillColorAnimation:_titleLayer duration:0.8];
                [self performSelector:@selector(nextButtonAnimation) withObject:nil afterDelay:2.0];
            });
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)drawLayerWithAnimation:(CAShapeLayer *)layer duration:(CFTimeInterval)duration
{
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = duration;
    drawAnimation.repeatCount         = 1.0;
    
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [layer addAnimation:drawAnimation forKey:@"drawAnimation"];
}

- (CAShapeLayer *)drawText:(NSString *)text onView:(UIView *)view atPosition:(CGPoint)position withFont:(UIFont *)drawFont centered:(BOOL)centered duration:(CFTimeInterval)duration
{
    CGMutablePathRef letters = CGPathCreateMutable();
    
    CGFloat size = drawFont.pointSize;
    
    
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)drawFont.fontName, size, NULL);
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)font, kCTFontAttributeName,
                           nil];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text
                                                                     attributes:attrs];
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
	CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
    {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            
            {
                CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(letters, &t, letter);
                CGPathRelease(letter);
            }
        }
    }
    CFRelease(line);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    
    CGPathRelease(letters);
    CFRelease(font);
    
    CGRect pathRect = CGPathGetBoundingBox(path.CGPath);
    
    if (centered) {
        position.x = CGRectGetMidX(view.bounds) - (CGRectGetWidth(pathRect)/2);
    }
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
	pathLayer.bounds = pathRect;
    pathLayer.frame = CGRectMake(position.x, position.y, CGRectGetWidth(pathLayer.bounds), CGRectGetHeight(pathLayer.bounds));
    pathLayer.geometryFlipped = YES;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [[UIColor blackColor] CGColor];
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 0.5f;
    pathLayer.lineJoin = kCALineJoinBevel;
    
    [self drawLayerWithAnimation:pathLayer duration:duration];
    
    [view.layer addSublayer:pathLayer];

    return pathLayer;
}

- (void)presentAppStoreProductViewWithProject:(TZAppProject *)project indexPath:(NSIndexPath *)indexPath
{
    if (_lastPresentingIndex) {
        TZProjectViewCell *cell = (TZProjectViewCell *)[_projectsCollectionView cellForItemAtIndexPath:_lastPresentingIndex];
        
        [cell stopLoadingIndicator];
    }
    
    TZProjectViewCell *cell = (TZProjectViewCell *)[_projectsCollectionView cellForItemAtIndexPath:indexPath];
    
    [cell startLoadingIndicator];
    
    _lastPresentingIndex = indexPath;
    
    SKStoreProductViewController *storeViewController =
    [[SKStoreProductViewController alloc] init];
    
    storeViewController.delegate = self;
    
    NSDictionary *parameters =
    @{SKStoreProductParameterITunesItemIdentifier:project.appID};
    
    [storeViewController loadProductWithParameters:parameters completionBlock:^(BOOL result, NSError *error) {
        TZProjectViewCell *cell = (TZProjectViewCell *)[_projectsCollectionView cellForItemAtIndexPath:indexPath];
        [cell stopLoadingIndicator];
        if (result) {
            if (_lastPresentingIndex && _lastPresentingIndex.item != indexPath.item) {
                NSLog(@"Dismiss Current Operation");
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:storeViewController animated:YES completion:nil];
                });
            }
        }else{
            NSString *errorMessage;
            
            if (error.code == 5) {
                errorMessage = [NSString stringWithFormat:@"Sorry, but currently we encountered a problem loading data from iTunes Store"];
            }else{
                errorMessage = error.localizedDescription;
            }
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [alert show];
            });
        }
        _lastPresentingIndex = nil;
    }];
}

- (void)presentCustomProjectViewControllerWithProject:(TZProject *)project
{
    _lastPresentingIndex = nil;
    TZProjectDetailViewController *vc = [[TZProjectDetailViewController alloc]initWithNibName:nil bundle:nil];
    [vc setProject:project];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (_projects) {
        return [_projects allKeys].count;
    }else{
        return 0;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    TZProjectSectionTitleView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SectionHeader" forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            header.title.text = @"Software";
            break;
            
        case 1:
            header.title.text = @"Hardware";
            break;
            
        default:
            break;
    }
    return header;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (!_projects) {
        return 0;
    }
    
    switch (section) {
        case 0:
            return [[_projects objectForKey:@"software"] count];
            break;
            
        case 1:
            return [[_projects objectForKey:@"hardware"] count];
            break;
            
        default:
            return 0;
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TZProjectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AppCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        TZAppProject *project = [[_projects objectForKey:@"software"] objectAtIndex:indexPath.item];
        [cell setTitle:project.name andImage:project.icon];
        [cell setProject:project];
    }else{
        TZHWProject *project = [[_projects objectForKey:@"hardware"] objectAtIndex:indexPath.item];
        [cell setTitle:project.name andImage:project.icon];
        [cell setProject:project];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([[(TZProjectViewCell *)[collectionView cellForItemAtIndexPath:indexPath] project]isKindOfClass:[TZAppProject class]]) {
            TZAppProject *project = (TZAppProject *)[(TZProjectViewCell *)[collectionView cellForItemAtIndexPath:indexPath] project];
            if (project.availableInAppStore) {
                [self presentAppStoreProductViewWithProject:project indexPath:indexPath];
            }else{
                [self presentCustomProjectViewControllerWithProject:project];
            }
        }
    }else{
        TZHWProject *project = (TZHWProject *)[(TZProjectViewCell *)[collectionView cellForItemAtIndexPath:indexPath] project];
        [self presentCustomProjectViewControllerWithProject:project];
    }
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
