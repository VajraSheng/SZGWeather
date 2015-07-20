//
//  SZGAddCityController.m
//  SZGWeather
//
//  Created by 盛振国 on 15/6/2.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import "SZGAddCityController.h"
#import "SZGWeather.h"
#import "SZGContainer.h"
#import "FVCustomAlertView.h"

//添加城市边栏控制器
@interface SZGAddCityController () <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

//@property (strong,nonatomic) UISearchController *searchController;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *blackView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarToSuperViewVertical;

@property (strong,nonatomic) NSArray *allCitys;
@property (strong,nonatomic) NSMutableArray *resultCitys;

@end

@implementation SZGAddCityController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _searchBar.showsCancelButton = NO;
    _searchBar.delegate = self;
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.hidden = YES;
    _blackView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 1;
    [_blackView addGestureRecognizer:tap];
    
    NSArray *cacheArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"allCitys"];
    if (cacheArray != nil) {
        self.allCitys = cacheArray;
    }else{
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
        NSDictionary *areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        NSArray *components = [areaDic allKeys];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        for (int i = 0; i<components.count; i++) {
            NSDictionary *dic1 = [areaDic objectForKey:components[i]];
            NSArray *arr1 = [dic1 allKeys];
            for (int j = 0; j<arr1.count; j++) {
                NSDictionary *dic2 = [dic1 objectForKey:arr1[j]];
                NSArray *arr2 = [dic2 allKeys];
                for (int k = 0; k<arr2.count; k++) {
                    NSDictionary *dic3 = [dic2 objectForKey:arr2[k]];
                    NSArray *arr3 = [dic3 allKeys];
                    for (NSString *string in arr3) {
                        NSString *newString = [string stringByReplacingOccurrencesOfString:@"市" withString:@""];
                        [array addObject:newString];
                    }
                }
            }
        }
        self.allCitys = [[NSArray alloc] initWithArray:array];
        NSArray *immutableArray = self.allCitys;
        [[NSUserDefaults standardUserDefaults] setValue:immutableArray forKey:@"allCitys"];
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [_tableView reloadData];
}

#pragma mark - UISearchBarDelegate Method
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _searchBarToSuperViewVertical.constant = 20;
    _closeButton.hidden = YES;
    _titleLabel.hidden = YES;
    _searchBar.showsCancelButton = YES;
    _blackView.hidden = NO;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _searchBarToSuperViewVertical.constant = 56;
    [_searchBar resignFirstResponder];
    _searchBar.showsCancelButton = NO;
    
    _searchBar.hidden = NO;
    _searchBar.text = nil;
    _tableView.hidden = YES;
    _blackView.hidden = YES;
    _closeButton.hidden = NO;
    _titleLabel.hidden = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchTex
{
    
    if ([_searchBar.text isEqualToString:@""] ) {
        _tableView.hidden = YES ;
        _blackView.hidden = NO;
    }else{
        _tableView.hidden = NO;
        _blackView.hidden = YES;
    }
    [_tableView reloadData];
}

#pragma mark - Gesture

- (void)tap:(UITapGestureRecognizer *)tapGesture
{
    [self searchBarCancelButtonClicked:_searchBar];
}

#pragma mark - Change chinese to PinYin

- (NSString *)transformString:(NSString *)sourceString
{
    NSMutableString *source = [sourceString mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    [source replaceOccurrencesOfString:@" " withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [source length])];
    return source;
}

#pragma mark - Table view datasource method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"self contains [cd] %@",self.searchBar.text];
    self.resultCitys  =  [[NSMutableArray alloc] initWithArray:
                          [self.allCitys filteredArrayUsingPredicate:predicate]];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSString *string in self.allCitys) {
        if ([string localizedCaseInsensitiveContainsString:self.searchBar.text]) {
            [array addObject:string];
        }else{
            NSString *newString = [self transformString:string];
            if ([newString localizedCaseInsensitiveContainsString:self.searchBar.text]) {
                [array addObject:string];
            }
        }
    }
    self.resultCitys = [[NSMutableArray alloc] initWithArray:array];
    return self.resultCitys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.resultCitys objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    SZGCity *city = [[SZGCity alloc] initWithName:cell.textLabel.text];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(addCityWithCity:)]) {
        [self.delegate addCityWithCity:city];
    }
    
}

#pragma mark - Action of close button

- (IBAction)close:(id)sender
{
    NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"citys"];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"] | !data | data.length == 0) {
        [FVCustomAlertView showDefaultWarningAlertOnView:self.view withTitle:@"请选择添加的城市"];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Add Location City Button's action
- (IBAction)addLocationCity
{
    if ([self.delegate respondsToSelector:@selector(addCityByLocation)]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.delegate addCityByLocation];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
