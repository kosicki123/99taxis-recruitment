//
//  AnnotationMap.h
//  GeoBeacon
//
//  Created by Hipolito Arias on 10/8/15.
//  Copyright (c) 2015 MasterApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface HACAnnotationMap : NSObject<MKAnnotation>

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *imageName;
@property (assign, nonatomic) NSUInteger count;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSNumber *driverId;

@property (nonatomic, strong) HACAnnotationMap *clusterAnnotation;
@property (nonatomic, strong) NSArray *containedAnnotations;

- (void)setCount:(NSUInteger)count;
- (void)updateSubtitleIfNeeded;
- (id)initWithImageName:(NSString *)imageName title:(NSString *)aTitle coordinate:(CLLocationCoordinate2D)aCoordinate driverId:(NSNumber *)driverId;

@end
