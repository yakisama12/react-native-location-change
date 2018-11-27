
#import "RNLocationChange.h"
#import <CoreLocation/CLError.h>
#import <CoreLocation/CLLocationManager+CLVisitExtensions.h>

@implementation RNLocationChange
{
    CLLocationManager * locationManager;
    NSDictionary<NSString *, id> * significantLocationChangeEvent;
    NSDictionary<NSString *, id> * clVisitEvent;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

- (NSArray<NSString *> *)supportedEvents {
    return @[@"significantLocationChange", @"clvisit"];
}

RCT_EXPORT_METHOD(start) {
    if (!locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
//    locationManager.distanceFilter = 10.0;
//    locationManager.headingFilter = 360.0;

    [locationManager startMonitoringVisits];
    [locationManager startMonitoringSignificantLocationChanges];
}

RCT_EXPORT_METHOD(stop) {
    if (!locationManager)
        return;
    
    [locationManager stopMonitoringSignificantLocationChanges];
    [locationManager stopMonitoringVisits];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation* location = [locations lastObject];
    
    significantLocationChangeEvent = @{
                          @"locationType": @"significantLocationChange",
                          @"coords": @{
                                  @"latitude": @(location.coordinate.latitude),
                                  @"longitude": @(location.coordinate.longitude),
                                  @"altitude": @(location.altitude),
                                  @"accuracy": @(location.horizontalAccuracy),
                                  @"altitudeAccuracy": @(location.verticalAccuracy),
                                  @"heading": @(location.course),
                                  @"speed": @(location.speed),
                                  },
                          @"timestamp": @([location.timestamp timeIntervalSince1970] * 1000) // in ms
                          };
    
    [self sendEventWithName:@"significantLocationChange" body:significantLocationChangeEvent];
}

- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit {
    clVisitEvent = @{
                     @"locationType": @"clvisit",
                     @"horizontalAccuracy": @(visit.horizontalAccuracy),
                     @"arrivalDate": @([visit.arrivalDate timeIntervalSince1970] * 1000),
                     @"departureDate": @([visit.departureDate timeIntervalSince1970] * 1000),
                     @"coords": @{
                             @"latitude": @(visit.coordinate.latitude),
                             @"longitude": @(visit.coordinate.longitude),
                             },
                     };

    [self sendEventWithName:@"clvisit" body:clVisitEvent];
}

@end
