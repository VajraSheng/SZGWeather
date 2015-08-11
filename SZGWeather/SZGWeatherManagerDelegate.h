//
//  SZGWeatherManagerDelegate.h
//  SZGWeather
//
//  Created by 盛振国 on 15/5/8.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SZGWeatherManager;
@class SZGCity;
@class SZGWeather;

@protocol SZGWeatherManagerDelegate <NSObject>

@optional
- (void)weatherManagerWillStartDownloading:(SZGWeatherManager *)manager;
- (void)weatherManagerDidFinishDownloading:(SZGWeatherManager *)manager;

@required
- (void)requestDidCompleteForCity:(SZGCity *)city withReport:(SZGWeather *)report;
- (void)requestDiDFailForCity:(SZGCity *)city withError:(NSString *)errorString;
@end
