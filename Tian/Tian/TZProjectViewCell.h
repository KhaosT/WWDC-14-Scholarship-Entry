//
//  TZProjectViewCell.h
//  Tian
//
//  Created by Khaos Tian on 4/5/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TZProject;
@interface TZProjectViewCell : UICollectionViewCell

@property (nonatomic, assign) TZProject *project;

- (void)startLoadingIndicator;
- (void)stopLoadingIndicator;
- (void)setTitle:(NSString *)title andImage:(UIImage *)image;

@end
