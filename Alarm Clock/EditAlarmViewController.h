//
//  EditAlarmViewController.h
//  Alarm Clock
//
//  Created by Jonas Dahl on 2013-02-23.
//  Copyright (c) 2013 Dahl & Montalvo Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "EditAlarmActionsViewController.h"
#include "AppDelegate.h"
#include "EditAlarmRepeatViewController.h"

@interface EditAlarmViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSNumber *alarmId;
}

@property (strong, nonatomic) IBOutlet UITableView *tableViewOutlet;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;

@property (nonatomic, retain) NSNumber *alarmId;
@property (nonatomic, retain) NSString *alarmName;
@property (nonatomic, retain) NSDate *alarmDate;
@property (nonatomic, retain) NSNumber *alarmActive;
@property (nonatomic, retain) NSMutableArray *alarmRepeat;
@property (nonatomic, retain) NSMutableArray *settings;
@property (nonatomic, retain) EditAlarmRepeatViewController *vc;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)datePickerChanged:(id)sender;
- (void)didTapAnywhere:(UITapGestureRecognizer*)recognizer;
- (IBAction)textFieldDidChange:(id)sender;

@end
