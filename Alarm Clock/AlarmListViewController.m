//
//  AlarmListViewController.m
//  Alarm Clock
//
//  Created by Jonas Dahl on 2013-02-22.
//  Copyright (c) 2013 Dahl & Montalvo Applications. All rights reserved.
//

#import "AlarmListViewController.h"
#import "EditAlarmViewController.h"

@interface AlarmListViewController ()

@end

@implementation AlarmListViewController

@synthesize tableViewOutlet, alarms, selectedAlarm;

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
    selectedAlarm = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    alarms = [[NSMutableArray alloc] init];
    [alarms addObject:[[NSMutableArray alloc] initWithObjects:@"Placeholder alarm", [NSNumber numberWithInt:123], @"15:46", nil]];
    [alarms addObject:[[NSMutableArray alloc] initWithObjects:@"Another alarm", [NSNumber numberWithInt:123], @"18:45", nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addButtonPressed:(id)sender {
    //Gör nytt alarm i databasen
    //Pusha vidare till edit alarm vc
    selectedAlarm = 2; //Nytt alarm id
    [self performSegueWithIdentifier:@"EditAlarmSegue" sender:self];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [alarms count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Alarms";
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"AlarmCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    ((UILabel *)[cell viewWithTag:2]).text = [[alarms objectAtIndex:indexPath.row] objectAtIndex:0];
    ((UILabel *)[cell viewWithTag:3]).text = [[alarms objectAtIndex:indexPath.row] objectAtIndex:2];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectedAlarm = [[[alarms objectAtIndex:indexPath.row] objectAtIndex:1] intValue];
	[self performSegueWithIdentifier:@"EditAlarmSegue" sender:self];
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return(YES);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"Delete");
        [alarms removeObjectAtIndex:indexPath.row];
        [tableViewOutlet reloadData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"EditAlarmSegue"]) {
        EditAlarmViewController *dest = (EditAlarmViewController *)[[segue destinationViewController] topViewController];
        dest.alarm = selectedAlarm;
        NSLog(@"Hit");
    }
}

@end