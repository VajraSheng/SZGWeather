//
//  CLLocationManager+Simulator.m
//  SZGWeather
//
//  Created by 盛振国 on 15/6/15.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import "CLLocationManager+Simulator.h"

@implementation CLLocationManager (Simulator)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)startUpdatingLocation
{
    float latitude = 31.568f;
    float longtitude = 120.299f;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longtitude];
    [self.delegate locationManager:self didUpdateLocations:@[location]];
}
#pragma clang diagnostic pop

@end
