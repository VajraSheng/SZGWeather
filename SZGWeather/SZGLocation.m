//
//  SZGLocation.m
//  SZGWeather
//
//  Created by 盛振国 on 15/6/15.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import "SZGLocation.h"

@interface SZGLocation () <CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *manager;
@property (nonatomic,strong) SZGCity *city;

@end

@implementation SZGLocation

#pragma mark - Initial
+ (SZGLocation *)sharedLocation
{
    static SZGLocation *location = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        location = [[SZGLocation alloc] init];
    });
    return location;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [[CLLocationManager alloc] init];
        self.manager.delegate = self;
        self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return self;
}

#pragma mark - Location
- (void)startGettingLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            [_manager requestWhenInUseAuthorization];
        }
    }
}

#pragma mark - CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_manager startUpdatingLocation];
    }else if (status == kCLAuthorizationStatusDenied) {
        [self.delegate userDeniedTheService];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [_manager stopUpdatingLocation];
    
    NSMutableArray *usersDefaultLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] setObject:@[@"zh-hans"] forKey:@"AppleLanguages"];
    
    CLLocation *location = [locations firstObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        NSString *name = [placemark.locality stringByReplacingOccurrencesOfString:@"市" withString:@""];
        if ([self.delegate respondsToSelector:@selector(locationSuccessedWithCity:)]) {
            SZGCity *city = [[SZGCity alloc] initWithName:name];
            [self.delegate locationSuccessedWithCity:city];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:usersDefaultLanguages forKey:@"AppleLanguages"];
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [_manager stopUpdatingLocation];
    if ([self.delegate respondsToSelector:@selector(locationFailedWithError:)]) {
        [self.delegate locationFailedWithError:error];
    }
}

















@end
