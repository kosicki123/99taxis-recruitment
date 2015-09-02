//
//  MapViewController.m
//  99taxis
//
//  Created by Renan Kosicki on 8/31/15.
//  Copyright © 2015 Renan Kosicki. All rights reserved.
//

#import "MapViewController.h"
#import "DriverStore.h"
#import "Driver.h"
#import "CustomAnnotation.h"
#import "AnnotationConverter.h"
#import "LocationRequester.h"

@import MapKit;

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) CLLocationCoordinate2D currentLocation;
@property (strong, nonatomic) NSArray *drivers;
@property (assign, nonatomic) BOOL isFirstLaunch;

@end

@implementation MapViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMapView];
}

#pragma mark - View Setup

- (void)setupMapView {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.isFirstLaunch = YES;
    
    [LocationRequester requestWhenInUseAuthorization:self.locationManager];
}

#pragma mark - Map Methods

- (void)enableMapMethods {
    [self.locationManager startUpdatingLocation];
    
    self.mapView.showsUserLocation = YES;
}

- (IBAction)updateDrivers {
    [DriverStore getDriversIn:self.currentLocation withCompletionBlock:^(id object, NSError *error) {
        if (error) {
            return [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        }
        
        [self convertToAnnotations:object];
    }];
}

- (void)convertToAnnotations:(NSArray *)driverList {
    [self.mapView removeAnnotations:[self.mapView annotations]];
    [self.allAnnotationsMapView removeAnnotations:[self.allAnnotationsMapView annotations]];
    
    [self starterWithAnnotations:[AnnotationConverter convertToAnnotations:driverList]];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self enableMapMethods];
    }
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (self.isFirstLaunch) {
        self.currentLocation = userLocation.coordinate;
        self.isFirstLaunch = NO;

        MKCoordinateRegion mapRegion;
        mapRegion.center = userLocation.coordinate;
        mapRegion.span.latitudeDelta = 0.1;
        mapRegion.span.longitudeDelta = 0.1;
        
        [self.mapView setRegion:mapRegion animated: YES];
        [self.locationManager stopUpdatingLocation];
        
        [self updateDrivers];
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateDrivers) userInfo:nil repeats:YES];
    }
}

@end
