//
//  EditAlarmSnoozeViewController.h
//  Alarm Clock
//
//  Created by Jonas Dahl on 2013-03-06.
//  Copyright (c) 2013 Dahl & Montalvo Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAlarmSnoozeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;

@end
