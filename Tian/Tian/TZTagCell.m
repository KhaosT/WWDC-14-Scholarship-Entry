//
//  TZTagCell.m
//  Tian
//
//  Created by Khaos Tian on 4/6/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "TZTagCell.h"

@interface TZTagCell (){
    UIImageView     *_background;
}

@property (strong,nonatomic) UILabel *label;

@end

@implementation TZTagCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        _background = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"tag-bg"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        _background.tintColor = [self randomColor];//[UIColor colorWithHue:199.0/360.0 saturation:0.64 brightness:1.0 alpha:1.0];
        [self.contentView addSubview:_background];
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont fontWithName: @"Avenir-Light" size: 14.0f];
        _label.textColor = _background.tintColor;
        
        [self.contentView addSubview:_label];
    }
    return self;
}

-(void)setText:(NSString *)text
{
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName: @"Avenir-Light" size: 14.0f] forKey: NSFontAttributeName];
    CGSize size = [text boundingRectWithSize:CGSizeMake(200.0f, 2000.0f)
                                                     options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:stringAttributes context:nil].size;
    
    _background.frame = CGRectMake(0, 0, size.width + 10, size.height+5);
    _label.frame = CGRectMake(5, 3, size.width, size.height);
    _label.text = text;
}

- (UIColor *)randomColor{
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 512.0 ) + 0.5;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

@end
