//
//  SZGWeatherFuture.h
//  SZGWeather
//
//  Created by 盛振国 on 15/5/8.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZGWeatherFuture : NSObject <NSCoding>

@property (nonatomic,strong) NSDate *date;
@property (nonatomic,strong) NSString *day;
@property (nonatomic,strong) NSString *text;
@property (nonatomic) NSInteger dayCode;
@property (nonatomic) NSInteger nightCode;
@property (nonatomic) NSInteger highTemprature;
@property (nonatomic) NSInteger lowTemprature;
@property (nonatomic,strong) NSString *wind;

@end
