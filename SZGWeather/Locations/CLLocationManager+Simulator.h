//
//  CLLocationManager+Simulator.h
//  SZGWeather
//
//  Created by 盛振国 on 15/6/15.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#ifdef TARGET_IPHONE_SIMULATOR
@interface CLLocationManager (Simulator)

@end
#endif