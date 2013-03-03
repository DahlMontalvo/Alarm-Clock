//
//  SettingsTelldusLiveViewController.m
//  Alarm Clock
//
//  Created by Jonas Dahl on 2013-02-23.
//  Copyright (c) 2013 Dahl & Montalvo Applications. All rights reserved.
//

#import "SettingsTelldusLiveViewController.h"

@interface SettingsTelldusLiveViewController ()

@end

@implementation SettingsTelldusLiveViewController

@synthesize tableViewOutlet, settings;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    settings = [[NSMutableArray alloc] init];
    //[settings addObject:[[NSMutableArray alloc] initWithObjects:@"Display Name", @"Segue name", @"Cell identifier", nil]];
    NSMutableArray *group1 = [[NSMutableArray alloc] initWithObjects:@"General", [[NSMutableArray alloc] init], nil];
    [[group1 objectAtIndex:1] addObject:[[NSMutableArray alloc] initWithObjects:@"Authorize", @"AuthorizeTelldusLive", @"Disclosure", nil]];
    [[group1 objectAtIndex:1] addObject:[[NSMutableArray alloc] initWithObjects:@"Schedule in Telldus Live!", @"ScheduleInTelldusLive", @"Checkmark", @"ScheduleInTelldusLive", nil]];
    [settings addObject:group1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [settings count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[[settings objectAtIndex:section] objectAtIndex:1] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[settings objectAtIndex:section] objectAtIndex:0];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [[[[settings objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row] objectAtIndex:2];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([CellIdentifier isEqualToString:@"Disclosure"]) {
        cell.textLabel.text = [[[[settings objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row] objectAtIndex:0];
    }
    else if ([CellIdentifier isEqualToString:@"Checkmark"]) {
        cell.textLabel.text = [[[[settings objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row] objectAtIndex:0];
        NSString *key = [[[[settings objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row] objectAtIndex:3];
        NSLog(@"Key: %@", key);
        if ([[[[Singleton sharedSingleton] sharedPrefs] objectForKey:key] intValue] == 1) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        NSLog(@"int: %i", [[[[Singleton sharedSingleton] sharedPrefs] objectForKey:key] intValue]);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[[[[settings objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row] objectAtIndex:2] isEqualToString:@"Disclosure"]) {
        [self performSegueWithIdentifier:[[[[settings objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row] objectAtIndex:1] sender:self];
    }
    else if ([[[[[settings objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row] objectAtIndex:2] isEqualToString:@"Checkmark"]) {
        NSString *key = [[[[settings objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row] objectAtIndex:3];
        NSLog(@"Key: %@", key);
        if ([tableViewOutlet cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark) {
            [tableViewOutlet cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            [[[Singleton sharedSingleton] sharedPrefs] setObject:[NSNumber numberWithInt:0] forKey:key];
        }
        else {
            [tableViewOutlet cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            [[[Singleton sharedSingleton] sharedPrefs] setObject:[NSNumber numberWithInt:1] forKey:key];
        }
        [[[Singleton sharedSingleton] sharedPrefs] synchronize];
    }
}

@end
