//
//  UIImage+Utilities.h
//  Tree
//
//  Created by Khaos Tian on 3/30/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utilities)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;

@end
