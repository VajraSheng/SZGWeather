//
//  SZGCityController.m
//  SZGWeather
//
//  Created by 盛振国 on 15/6/1.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import "SZGCityController.h"
#import "SZGContainer.h"
#import "SZGWeather.h"
#import "SZGCityCell.h"
#import "SZGWeatherController.h"
#import "SZGAddCityController.h"

@interface SZGCityController ()

@property (nonatomic,strong) SZGContainer *container;

@end

@implementation SZGCityController

- (void)viewDidLoad {
    [super viewDidLoad];
    SZGSideController *side = (SZGSideController *)self.navigationController;
    _container = side.containerController;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afterWeatherRequestSuccess:) name:@"RequestSuccess" object:nil];
}

- (void)afterWeatherRequestSuccess:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_container.mainController.citys count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SZGCityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSInteger index = [indexPath row];
    SZGCity *city = [_container.mainController.citys objectAtIndex:index];
    NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:city.name];
    if (data) {
        cell.weather = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }else{
        cell.city = city;
    }
    
    return cell;
}

#pragma mark - Table view delegate

 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
     return YES;
 }



 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSMutableArray *array = _container.mainController.citys;
        [array removeObjectAtIndex:indexPath.row];
        if (array.count != 0) {
            NSData *new = [NSKeyedArchiver archivedDataWithRootObject:array];
            [[NSUserDefaults standardUserDefaults] setObject:new forKey:@"citys"];
            [_container.mainController reload];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"citys"];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            SZGAddCityController *controller = (SZGAddCityController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"addCityController"];
            controller.delegate = _container.mainController;
            [self.view.window.rootViewController presentViewController:controller animated:YES completion:nil];
        }
        
        
    }
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_container.mainController gotoPageWithPage:[indexPath row]];
    [_container hideSideView];
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSMutableArray *array = [_container.mainController.citys mutableCopy];
    id object = [array objectAtIndex:fromIndexPath.row];
    [array removeObjectAtIndex:fromIndexPath.row];
    [array insertObject:object atIndex:toIndexPath.row];
    NSData *new = [NSKeyedArchiver archivedDataWithRootObject:array];
    [[NSUserDefaults standardUserDefaults] setObject:new forKey:@"citys"];
    
    [_container.mainController reload];

}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


#pragma mark - Table editable

- (IBAction)editTable:(UIBarButtonItem *)sender
{
    [self.tableView setEditing:YES animated:YES];
    [_container changeEditTableToFullScreen];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneEdit)];
}

- (void)doneEdit
{
    [self.tableView setEditing:NO animated:NO];
    [_container endEditTable];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editTable:)];
}


- (IBAction)addCity:(id)sender
{
    SZGAddCityController *controller = (SZGAddCityController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"addCityController"];
    controller.delegate = _container.mainController;
    [self.view.window.rootViewController presentViewController:controller animated:YES completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
