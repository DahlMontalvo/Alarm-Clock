//
//  EditAlarmViewController.h
//  Alarm Clock
//
//  Created by Jonas Dahl on 2013-02-23.
//  Copyright (c) 2013 Dahl & Montalvo Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "EditAlarmActionsViewController.h"

@interface EditAlarmViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    int alarm;
}

@property (strong, nonatomic) IBOutlet UITableView *tableViewOutlet;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, assign) int alarm;
@property (nonatomic, retain) NSMutableArray *settings;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)datePickerChanged:(id)sender;

@end
