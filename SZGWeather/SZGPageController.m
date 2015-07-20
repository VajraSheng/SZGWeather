//
//  SZGPageController.m
//  SZGWeather
//
//  Created by 盛振国 on 15/5/29.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import "SZGPageController.h"
#import "SZGWeatherManager.h"
#import "SZGWeatherController.h"
#import "SZGContainer.h"
#import "SZGLocation.h"

@interface SZGPageController () <UIScrollViewDelegate,CLLocationManagerDelegate,SZGLocationDelegate>
@property (weak, nonatomic) IBOutlet UILabel *cityName;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic) NSUInteger numberOfPages;
@property (strong, nonatomic) NSMutableArray *controllers;


@end

@implementation SZGPageController

#pragma mark - Initial

- (NSMutableArray *)citys
{
    if ([[[NSUserDefaults standardUserDefaults] dictionaryRepresentation].allKeys containsObject:@"citys"]) {
        NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"citys"];
        if (data.length != 0) {
            _citys = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }else {
        _citys = [[NSMutableArray alloc] init];
    }
        
    return _citys;
}

- (NSMutableArray *)controllers
{
    
    _controllers = [[NSMutableArray alloc] init];
    if (self.citys.count == 0) {
    }else{
        for (SZGCity *city in self.citys) {
            SZGWeatherController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"weatherController"];
            controller.city = city;
            controller.pageController = self;
            [_controllers addObject:controller];
        }
    }
    
    return _controllers;
}

- (BOOL)isCitysEmpty
{
    if ([[[NSUserDefaults standardUserDefaults] dictionaryRepresentation].allKeys containsObject:@"citys"]) {
        NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"citys"];
        return (data && data.length != 0) ? NO : YES;
    }else
        return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _numberOfPages = [self.controllers count];
    if (_numberOfPages == 0) {
        _cityName.text = @"";
        _pageControl.numberOfPages = 0;
    }else{
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * _numberOfPages, _scrollView.bounds.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.delegate = self;
        
        _pageControl.numberOfPages = _numberOfPages;
        _pageControl.currentPage = 0;
        
        [self loadScrollViewWithPage:0];
        SZGWeatherController *controller = [_controllers objectAtIndex:0];
        _cityName.text = controller.title;
    }
}

- (void)reload
{
    _numberOfPages = [self.controllers count];
    
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * _numberOfPages, _scrollView.bounds.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    
    _pageControl.numberOfPages = _numberOfPages;
    _pageControl.currentPage = 0;
    
    [self loadScrollViewWithPage:0];
    SZGWeatherController *controller = [_controllers objectAtIndex:0];
    _cityName.text = controller.title;
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * _numberOfPages, _scrollView.bounds.size.height);
    if ([self isCitysEmpty]) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
            [self startLocationService];
        }else{
            SZGAddCityController *controller = (SZGAddCityController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"addCityController"];
            controller.delegate = self;
            [self.view.window.rootViewController presentViewController:controller animated:YES completion:nil];
        }
    }
}

#pragma mark - Location service methods
- (void)startLocationService
{
    SZGLocation *locationTool = [SZGLocation sharedLocation];
    locationTool.delegate = self;
    [locationTool startGettingLocation];
}

- (void)userDeniedTheService
{
    SZGAddCityController *controller = (SZGAddCityController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"addCityController"];
    controller.delegate = self;
    [self.view.window.rootViewController presentViewController:controller animated:YES completion:nil];
}

- (void)locationSuccessedWithCity:(SZGCity *)city
{
    [self addCity:city];
}

- (void)locationFailedWithError:(NSError *)error
{
    NSLog(@"Location Error:%@",error);
}


#pragma mark - AddCityDelegate Methods
- (void)addCityWithCity:(SZGCity *)city
{
    [self addCity:city];
}

- (void)addCityByLocation
{
    [self startLocationService];
}

- (void)addCity:(SZGCity *)city
{
    if (self.citys.count != 0) {
        NSMutableArray *arr = [self.citys mutableCopy];
        
        BOOL flag = NO;
        NSInteger page = 0;
        for (SZGCity *innerCity in arr) {
            if ([city.name isEqualToString:innerCity.name]) {
                flag = YES;
                page = [arr indexOfObject:innerCity];
                break;
            }
        }
        if (flag) {
            [self.containerController hideSideView];
            [self gotoPageWithPage:page];
        }else{
            [arr addObject:city];
            NSData *new = [NSKeyedArchiver archivedDataWithRootObject:arr];
            [[NSUserDefaults standardUserDefaults] setObject:new forKey:@"citys"];
            [self reload];
            [self.containerController hideSideView];
            [self gotoTheLastPage];
        }
    }else{
        NSMutableArray *arr = [self.citys mutableCopy];
        [arr addObject:city];
        NSData *new = [NSKeyedArchiver archivedDataWithRootObject:arr];
        [[NSUserDefaults standardUserDefaults] setObject:new forKey:@"citys"];
        [self.containerController reload];
    }
    
}

#pragma mark - Methods that control views' display
//Decide whether the controller showing the first page
- (BOOL)isFirstPage
{
    return self.pageControl.currentPage == 0 ? YES : NO;
}

//Load the corresponding page
- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= _controllers.count) {
        return;
    }
    SZGWeatherController *controller = [_controllers objectAtIndex:page];
    _cityName.text = controller.city.name;
    if (controller.tableView.superview == nil) {
        CGRect frame = _scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.tableView.frame = frame;
        [_scrollView addSubview:controller.tableView];
    }
}

//Goto the indicated page
- (void)gotoPageWithPage:(NSInteger)page
{
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page + 1];
    [self loadScrollViewWithPage:page];
    
    // update the scroll view to the appropriate page
    CGRect bounds = _scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    _pageControl.currentPage = page;
    [_scrollView scrollRectToVisible:bounds animated:YES];
}

- (void)gotoPage:(BOOL)animated
{
    NSInteger page = _pageControl.currentPage;
    
    [self gotoPageWithPage:page];
}

- (void)gotoTheLastPage
{
    [self gotoPageWithPage:_numberOfPages - 1];
}

//Action of the PageControl
- (IBAction)changePage:(id)sender
{
    [self gotoPage:YES];
}

//Action of the leftBarButton
- (IBAction)showSideController
{
    [self.containerController showSideView];
}

//Delegate method of scroll view
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(_scrollView.frame);
    NSUInteger page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
    
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page + 1];
    [self loadScrollViewWithPage:page];
}


@end
