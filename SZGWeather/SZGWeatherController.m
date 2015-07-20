//
//  SZGWeatherController.m
//  SZGWeather
//
//  Created by 盛振国 on 15/5/26.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import "AppDelegate.h"
#import "SZGWeatherController.h"
#import "SZGWeatherCell.h"
#import "SZGWeatherManager.h"
#import "FVCustomAlertView.h"
#import "SZGContainer.h"


@interface SZGWeatherController () <SZGWeatherManagerDelegate>

@property (nonatomic,strong) SZGWeatherManager *manager;
@property (nonatomic,strong) SZGWeather *weather;
@property (nonatomic,strong) CALayer *failLayer;

@end

@implementation SZGWeatherController

- (void)setWeather:(SZGWeather *)weather
{
    if (weather) {
        _weather = weather;
        self.title = weather.city.name;
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"松手刷新"]];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    self.manager = [[SZGWeatherManager alloc] init];
    self.manager.delegate = self;
    
    self.title = _city.name;
    
    if ([[[NSUserDefaults standardUserDefaults] dictionaryRepresentation].allKeys containsObject:_city.name]) {
        NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:_city.name];
        if (data.length != 0) {
            _weather = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            NSDate *lastUpdate = _weather.lastUpdate;
            NSTimeInterval seconds = [[NSDate date] timeIntervalSinceDate:lastUpdate];
            if (seconds > 1800) {
                [self.manager fetchWeatherOfCity:[[SZGCity alloc] initWithName:_city.name]];
            }
        }
    }else{
        [self.manager fetchWeatherOfCity:[[SZGCity alloc] initWithName:_city.name]];
    }
}

- (SZGWeather *)getControllerWeather
{
    return _weather;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh
{
    [self.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"努力加载中.."]];
    [self.manager fetchWeatherOfCity:[[SZGCity alloc] initWithName:_city.name]];
}

#pragma mark - SZGWeatherManager Delegate

- (void)weatherManagerWillStartDownloading:(SZGWeatherManager *)manager
{
    
    [self.refreshControl beginRefreshing];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)weatherManagerDidFinishDownloading:(SZGWeatherManager *)manager
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

- (void)requestDiDFailForCity:(SZGCity *)city withError:(NSString *)errorString
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.refreshControl endRefreshing];
    NSLog(@"%@",errorString);
    [FVCustomAlertView showDefaultErrorAlertOnView:self.pageController.view withTitle:@"网络请求出错"];
}


- (void)requestDidCompleteForCity:(SZGCity *)city withReport:(SZGWeather *)report
{
    //    NSLog(@"Weather for city : %@, %@",city,report);
    _weather = report;

    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_weather];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:_city.name];
    
    // when the request completed ,tell the side contorller to reload data
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestSuccess" object:nil];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIScreen mainScreen].bounds.size.height - 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SZGWeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeatherCell"];
    
    if (cell == nil) {
        cell = (SZGWeatherCell *)[[[NSBundle mainBundle] loadNibNamed:@"WeatherCell" owner:self options:nil] lastObject];
    }
    
    if (_weather) {
        cell.weather = _weather;
    }else{
        NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:_city.name];
        cell.weather = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    // Configure the cell...
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


@end
