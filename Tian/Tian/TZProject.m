//
//  TZProject.m
//  Tian
//
//  Created by Khaos Tian on 4/5/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "TZProject.h"

@implementation TZProject

- (id)initWithName:(NSString *)name icon:(UIImage *)icon
{
    self = [super init];
    if (self) {
        self.name = name;
        self.icon = icon;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if ([dict objectForKey:@"name"]) {
            self.name = [dict objectForKey:@"name"];
        }
        
        if ([dict objectForKey:@"icon"]) {
            self.icon = [UIImage imageNamed:[dict objectForKey:@"icon"]];
        }
    }
    return self;
}

@end
