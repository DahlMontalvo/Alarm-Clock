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
    
    cell.textLabel.text = [[[[settings objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row] objectAtIndex:0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self performSegueWithIdentifier:[[[[settings objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row] objectAtIndex:1] sender:self];
}

@end
