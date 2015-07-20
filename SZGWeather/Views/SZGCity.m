//
//  SZGCity.m
//  SZGWeather
//
//  Created by 盛振国 on 15/5/8.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import "SZGCity.h"

@implementation SZGCity

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.code forKey:@"code"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.code = [aDecoder decodeObjectForKey:@"code"];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name code:(NSString *)code
{
    if (self = [super init]) {
        _name = name;
        _code = code;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name
{
    return [self initWithName:name code:nil];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@",_name];
}

@end
