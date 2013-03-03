//
//  EditAlarmEditActionViewController.m
//  Alarm Clock
//
//  Created by Jonas Dahl on 2013-02-23.
//  Copyright (c) 2013 Dahl & Montalvo Applications. All rights reserved.
//

#import "EditAlarmEditActionViewController.h"

@interface EditAlarmEditActionViewController ()

@end

@implementation EditAlarmEditActionViewController

@synthesize action, properties, picker, tableViewOutlet, availableDevices, availableActions, activePicker, finalizeLabel, tapRecognizer;

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
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(didTapAnywhere:)];
    
    [self hidePicker];
}

-(void) keyboardWillShow:(NSNotification *) note {
    NSLog(@"Tap aktiv");
    [self.view addGestureRecognizer:tapRecognizer];
}

-(void) keyboardWillHide:(NSNotification *) note
{
    NSLog(@"Tap inaktiv");
    [self.view removeGestureRecognizer:tapRecognizer];
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    [[[tableViewOutlet cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] viewWithTag:2] resignFirstResponder];
    [self hidePicker];
    NSLog(@"Tap");
}

- (IBAction)textFieldChanged:(id)sender {
    UITableViewCell *cell = [tableViewOutlet cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    ((UIStepper *)[cell viewWithTag:3]).value = [((UITextField *)[cell viewWithTag:2]).text floatValue];
    [self updateLabel];
}

- (void)updateLabel {
    NSLog(@"Updating");
    NSString *device = [tableViewOutlet cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].detailTextLabel.text;
    NSString *act = [tableViewOutlet cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].detailTextLabel.text;
    int offset = [((UITextField *)[[tableViewOutlet cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] viewWithTag:2]).text intValue];
    NSLog(@"Offset: %i", offset);
    NSString *beforeAfter;
    if (offset == 0) {
        finalizeLabel.text = [NSString stringWithFormat:@"%@ will %@ when the alarm sounds.", device, act];
    }
    else {
        if (offset < 0) {
            beforeAfter = @"before";
            offset = 0-offset;
        }
        else {
            beforeAfter = @"after";
        }
        finalizeLabel.text = [NSString stringWithFormat:@"%@ will %@ %i minutes %@ the alarm.", device, act, offset, beforeAfter];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self performSelector:@selector(hidePickerStable) withObject:nil afterDelay:0.01];
    
    [self updateLabel];
    [picker setHidden:YES];
    [self hidePicker];
    
    properties = [[NSMutableArray alloc] init];
    [properties addObject:[[NSMutableArray alloc] initWithObjects:@"Device", @"Detail", @"", nil]];
    [properties addObject:[[NSMutableArray alloc] initWithObjects:@"Action", @"Detail", @"Turn on", nil]];
    [properties addObject:[[NSMutableArray alloc] initWithObjects:@"Offset", @"Offset", @"", nil]];
    
    OAToken *accessToken = (OAToken *)[NSKeyedUnarchiver unarchiveObjectWithData:[[[Singleton sharedSingleton] sharedPrefs] objectForKey:@"TelldusAccessToken"]];
    NSLog(@"AccessToken: %@", accessToken);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.telldus.com/json/devices/list?oauth_token=%@&oauth_callback=done", [accessToken key]]];
    
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:@"FEHUVEW84RAFR5SP22RABURUPHAFRUNU"
                                                    secret:@"ZUXEVEGA9USTAZEWRETHAQUBUR69U6EF"];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:accessToken
                                                                      realm:nil
                                                          signatureProvider:[[OAPlaintextSignatureProvider alloc] init]];
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(apiTicket:didFinishWithData:)
                  didFailSelector:@selector(apiTicket:didFailWithError:)];
    
    availableDevices = [[NSMutableArray alloc] init];
    availableActions = [[NSMutableArray alloc] init];
    [availableActions addObject:[[NSMutableArray alloc] initWithObjects:@"Turn on", @"Turnon", nil]];
    [availableActions addObject:[[NSMutableArray alloc] initWithObjects:@"Turn off", @"Turnoff", nil]];
    [availableActions addObject:[[NSMutableArray alloc] initWithObjects:@"Fade up in 30 mins", @"30minFade", nil]];
}

