//
//  SZGWeatherNow.h
//  SZGWeather
//
//  Created by 盛振国 on 15/5/8.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import <Foundation/Foundation.h>

//实时天气
@interface SZGWeatherNow : NSObject <NSCoding>

@property (nonatomic,strong) NSString *text;//天气情况文字
@property (nonatomic) NSInteger code;//天气编码，对应图片
@property (nonatomic) NSInteger temperature;//温度
@property (nonatomic,strong) NSString *windDirection;//风向
@property (nonatomic) double windScale;//风力等级
@property (nonatomic) double humidity;//湿度

@end
