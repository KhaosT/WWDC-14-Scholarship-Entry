//
//  TZCore.m
//  Tian
//
//  Created by Khaos Tian on 4/5/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "TZCore.h"

@interface TZCore (){
    NSDictionary *_projects;
}

@end

@implementation TZCore

+ (id)sharedCore
{
    static TZCore *core = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        core = [[TZCore alloc]init];
    });
    return core;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString *projectsFile = [[NSBundle mainBundle]pathForResource:@"projects" ofType:@"plist"];
        NSArray *projects = [NSArray arrayWithContentsOfFile:projectsFile];
        
        NSMutableArray      *swProjectArray = [NSMutableArray new];
        NSMutableArray      *hwProjectArray = [NSMutableArray new];
        [projects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Class projectClass = NSClassFromString([obj objectForKey:@"class"]);
            id object = [[projectClass alloc]initWithDictionary:obj];
            if ([[obj objectForKey:@"kind"] intValue] == 0) {
                [swProjectArray addObject:object];
            }else{
                [hwProjectArray addObject:object];
            }
        }];
        
        NSDictionary *projectsDict = @{@"software": [swProjectArray copy],@"hardware":[hwProjectArray copy]};
        _projects = projectsDict;
    }
    return self;
}

- (NSDictionary *)projects
{
    return _projects;
}

- (NSDictionary *)tags
{
    return @{@"skills": @[@" C ",@"Objective-C",@"Python",@"PHP",@"HTML",@"Photoshop"],@"interests":@[@"User Interface Design",@"Software Development",@"Photography",@"Hardware Development",@"Travel",@"Music"]};
}

@end
