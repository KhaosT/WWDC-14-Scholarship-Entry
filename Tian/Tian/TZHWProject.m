//
//  TZHWProject.m
//  Tian
//
//  Created by Khaos Tian on 4/5/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "TZHWProject.h"

@implementation TZHWProject

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super initWithDictionary:dict];
    if (self) {
        if ([dict objectForKey:@"detailDescription"]) {
            self.detailDescription = [dict objectForKey:@"detailDescription"];
        }
        
        if ([dict objectForKey:@"images"]) {
            self.images = [dict objectForKey:@"images"];
        }
        
        if ([dict objectForKey:@"projectUrl"]) {
            self.projectUrl = [dict objectForKey:@"projectUrl"];
        }
    }
    return self;
}

@end
