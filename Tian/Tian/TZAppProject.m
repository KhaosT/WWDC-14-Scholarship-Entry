//
//  TZAppProject.m
//  Tian
//
//  Created by Khaos Tian on 4/5/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "TZAppProject.h"

@interface TZAppProject ()

@property (nonatomic, readwrite) BOOL availableInAppStore;

@end

@implementation TZAppProject

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super initWithDictionary:dict];
    if (self) {
        if ([dict objectForKey:@"appID"]) {
            self.appID = [dict objectForKey:@"appID"];
            self.availableInAppStore = YES;
        }else{
            self.availableInAppStore = NO;
        }
        
        if ([dict objectForKey:@"detailDescription"]) {
            self.detailDescription = [dict objectForKey:@"detailDescription"];
        }
        
        if ([dict objectForKey:@"images"]) {
            self.images = [dict objectForKey:@"images"];
        }
    }
    return self;
}

@end
