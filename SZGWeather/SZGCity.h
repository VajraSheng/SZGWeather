//
//  SZGCity.h
//  SZGWeather
//
//  Created by 盛振国 on 15/5/8.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZGCity : NSObject <NSCoding>

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *code;

- (instancetype)initWithName:(NSString *)name code:(NSString *)code;
- (instancetype)initWithName:(NSString *)name;

@end
