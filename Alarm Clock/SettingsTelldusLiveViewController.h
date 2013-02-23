//
//  SettingsTelldusLiveViewController.h
//  Alarm Clock
//
//  Created by Jonas Dahl on 2013-02-23.
//  Copyright (c) 2013 Dahl & Montalvo Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTelldusLiveViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableViewOutlet;

@property (nonatomic, retain) NSMutableArray *settings;

- (IBAction)doneButtonPressed:(id)sender;

@end
