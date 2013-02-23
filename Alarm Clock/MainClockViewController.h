//
//  MainClockViewController.h
//  Alarm Clock
//
//  Created by Jonas Dahl on 2013-02-22.
//  Copyright (c) 2013 Dahl & Montalvo Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainClockViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *ampmDisplay;
@property (strong, nonatomic) IBOutlet UILabel *timeDisplay;
@property (strong, nonatomic) IBOutlet UILabel *secondsDisplay;
@property (strong, nonatomic) IBOutlet UILabel *dayDisplay;
@property (strong, nonatomic) IBOutlet UILabel *dateDisplay;
@property (strong, nonatomic) IBOutlet UILabel *nextAlarmLabel;

@property (nonatomic, retain) NSTimer *clockUpdater;

@end