- (void)hidePickerStable {
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    [picker setFrame:CGRectMake(0.0f, height, 320.0f, 216.0f)];
}

- (void)apiTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    NSLog(@"Data: %@", responseBody);
    NSError *e = nil;
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
    
    if (!jsonArray) {
        NSLog(@"Error parsing JSON: %@", e);
    } else {
        NSLog(@"Array: %@", jsonArray);
    }
    for(NSDictionary *item in [jsonArray objectForKey:@"device"]) {
    NSLog(@"%@", [item objectForKey:@"name"]);
        [availableDevices addObject:[[NSMutableArray alloc] initWithObjects:[item objectForKey:@"name"], [NSNumber numberWithInt:[[item objectForKey:@"id"] intValue]], nil]];
    }
    if ([availableDevices count]>0) {
        [[properties objectAtIndex:0] setObject:[[availableDevices objectAtIndex:0] objectAtIndex:0] atIndex:2];
        [tableViewOutlet reloadData];
    }
    [picker reloadAllComponents];
    [self updateLabel];
}

- (void)apiTicket:(OAServiceTicket *)ticket didFailWithError:(NSData *)data {
    NSLog(@"Error: %@", data);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)stepperChanged:(id)sender {
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    UITextField *textField = (UITextField *)[cell viewWithTag:2];
    textField.text = [NSString stringWithFormat:@"%i", (int)(((UIStepper *)[cell viewWithTag:3]).value)];
    [self updateLabel];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [properties count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [[properties objectAtIndex:indexPath.row] objectAtIndex:1];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([CellIdentifier isEqualToString:@"Detail"]) {
        cell.textLabel.text = [[properties objectAtIndex:indexPath.row] objectAtIndex:0];
        cell.detailTextLabel.text = [[properties objectAtIndex:indexPath.row] objectAtIndex:2];
    }
    else if ([CellIdentifier isEqualToString:@"Offset"]) {
        UILabel *text = (UILabel *)[cell viewWithTag:1];
        text.text = @"Offset (mins)";
        
        UIStepper *stepper = (UIStepper *)[cell viewWithTag:3];
        NSLog(@"Stepper: %f", stepper.value);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"Detail"]) {
        activePicker = cell.textLabel.text;
        [self showPicker];
        [picker reloadAllComponents];
    }
    else {
        [self hidePicker];
    }
    [self updateLabel];
}

- (void)hidePicker {
    [UIView beginAnimations:nil context:NULL];
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    [picker setFrame:CGRectMake(0.0f, height, 320.0f, 216.0f)];
    [UIView commitAnimations];
    [self keyboardWillHide:nil];
}

- (void)showPicker {
    [picker setHidden:NO];
    [UIView beginAnimations:nil context:NULL];
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    [picker setFrame:CGRectMake(0.0f, height-236.0f, 320.0f, 216.0f)];
    [UIView commitAnimations];
    NSLog(@"ActivePicker: %@", activePicker);
    [self keyboardWillShow:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

#pragma mark - Picker view

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([activePicker isEqualToString:@"Device"]) {
        [[properties objectAtIndex:0] setObject:[[availableDevices objectAtIndex:row] objectAtIndex:0] atIndex:2];
    }
    else if ([activePicker isEqualToString:@"Action"]) {
        [[properties objectAtIndex:1] setObject:[[availableActions objectAtIndex:row] objectAtIndex:0] atIndex:2];
    }
    [tableViewOutlet reloadData];
    [self updateLabel];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if ([activePicker isEqualToString:@"Device"]) {
        return [availableDevices count];
    }
    else if ([activePicker isEqualToString:@"Action"]) {
        return [availableActions count];
    }
    else {
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    if ([activePicker isEqualToString:@"Device"]) {
        return [[availableDevices objectAtIndex:row] objectAtIndex:0];
    }
    else if ([activePicker isEqualToString:@"Action"]) {
        return [[availableActions objectAtIndex:row] objectAtIndex:0];
    }
    else {
        return @"";
    }
}

@end
