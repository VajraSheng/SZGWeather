//
//  SZGCityCell.h
//  SZGWeather
//
//  Created by 盛振国 on 15/6/1.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SZGWeather;
@class SZGCity;

@interface SZGCityCell : UITableViewCell

@property (strong,nonatomic) SZGWeather *weather;
@property (strong,nonatomic) SZGCity *city;

@end
