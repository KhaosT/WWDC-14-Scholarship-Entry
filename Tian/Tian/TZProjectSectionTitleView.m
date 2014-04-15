//
//  TZProjectSectionTitleView.m
//  Tian
//
//  Created by Khaos Tian on 4/5/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "TZProjectSectionTitleView.h"

@implementation TZProjectSectionTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.backgroundColor = [UIColor clearColor];
        self.title.textColor = [UIColor blackColor];
        self.title.font = [UIFont fontWithName: @"HelveticaNeue-Thin" size: 24];
        self.title.adjustsFontSizeToFitWidth = YES;
        
        self.title.alpha = 0.0;
        
        [UIView animateWithDuration:1.0f animations:^{
            self.title.alpha = 1.0;
        }];
        
        [self addSubview:self.title];
    }
    return self;
}

@end
