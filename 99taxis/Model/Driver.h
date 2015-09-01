//
//  Driver.h
//  99taxis
//
//  Created by Renan Kosicki on 8/31/15.
//  Copyright © 2015 Renan Kosicki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import <Mantle.h>

@interface Driver : MTLModel <MTLJSONSerializing>

@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;
@property (assign, nonatomic) BOOL driverAvailable;
@property (strong, nonatomic) NSNumber *id;

@end
