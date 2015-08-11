//
//  SZGWeatherNow.m
//  SZGWeather
//
//  Created by 盛振国 on 15/5/8.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import "SZGWeatherNow.h"

@implementation SZGWeatherNow

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.text forKey:@"text"];
    [aCoder encodeInteger:self.code forKey:@"code"];
    [aCoder encodeInteger:self.temperature forKey:@"temperature"];
    [aCoder encodeObject:self.windDirection forKey:@"windDirection"];
    [aCoder encodeDouble:self.windScale forKey:@"windScale"];
    [aCoder encodeDouble:self.humidity forKey:@"humidity"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.text = [aDecoder decodeObjectForKey:@"text"];
        self.code = [aDecoder decodeIntegerForKey:@"code"];
        self.temperature = [aDecoder decodeIntegerForKey:@"temperature"];
        self.windDirection = [aDecoder decodeObjectForKey:@"windDirection"];
        self.windScale = [aDecoder decodeDoubleForKey:@"windScale"];
        self.humidity = [aDecoder decodeDoubleForKey:@"humidity"];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Weather:%@, code:%ld, temperature:%ld, wind direction:%@, wind scale:%.1f, humidity: %.1f%%", self.text, (long)self.code, (long)self.temperature, self.windDirection, self.windScale, self.humidity];
}

@end
