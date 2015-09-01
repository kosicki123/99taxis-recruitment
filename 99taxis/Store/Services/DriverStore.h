//
//  DriverStore.h
//  99taxis
//
//  Created by Renan Kosicki on 8/31/15.
//  Copyright © 2015 Renan Kosicki. All rights reserved.
//

#import "APIClient.h"

@interface DriverStore : APIClient

+ (void)getDriversWithBlock:(ObjectCompletionBlock)block;

@end
