//
//  TZEduCell.m
//  Tian
//
//  Created by Khaos Tian on 4/6/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "TZEduCell.h"

@implementation TZEduCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-20, 40)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"Santa Clara University";
        titleLabel.font = [UIFont fontWithName: @"Avenir-Light" size: 20.0f];
        titleLabel.textColor = [UIColor colorWithHue:345.0/360.0 saturation:1.0 brightness:0.63 alpha:1.0];
        
        UIImageView *seal = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SCU-Seal"]];
        seal.center = CGPointMake(seal.center.x, titleLabel.center.y);
        [self.contentView addSubview:seal];
        
        [self.contentView addSubview:titleLabel];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
