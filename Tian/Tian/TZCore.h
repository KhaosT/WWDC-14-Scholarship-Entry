//
//  TZCore.h
//  Tian
//
//  Created by Khaos Tian on 4/5/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TZAppProject.h"
#import "TZHWProject.h"

@interface TZCore : NSObject

+ (id)sharedCore;

- (NSDictionary *)projects;
- (NSDictionary *)tags;

@end
