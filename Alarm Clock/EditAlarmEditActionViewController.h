//
//  EditAlarmEditActionViewController.h
//  Alarm Clock
//
//  Created by Jonas Dahl on 2013-02-23.
//  Copyright (c) 2013 Dahl & Montalvo Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthConsumer.h"
#import "AppDelegate.h"
#include "Singleton.h"

@interface EditAlarmEditActionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate> {
    int action;
}

@property (strong, nonatomic) IBOutlet UITableView *tableViewOutlet;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UILabel *finalizeLabel;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;

@property (nonatomic, assign) int action;
@property (nonatomic, retain) NSMutableArray *properties;
@property (nonatomic, retain) NSMutableArray *availableDevices;
@property (nonatomic, retain) NSMutableArray *availableActions;
@property (nonatomic, retain) NSString *activePicker;

- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)stepperChanged:(id)sender;
- (void)didTapAnywhere:(UITapGestureRecognizer*)recognizer;
- (IBAction)textFieldChanged:(id)sender;

@end
