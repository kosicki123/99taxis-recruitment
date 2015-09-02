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

@import MapKit;

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, readonly, nonatomic) NSString *pictoName; // abstract
@property (weak, readonly, nonatomic) NSString *clusterPictoName; // abstract
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray *drivers;
@property (assign, nonatomic) BOOL isFirstLaunch;

@end

@implementation MapViewController

@synthesize mapView;

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMapView];
    [self setupNavigationBar];
}

#pragma mark - View Setup

- (void)setupNavigationBar {
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(updateDrivers)];
    [self.navigationItem setRightBarButtonItem:refreshButton];
}

- (void)setupMapView {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.isFirstLaunch = YES;
    [self requestWhenInUseAuthorization];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}

#pragma mark - Map Methods

- (void)requestWhenInUseAuthorization {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusDenied) {
        NSString *title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        NSString *message = @"To find cabs nearby of your location you must turn on 'When in use' in the Location Services Settings";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        [alertView show];
    } else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

- (void)enableMapMethods {
    [self.locationManager startUpdatingLocation];
    
    self.mapView.showsUserLocation = YES;

    [self updateDrivers];
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateDrivers) userInfo:nil repeats:YES];
}

- (void)updateDrivers {
    [DriverStore getDriversWithBlock:^(id object, NSError *error) {
        if (error) {
            return [self showError:error];
        }
        
        [self convertToAnnotations:object];
    }];
}

- (void)convertToAnnotations:(NSArray *)driverList {
    NSMutableArray *annotations = [NSMutableArray array];
    for (Driver *driver in driverList) {
        HACAnnotationMap *annotation = [[HACAnnotationMap alloc] initWithImageName:@"pin" title:[NSString stringWithFormat:@"%@", driver.id] coordinate:CLLocationCoordinate2DMake(driver.latitude, driver.longitude) driverId:driver.id];
        [annotations addObject:annotation];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.allAnnotationsMapView.annotations count] > 0) {
            for (HACAnnotationMap *annotation in self.allAnnotationsMapView.annotations) {
                MKAnnotationView *view = [self.mapView viewForAnnotation:annotation];

                [self addBounceDeleteAnnimationToView:view];
                [self.allAnnotationsMapView removeAnnotation:annotation];
                [self.mapView removeAnnotation:annotation];
            }
        }
        
        [self starterWithAnnotations:annotations];
    });
}

#pragma mark - Error Handling

- (void)showError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
}

#pragma mark - MKMapViewDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self enableMapMethods];
    }
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (self.isFirstLaunch) {
        self.isFirstLaunch = NO;
        MKCoordinateRegion mapRegion;
        
        mapRegion.center = self.mapView.userLocation.coordinate;
        mapRegion.span.latitudeDelta = 0.2;
        mapRegion.span.longitudeDelta = 0.2;
        
        [self.mapView setRegion:mapRegion animated: YES];
    }
}

@end
