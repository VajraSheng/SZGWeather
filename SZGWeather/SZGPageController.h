//
//  SZGPageController.h
//  SZGWeather
//
//  Created by 盛振国 on 15/5/29.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZGAddCityController.h"
@class SZGContainer;
@class SZGCity;


@interface SZGPageController : UIViewController <SZGAddCityDelegate>

@property (strong,nonatomic) NSMutableArray *citys;
@property (nonatomic,getter=isCitysEmpty) BOOL citysEmpty;
@property (strong,nonatomic) SZGContainer *containerController;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (BOOL)isFirstPage;

- (void)gotoPageWithPage:(NSInteger)page;
- (void)gotoTheLastPage;

- (void)addCity:(SZGCity *)city;
- (void)reload;


@end
