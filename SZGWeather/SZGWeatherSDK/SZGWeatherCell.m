//
//  SZGWeatherCell.m
//  SZGWeather
//
//  Created by 盛振国 on 15/5/26.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import "SZGWeatherCell.h"
#import "SZGWeather.h"
#import "SZGWeatherFuture.h"

@interface SZGWeatherCell ()
@property (weak, nonatomic) IBOutlet UILabel *lastUpdate;
@property (weak, nonatomic) IBOutlet UILabel *weatherText;
@property (weak, nonatomic) IBOutlet UILabel *temperature;
@property (weak, nonatomic) IBOutlet UILabel *wind;
@property (weak, nonatomic) IBOutlet UILabel *humidity;
@property (weak, nonatomic) IBOutlet UILabel *tomorrowTemperature;
@property (weak, nonatomic) IBOutlet UILabel *tomorrowText;
@property (weak, nonatomic) IBOutlet UILabel *dayAfterTomorrowTemperature;
@property (weak, nonatomic) IBOutlet UILabel *dayAfterTomorrowText;
@property (weak, nonatomic) IBOutlet UIImageView *tomorrowImage;
@property (weak, nonatomic) IBOutlet UIImageView *dayAfterTomorrowImage;
@property (weak, nonatomic) IBOutlet UILabel *tomorrowLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayAfterTomorrowLabel;
@property (weak, nonatomic) IBOutlet UIView *portraitView;
@property (weak, nonatomic) IBOutlet UIView *landscapeView;

@property (strong,nonatomic) CALayer *imageLayer;

@end

@implementation SZGWeatherCell

- (void)setWeather:(SZGWeather *)weather
{
    _weather = weather;
    [self setNeedsDisplay];
}

- (CALayer *)imageLayer
{
    if (_imageLayer == nil) {
        _imageLayer = [CALayer layer];
        _imageLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        _imageLayer.opacity = 0.4f;
    }
    return _imageLayer;
}

- (void)drawRect:(CGRect)rect
{
    if (_weather != nil) {
        [self setup];
    }else{
        [self setEmpty];
    }
}

- (void)setup
{
    _weatherText.text = _weather.currentWeather.text;
    _lastUpdate.text = [self getUpdateTime:_weather.lastUpdate];
    _temperature.text = [NSString stringWithFormat:@"%ld℃",(long)_weather.currentWeather.temperature];
    _wind.text = [NSString stringWithFormat:@"%@风%.1f级",_weather.currentWeather.windDirection,_weather.currentWeather.windScale];
    _humidity.text = [NSString stringWithFormat:@"空气湿度:%.1f%%",_weather.currentWeather.humidity];
    SZGWeatherFuture *tomorrow = _weather.futureWeathers[0];
    _tomorrowTemperature.text = [NSString stringWithFormat:@"%ld℃~%ld℃",(long)tomorrow.lowTemprature,(long)tomorrow.highTemprature];
    _tomorrowText.text = tomorrow.text;
    SZGWeatherFuture *dayAfterTomorrow = _weather.futureWeathers[1];
    _dayAfterTomorrowTemperature.text = [NSString stringWithFormat:@"%ld℃~%ld℃",(long)dayAfterTomorrow.lowTemprature,(long)dayAfterTomorrow.highTemprature];
    _dayAfterTomorrowText.text = dayAfterTomorrow.text;
    _tomorrowImage.image = [self getImageByCode:tomorrow.dayCode];
    _dayAfterTomorrowImage.image = [self getImageByCode:dayAfterTomorrow.dayCode];
    _tomorrowLabel.text = @"明天";
    _dayAfterTomorrowLabel.text = @"后天";
    _portraitView.backgroundColor = [UIColor lightGrayColor];
    _landscapeView.backgroundColor = [UIColor lightGrayColor];
    [self showAnimationLayer];
}

- (void)setEmpty
{
    _weatherText.text = @"";
    _lastUpdate.text = @"";
    _temperature.text = @"";
    _wind.text = @"";
    _humidity.text = @"";
    _tomorrowTemperature.text = @"";
    _tomorrowText.text = @"";
    _dayAfterTomorrowTemperature.text = @"";
    _dayAfterTomorrowText.text = @"";
    _tomorrowImage.image = nil;
    _dayAfterTomorrowImage.image = nil;
    _tomorrowLabel.text = @"";
    _dayAfterTomorrowLabel.text = @"";
    _portraitView.backgroundColor = [UIColor whiteColor];
    _landscapeView.backgroundColor = [UIColor whiteColor];
    
}

- (void)showAnimationLayer
{
    self.imageLayer.contents = (__bridge id)([self getImageByCode:_weather.currentWeather.code].CGImage);
    self.imageLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:_imageLayer];
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position.x";
    animation.fromValue = @(-self.bounds.size.width / 2);
    animation.toValue = @(self.bounds.size.width * 1.5);
    animation.duration = 5.0f;
    animation.speed = 0.25f;
    animation.repeatCount = INT_MAX;
    [self.imageLayer addAnimation:animation forKey:nil];
}


- (UIImage *)getImageByCode:(NSInteger)code
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"%ld",(long)code]];
}

- (NSString *)getUpdateTime:(NSDate *)date
{
    NSDate *now = [NSDate date];
    NSTimeInterval time = [now timeIntervalSinceDate:date];
    double minutes = time / 60;
    if (minutes < 60) {
        return [NSString stringWithFormat:@"%.0f分钟前发布",minutes];
    }else{
        double hours = minutes / 60;
        if (hours < 24) {
            return [NSString stringWithFormat:@"%.0f小时前发布",hours];
        }else{
            double days = hours / 24;
            return [NSString stringWithFormat:@"%.0f天前发布",days];
        }
    }
}



@end
