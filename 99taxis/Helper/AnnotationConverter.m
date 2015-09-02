//
//  AnnotationConverter.m
//  99taxis
//
//  Created by Renan Kosicki on 9/2/15.
//  Copyright © 2015 Renan Kosicki. All rights reserved.
//

#import "AnnotationConverter.h"
#import "Driver.h"
#import <HACAnnotationMap.h>

@implementation AnnotationConverter

+ (NSArray *)convertToAnnotations:(NSArray *)driverList {
    NSMutableArray *annotations = [NSMutableArray array];
    for (Driver *driver in driverList) {
        NSString *driverIdTitle = [NSString stringWithFormat:@"%@", driver.id];
        HACAnnotationMap *annotation = [[HACAnnotationMap alloc] initWithImageName:@"pin" title:driverIdTitle coordinate:CLLocationCoordinate2DMake(driver.latitude, driver.longitude) driverId:driver.id];
        [annotations addObject:annotation];
    }
    return [annotations copy];
}

@end
