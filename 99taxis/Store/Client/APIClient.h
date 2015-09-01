//
//  APIClient.h
//  99taxis
//
//  Created by Renan Kosicki on 8/31/15.
//  Copyright (c) 2015 Renan Kosicki. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef void (^ObjectCompletionBlock)(id object, NSError *error);

@interface APIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
