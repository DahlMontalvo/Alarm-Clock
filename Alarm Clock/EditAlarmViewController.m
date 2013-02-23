//
//  EditAlarmViewController.m
//  Alarm Clock
//
//  Created by Jonas Dahl on 2013-02-23.
//  Copyright (c) 2013 Dahl & Montalvo Applications. All rights reserved.
//

#import "EditAlarmViewController.h"

@interface EditAlarmViewController ()

@end

@implementation EditAlarmViewController

@synthesize alarm, tableViewOutlet, settings, datePicker;

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

- (void)hidePicker {
    [UIView beginAnimations:nil context:NULL];
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    [datePicker setFrame:CGRectMake(0.0f, height, 320.0f, 216.0f)];
    [UIView commitAnimations];
    //[self keyboardWillHide:nil];
}

- (void)showPicker {
    [datePicker setHidden:NO];
    [UIView beginAnimations:nil context:NULL];
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    [datePicker setFrame:CGRectMake(0.0f, height-236.0f, 320.0f, 216.0f)];
    [UIView commitAnimations];
    //[self keyboardWillShow:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    [self hidePicker];
    [datePicker setHidden:YES];
    NSLog(@"Hit");
    settings = [[NSMutableArray alloc] init];
    //[settings addObject:[[NSMutableArray alloc] initWithObjects:@"Display Name", @"Segue name", @"Cell identifier", nil]];
    NSMutableArray *group1 = [[NSMutableArray alloc] initWithObjects:@"", [[NSMutableArray alloc] init], nil];
    [[group1 objectAtIndex:1] addObject:[[NSMutableArray alloc] initWithObjects:@"Name", @"", @"Name", nil]];
    [[group1 objectAtIndex:1] addObject:[[NSMutableArray alloc] initWithObjects:@"Time", @"15:56", @"Time", nil]];
    [[group1 objectAtIndex:1] addObject:[[NSMutableArray alloc] initWithObjects:@"Repeat", @"RepeatSegue", @"DetailDisclosure", nil]];
    [[group1 objectAtIndex:1] addObject:[[NSMutableArray alloc] initWithObjects:@"Signal", @"SignalSegue", @"DetailDisclosure", nil]];
    [[group1 objectAtIndex:1] addObject:[[NSMutableArray alloc] initWithObjects:@"Actions", @"ActionsSegue", @"Disclosure", nil]];
    [settings addObject:group1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonPressed:(id)sender {
}

- (IBAction)datePickerChanged:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    [tableViewOutlet cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].detailTextLabel.text = [dateFormatter stringFromDate:[datePicker date]];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [settings count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[[settings objectAtIndex:section] objectAtIndex:1] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [[[[settings objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row] objectAtIndex:2];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([CellIdentifier isEqualToString:@"Name"]) {
        
    }
    else if ([CellIdentifier isEqualToString:@"Time"]) {
        cell.textLabel.text = @"Time";
    }
    else
        if ([CellIdentifier isEqualToString:@"Disclosure"]) {
        cell.textLabel.text = [[[[settings objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row] objectAtIndex:0];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[[tableView cellForRowAtIndexPath:indexPath] reuseIdentifier] isEqualToString:@"Disclosure"]) {
        [self performSegueWithIdentifier:[[[[settings objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row] objectAtIndex:1] sender:self];
    }
    else if ([[[tableView cellForRowAtIndexPath:indexPath] reuseIdentifier] isEqualToString:@"Time"]) {
        [self showPicker];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ActionsSegue"]) {
        EditAlarmActionsViewController *vc = [segue destinationViewController];
        vc.alarm = alarm;
    }
}

@end
