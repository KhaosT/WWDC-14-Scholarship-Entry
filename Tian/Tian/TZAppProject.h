//
//  TZAppProject.h
//  Tian
//
//  Created by Khaos Tian on 4/5/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "TZProject.h"

@interface TZAppProject : TZProject

@property (nonatomic, readonly) BOOL availableInAppStore;
@property (nonatomic, copy) NSString *detailDescription;
@property (nonatomic, copy) NSNumber *appID;
@property (nonatomic, copy) NSArray  *images;

@end
