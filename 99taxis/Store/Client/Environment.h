//
//  Environment.h
//  99taxis
//
//  Created by Renan Kosicki on 8/31/15.
//  Copyright (c) 2015 Renan Kosicki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Environment : NSObject

@property (strong, nonatomic) NSString *apiHost;

@property (assign, nonatomic, getter = isDevelopment) BOOL developmentBuild;
@property (assign, nonatomic, getter = isProduction) BOOL productionBuild;

+ (instancetype)sharedInstance;

@end
