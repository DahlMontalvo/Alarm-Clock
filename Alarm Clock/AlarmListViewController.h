//
//  AlarmListViewController.h
//  Alarm Clock
//
//  Created by Jonas Dahl on 2013-02-22.
//  Copyright (c) 2013 Dahl & Montalvo Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray *alarms;
@property (nonatomic, assign) int selectedAlarm;

@property (strong, nonatomic) IBOutlet UITableView *tableViewOutlet;

- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)addButtonPressed:(id)sender;


@end
