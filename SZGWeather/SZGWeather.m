//
//  SZGWeather.m
//  SZGWeather
//
//  Created by 盛振国 on 15/5/8.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import "SZGWeather.h"

@implementation SZGWeather

#pragma NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.lastUpdate forKey:@"lastUpdate"];
    [aCoder encodeObject:self.currentWeather forKey:@"currentWeather"];
    [aCoder encodeObject:self.futureWeathers forKey:@"futureWeathers"];
    [aCoder encodeObject:self.sunriseOfToday forKey:@"sunrise"];
    [aCoder encodeObject:self.sunsetOfToday forKey:@"sunset"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.lastUpdate = [aDecoder decodeObjectForKey:@"lastUpdate"];
        self.currentWeather = [aDecoder decodeObjectForKey:@"currentWeather"];
        self.futureWeathers = [aDecoder decodeObjectForKey:@"futureWeathers"];
        self.sunriseOfToday = [aDecoder decodeObjectForKey:@"sunrise"];
        self.sunsetOfToday = [aDecoder decodeObjectForKey:@"sunset"];
    }
    return self;
}

- (BOOL)isValid
{
    return [self.status isEqualToString:@"OK"];
}

- (NSString *)description
{
    if (![self isValid]) {
        return [NSString stringWithFormat:@"Invalid Weather Forecast"];
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy年MM月dd日hh时mm分ss秒"];
    return [NSString stringWithFormat:@"City:%@, Laste Update:%@, Now:%@, Tomorrow:%@, The Day After Tomorrow:%@, Sunrise Time:%@, Sunset Time:%@", self.city, [df stringFromDate:self.lastUpdate], self.currentWeather, self.futureWeathers[0], self.futureWeathers[1], self.sunriseOfToday, self.sunsetOfToday];
}

- (instancetype)initWithJSONObject:(NSDictionary *)jsonObject
{
    if (self = [super init]) {
        _status = jsonObject[@"status"];
        NSDictionary *weather = jsonObject[@"weather"][0];
        _city = [[SZGCity alloc] initWithName:weather[@"city_name"] code:weather[@"city_id"]];
        NSString *lastUpdateTime = weather[@"last_update"];
        _lastUpdate = [self changeNowTimeStringToDate:lastUpdateTime];
        
        
        NSDictionary *now = weather[@"now"];
        _currentWeather = [self parseJsonToWeatherNow:now];
        
        NSDictionary *firstFuture = weather[@"future"][0];
        SZGWeatherFuture *tomorrow = [self parseJsonToWeatherFuture:firstFuture];
        NSDictionary *secondFuture = weather[@"future"][1];
        SZGWeatherFuture *theDayAfterTomorrow = [self parseJsonToWeatherFuture:secondFuture];
        _futureWeathers = @[tomorrow ,theDayAfterTomorrow];
        
        _sunriseOfToday = weather[@"today"][@"sunrise"];
        _sunsetOfToday = weather[@"today"][@"sunset"];
    }
    return self;
}

- (SZGWeatherFuture *)parseJsonToWeatherFuture:(NSDictionary *)future
{
    SZGWeatherFuture *weatherFuture = [[SZGWeatherFuture alloc] init];
    weatherFuture.date = [self changeFutureTimeStringToDate:future[@"date"]];
    weatherFuture.day = future[@"day"];
    weatherFuture.text = future[@"text"];
    weatherFuture.dayCode = [future[@"code1"] integerValue];
    weatherFuture.nightCode = [future[@"code2"] integerValue];
    weatherFuture.highTemprature = [future[@"high"] integerValue];
    weatherFuture.lowTemprature = [future[@"low"] integerValue];
    weatherFuture.wind = future[@"wind"];
    return weatherFuture;
}

- (SZGWeatherNow *)parseJsonToWeatherNow:(NSDictionary *)now
{
    SZGWeatherNow *weatherNow = [[SZGWeatherNow alloc] init];
    weatherNow.text = now[@"text"];
    weatherNow.code = [now[@"code"] integerValue];
    weatherNow.temperature = [now[@"temperature"] integerValue];
    weatherNow.windDirection = now[@"wind_direction"];
    weatherNow.windScale = [now[@"wind_scale"] doubleValue];
    weatherNow.humidity = [now[@"humidity"] doubleValue];
    return weatherNow;
}

- (NSDate *)changeNowTimeStringToDate:(NSString *)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    return [formatter dateFromString:dateStr];
}

- (NSDate *)changeFutureTimeStringToDate:(NSString *)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter dateFromString:dateStr];
}



@end
