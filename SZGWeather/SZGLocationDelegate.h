//
//  SZGLocationDelegate.h
//  SZGWeather
//
//  Created by 盛振国 on 15/6/16.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZGCity.h"

@protocol SZGLocationDelegate <NSObject>

- (void)locationSuccessedWithCity:(SZGCity *)city;

- (void)locationFailedWithError:(NSError *)error;

- (void)userDeniedTheService;

@end
