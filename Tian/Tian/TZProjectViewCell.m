//
//  TZProjectViewCell.m
//  Tian
//
//  Created by Khaos Tian on 4/5/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "TZProjectViewCell.h"
#import "TZProjectIconView.h"

@interface TZProjectViewCell (){
    TZProjectIconView *_iconView;
    
    UIActivityIndicatorView *_loadingIndicator;
}

@end

@implementation TZProjectViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _loadingIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _loadingIndicator.hidesWhenStopped = YES;
        _loadingIndicator.center = CGPointMake(30, 30);
        [self.contentView addSubview:_loadingIndicator];
    }
    return self;
}

- (void)startLoadingIndicator
{
    [_loadingIndicator startAnimating];
}

- (void)stopLoadingIndicator
{
    [_loadingIndicator stopAnimating];
}

- (void)setTitle:(NSString *)title andImage:(UIImage *)image
{
    [_loadingIndicator stopAnimating];
    if (_iconView) {
        [_iconView removeFromSuperview];
    }
    _iconView = [[TZProjectIconView alloc]initWithFrame:CGRectMake(0, 0, 60, 80) image:image title:title];
    [self.contentView insertSubview:_iconView belowSubview:_loadingIndicator];
}

@end
