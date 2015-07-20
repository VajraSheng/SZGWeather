//
//  SZGAddCityDelegate.h
//  SZGWeather
//
//  Created by 盛振国 on 15/6/6.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SZGCity;

@protocol SZGAddCityDelegate <NSObject>

- (void)addCityWithCity:(SZGCity *)city;
- (void)addCityByLocation;

@end
