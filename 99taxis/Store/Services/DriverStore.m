//
//  DriverStore.m
//  99taxis
//
//  Created by Renan Kosicki on 8/31/15.
//  Copyright © 2015 Renan Kosicki. All rights reserved.
//

#import "DriverStore.h"
#import "Driver.h"
#import "ModelConverter.h"
#import "Environment.h"

float const RangeLocation = 0.03;
NSString * const GetDriversPath = @"lastLocations";

@implementation DriverStore

//Parameters:
//- sw: Ponto extremo sul, extremo oeste do retângulo, no formato "latitude,longitude". Ex: -23.612474,-46.702746
//- ne: Ponto extremo norte, extremo leste do retângulo, no formato "latitude,longitude". Ex: -23.589548,-46.673392

+ (void)getDriversIn:(CLLocationCoordinate2D)coordinate withCompletionBlock:(ObjectCompletionBlock)block {
    NSString *currentLocation = [NSString stringWithFormat:@"%f,%f",coordinate.latitude + RangeLocation, coordinate.longitude + RangeLocation];
    NSString *newLocation = [NSString stringWithFormat:@"%f,%f",coordinate.latitude - RangeLocation, coordinate.longitude - RangeLocation];
  
    [[super sharedClient] GET:GetDriversPath parameters:@{@"sw": newLocation, @"ne": currentLocation} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *drivers = [ModelConverter convertModelsFromJSON:responseObject class:[Driver class]];
        
        if (block) block(drivers, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) block(nil, error);
    }];
}
@end
