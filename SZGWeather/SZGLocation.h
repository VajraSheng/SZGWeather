//
//  SZGLocation.h
//  SZGWeather
//
//  Created by 盛振国 on 15/6/15.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "SZGLocationDelegate.h"

#import "SZGCity.h"

@interface SZGLocation : NSObject

@property (weak,nonatomic) id <SZGLocationDelegate> delegate;


+ (SZGLocation *)sharedLocation;

- (void)startGettingLocation;

@end
