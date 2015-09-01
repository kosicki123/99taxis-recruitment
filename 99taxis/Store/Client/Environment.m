//
//  Environment.m
//  99taxis
//
//  Created by Renan Kosicki on 8/31/15.
//  Copyright (c) 2015 Renan Kosicki. All rights reserved.
//

#import "Environment.h"

@implementation Environment

+ (instancetype)sharedInstance {
    static Environment * _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadEnvironment];
    }
    
    return self;
}

- (void)loadEnvironment {
    NSString *mainBundle = [NSBundle mainBundle].bundlePath;
    NSString *environmentPath = [mainBundle stringByAppendingPathComponent:@"environment.plist"];
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:environmentPath];
    NSString *buildType = @"Production";
    
#if DEBUG
    buildType = @"Development";
#endif
    
    NSDictionary *environment = settings[buildType];
    
    self.apiHost = environment[@"BaseURL"];
}

@end
