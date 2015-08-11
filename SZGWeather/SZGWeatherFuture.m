//
//  SZGWeatherFuture.m
//  SZGWeather
//
//  Created by 盛振国 on 15/5/8.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import "SZGWeatherFuture.h"

@implementation SZGWeatherFuture

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.day forKey:@"day"];
    [aCoder encodeObject:self.text forKey:@"text"];
    [aCoder encodeInteger:self.dayCode forKey:@"dayCode"];
    [aCoder encodeInteger:self.nightCode forKey:@"nightCode"];
    [aCoder encodeInteger:self.highTemprature forKey:@"highTemp"];
    [aCoder encodeInteger:self.lowTemprature forKey:@"lowTemp"];
    [aCoder encodeObject:self.wind forKey:@"wind" ];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.day = [aDecoder decodeObjectForKey:@"day"];
        self.text = [aDecoder decodeObjectForKey:@"text"];
        self.dayCode = [aDecoder decodeIntegerForKey:@"dayCode"];
        self.nightCode = [aDecoder decodeIntegerForKey:@"nightCode"];
        self.highTemprature = [aDecoder decodeIntegerForKey:@"highTemp"];
        self.lowTemprature = [aDecoder decodeIntegerForKey:@"lowTemp"];
        self.wind = [aDecoder decodeObjectForKey:@"wind"];
    }
    return self;
}

- (NSString *)description
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy年MM月dd日"];
    return [NSString stringWithFormat:@"Weather:%@, code:%ld,%ld, day:%@, date:%@, high temperature:%ld, low temperature:%ld, wind:%@", self.text, (long)self.dayCode, (long)self.nightCode, self.day, [df stringFromDate:self.date], (long)self.highTemprature, (long)self.lowTemprature,self.wind];
}

@end
