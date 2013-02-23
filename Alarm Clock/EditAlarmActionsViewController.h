//
//  EditAlarmActionsViewController.h
//  Alarm Clock
//
//  Created by Jonas Dahl on 2013-02-23.
//  Copyright (c) 2013 Dahl & Montalvo Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAlarmActionsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    int alarm;
}

@property (nonatomic, assign) int alarm;
@property (nonatomic, retain) NSMutableArray *actions;

@property (strong, nonatomic) IBOutlet UITableView *tableViewOutlet;

- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)addButtonPressed:(id)sender;

@end
