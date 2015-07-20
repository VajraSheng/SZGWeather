//
//  SZGWeather.h
//  SZGWeather
//
//  Created by 盛振国 on 15/5/8.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "SZGCity.h"
#import "SZGWeatherNow.h"
#import "SZGWeatherFuture.h"

@interface SZGWeather : NSObject <NSCoding>

@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) SZGCity *city;
@property (nonatomic,strong) NSDate *lastUpdate;
@property (nonatomic,strong) SZGWeatherNow *currentWeather;
@property (nonatomic,strong) NSArray *futureWeathers;
@property (nonatomic,strong) NSString *sunriseOfToday;
@property (nonatomic,strong) NSString *sunsetOfToday;

- (instancetype)initWithJSONObject:(NSDictionary *)jsonObject;
- (BOOL)isValid;

@end
