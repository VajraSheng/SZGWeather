//
//  SZGWeatherManager.h
//  SZGWeather
//
//  Created by 盛振国 on 15/5/8.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZGWeatherManagerDelegate.h"
#import "SZGCity.h"
#import "SZGWeather.h"

@interface SZGWeatherManager : NSObject

@property (nonatomic,weak) id <SZGWeatherManagerDelegate> delegate;

@property (nonatomic,getter=isFinished) BOOL finish;
- (void)fetchWeatherOfCity:(SZGCity *)city;

@end

