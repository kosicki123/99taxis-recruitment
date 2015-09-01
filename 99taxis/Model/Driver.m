//
//  Driver.m
//  99taxis
//
//  Created by Renan Kosicki on 8/31/15.
//  Copyright © 2015 Renan Kosicki. All rights reserved.
//

#import "Driver.h"

@implementation Driver

@synthesize id;

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"latitude": @"latitude",
             @"longitude": @"longitude",
             @"driverAvailable": @"driverAvailable",
             @"id": @"driverId"
             };
}

@end
