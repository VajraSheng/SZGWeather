//
//  SZGWeatherManager.m
//  SZGWeather
//
//  Created by 盛振国 on 15/5/8.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import "SZGWeatherManager.h"

static const NSString *kBaseURL=@"https://api.thinkpage.cn/v2/weather/all.json?key=BQKLGPWVI2&language=zh-chs&unit=c&aqi=city";

@implementation SZGWeatherManager
@synthesize delegate;


//百度API
//    NSString *string = [NSString stringWithFormat:@"http://api.map.baidu.com/telematics/v3/weather?location=%@&output=%@&ak=%@&mcode=%@",@"无锡",@"json",@"huvBaeEM8c4GhFXHIo0XstAa",@"com.odom.sheng.SZGWeather"];

- (void)fetchWeatherOfCity:(SZGCity *)city
{
    NSString *cityName = city.name;
    NSString *url = [[NSString stringWithFormat:@"%@&city=%@",kBaseURL,cityName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:nil
                                                     delegateQueue:nil];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        if ([self.delegate respondsToSelector:@selector(requestDiDFailForCity:withError:)]) {
                                                            [self.delegate requestDiDFailForCity:city withError:[error description]];
                                                        }
                                                    } else {
                                                        if ([self.delegate respondsToSelector:@selector(weatherManagerDidFinishDownloading:)]) {
                                                            [self.delegate weatherManagerDidFinishDownloading:self];
                                                        }
                                                        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                   options:0
                                                                                                                     error:nil];
                                                        if ([jsonObject[@"status"] isEqualToString:@"OK"]) {
                                                            SZGWeather *weather = [[SZGWeather alloc] initWithJSONObject:jsonObject];
                                                            if ([self.delegate respondsToSelector:@selector(requestDidCompleteForCity:withReport:)]) {
                                                                self.finish = YES;
                                                                [self.delegate requestDidCompleteForCity:city withReport:weather];
                                                            }
                                                        }else{
                                                            if ([self.delegate respondsToSelector:@selector(requestDiDFailForCity:withError:)]) {
                                                                [self.delegate requestDiDFailForCity:city withError:jsonObject[@"status"]];
                                                            }
                                                        }
                                                       
                                                    }
                                                }];
        if ([self.delegate respondsToSelector:@selector(weatherManagerWillStartDownloading:)]) {
            [self.delegate weatherManagerWillStartDownloading:self];
        }
        [task resume];
    
    
}

@end
