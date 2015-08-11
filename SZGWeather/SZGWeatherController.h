//
//  SZGWeatherController.h
//  SZGWeather
//
//  Created by 盛振国 on 15/5/26.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SZGCity;
@class SZGWeather;
@class SZGPageController;

@interface SZGWeatherController : UITableViewController

@property (strong,nonatomic) SZGCity *city;
@property (strong,nonatomic) SZGPageController *pageController;

- (SZGWeather *)getControllerWeather;

@end
