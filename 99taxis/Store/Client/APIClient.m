//
//  APIClient.m
//  99taxis
//
//  Created by Renan Kosicki on 8/31/15.
//  Copyright (c) 2015 Renan Kosicki. All rights reserved.
//

#import "APIClient.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "Environment.h"

@implementation APIClient

+ (instancetype)sharedClient {
    static APIClient * _sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Environment *environment = [Environment sharedInstance];
        _sharedClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:environment.apiHost]];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    });
    
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        self.requestSerializer.timeoutInterval = 30;        
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    }
    
    return self;
}

@end
