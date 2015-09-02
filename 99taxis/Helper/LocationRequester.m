//
//  LocationRequester.m
//  99taxis
//
//  Created by Renan Kosicki on 9/2/15.
//  Copyright © 2015 Renan Kosicki. All rights reserved.
//

#import "LocationRequester.h"

@implementation LocationRequester

+ (void)requestWhenInUseAuthorization:(CLLocationManager *)locationManager {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusDenied) {
        NSString *title = @"Location services are disabled";
        NSString *message = @"To find cabs nearby of your location you must turn on 'When in use' in the Location Services Settings";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        [alertView show];
    } else if (status == kCLAuthorizationStatusNotDetermined) {
        [locationManager requestWhenInUseAuthorization];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}

@end
