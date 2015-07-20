//
//  SZGAddCityController.h
//  SZGWeather
//
//  Created by 盛振国 on 15/6/2.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZGAddCityDelegate.h"

@interface SZGAddCityController : UIViewController

@property (weak,nonatomic) id <SZGAddCityDelegate> delegate;

@end
