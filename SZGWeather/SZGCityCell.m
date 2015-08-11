//
//  SZGCityCell.m
//  SZGWeather
//
//  Created by 盛振国 on 15/6/1.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import "SZGCityCell.h"
#import "SZGWeather.h"

@interface SZGCityCell ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *cityTemp;


@end

@implementation SZGCityCell

- (void)setWeather:(SZGWeather *)weather
{
    if (weather != nil) {
        _weather = weather;
        [self setup];
    }
}

- (void)setCity:(SZGCity *)city
{
    if (city != nil) {
        _city = city;
        _cityName.text = city.name;
        _cityTemp.text = @"暂无数据";
        _image.image = [self getImageByCode:0];
    }
}

- (void)setup
{
    _cityName.text = _weather.city.name;
    _cityTemp.text = [NSString stringWithFormat:@"%ld℃",(long)_weather.currentWeather.temperature];
    _image.image = [self getImageByCode:_weather.currentWeather.code];
}

- (UIImage *)getImageByCode:(NSInteger)code
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"%ld",(long)code]];
}

@end
