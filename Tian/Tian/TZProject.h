//
//  TZProject.h
//  Tian
//
//  Created by Khaos Tian on 4/5/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TZProject : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) UIImage  *icon;

- (id)initWithName:(NSString *)name icon:(UIImage *)icon;
- (id)initWithDictionary:(NSDictionary *)dict;

@end
