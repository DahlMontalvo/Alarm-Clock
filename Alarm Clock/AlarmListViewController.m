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
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray *alarmObjects = [[NSMutableArray alloc] initWithArray:[appDelegate alarms]];
    
    alarms = [[NSMutableArray alloc] init];
    for(Alarm *aAlarm in alarmObjects) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSString *time = [formatter stringFromDate:[aAlarm datetime]];
        [alarms addObject:[[NSMutableArray alloc] initWithObjects:[aAlarm name], [aAlarm localId], time, [aAlarm active], nil]];
    }
    
    [tableViewOutlet reloadData];
    
    //[alarms addObject:[[NSMutableArray alloc] initWithObjects:@"Placeholder alarm", [NSNumber numberWithInt:123], @"15:46", [NSNumber numberWithInt:0], nil]];
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
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    selectedAlarm = [[appDelegate addAlarm] intValue]; //Nytt alarm id
    NSLog(@"Selected: %i", selectedAlarm);
    if (selectedAlarm != 0) {
        [self performSegueWithIdentifier:@"EditAlarmSegue" sender:self];
    }
}

- (IBAction)toggleSwitchToggled:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    int i = 0;
    for (Alarm *aAlarm in [appDelegate alarms]) {
        int val = 0;
        if (((UISwitch *)[[tableViewOutlet cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] viewWithTag:1]).on) {
            val = 1;
        }
        [appDelegate setActive:[NSNumber numberWithInt:val] forAlarmWithId:[aAlarm localId]];
        [[alarms objectAtIndex:i] setObject:[NSNumber numberWithInt:val] atIndex:3];
        i++;
    }
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
    
    if ([[[alarms objectAtIndex:indexPath.row] objectAtIndex:3] intValue] == 1) {
        ((UISwitch *)[cell viewWithTag:1]).on = true;
    }
    else {
        ((UISwitch *)[cell viewWithTag:1]).on = false;
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
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate deleteAlarmWithId:[[alarms objectAtIndex:indexPath.row] objectAtIndex:1]];
        [alarms removeObjectAtIndex:indexPath.row];
        [tableViewOutlet reloadData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"EditAlarmSegue"]) {
        EditAlarmViewController *dest = (EditAlarmViewController *)[[segue destinationViewController] topViewController];
        dest.alarmId = [NSNumber numberWithInt:selectedAlarm];
        NSLog(@"Hit");
    }
}

@end