//
//  SZGContainer.h
//  SZGWeather
//
//  Created by 盛振国 on 15/5/30.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZGPageController.h"
#import "SZGSideController.h"

@interface SZGContainer : UIViewController 

@property (strong,nonatomic) SZGPageController *mainController;
@property (strong,nonatomic) SZGSideController *sideController;

- (void)showSideView;
- (void)hideSideView;

- (void)changeEditTableToFullScreen;
- (void)endEditTable;

- (void)reload;


@end
