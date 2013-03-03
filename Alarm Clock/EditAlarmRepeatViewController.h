//
//  EditAlarmRepeatViewController.h
//  Alarm Clock
//
//  Created by Jonas Dahl on 2013-02-24.
//  Copyright (c) 2013 Dahl & Montalvo Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAlarmRepeatViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *values;
}

@property (nonatomic, retain) NSMutableArray *days;
@property (nonatomic, retain) NSMutableArray *values;

@property (strong, nonatomic) IBOutlet UITableView *tableViewOutlet;

- (IBAction)doneButtonPressed:(id)sender;

@end
