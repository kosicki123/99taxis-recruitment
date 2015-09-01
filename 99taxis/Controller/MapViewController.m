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
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray *drivers;


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

    [self requestWhenInUseAuthorization];
}

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
    } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self enableMapMethods];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}

- (void)enableMapMethods {
    [self.locationManager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;
    
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
        CustomAnnotation *customAnnotation = [[CustomAnnotation alloc] init];
        customAnnotation.coordinate = CLLocationCoordinate2DMake(driver.latitude, driver.longitude);
        
        [annotations addObject:customAnnotation];
    }
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

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion region;
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    
    CLLocationCoordinate2D location;
    location.latitude = userLocation.coordinate.latitude;
    location.longitude = userLocation.coordinate.longitude;
    
    region.span = span;
    region.center = location;
    
    [mapView setRegion:region animated:YES];
    
    [self.locationManager stopUpdatingLocation];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [[NSOperationQueue new] addOperationWithBlock:^{
        
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *const AnnotatioViewReuseID = @"AnnotatioViewReuseID";
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotatioViewReuseID];
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotatioViewReuseID];
    }
    

    
    return annotationView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
