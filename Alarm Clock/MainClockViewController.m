//
//  MainClockViewController.m
//  Alarm Clock
//
//  Created by Jonas Dahl on 2013-02-22.
//  Copyright (c) 2013 Dahl & Montalvo Applications. All rights reserved.
//

#import "MainClockViewController.h"

@interface MainClockViewController ()

@end

@implementation MainClockViewController

@synthesize ampmDisplay, timeDisplay, secondsDisplay, dateDisplay, dayDisplay, clockUpdater, nextAlarmLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [clockUpdater invalidate];
    clockUpdater = nil;
}

- (void)updateClock {
    NSDate *dateShow = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"a"];
    
    NSDateFormatter *secondFormatter = [[NSDateFormatter alloc] init];
    [secondFormatter setDateFormat:@"ss"];
    
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"EEE"];
    
    NSDateFormatter *fullDateFormatter = [[NSDateFormatter alloc] init];
    [fullDateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //[dateFormat setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormat stringFromDate:dateShow];
    NSString *ampmString = [outputFormatter stringFromDate:dateShow];
    NSString *secondsString = [secondFormatter stringFromDate:dateShow];
    NSString *dayString = [dayFormatter stringFromDate:dateShow];
    NSString *fullDateString = [fullDateFormatter stringFromDate:dateShow];
    
    ampmDisplay.text = ampmString;
    timeDisplay.text = dateString;
    secondsDisplay.text = secondsString;
    dayDisplay.text = dayString;
    dateDisplay.text = fullDateString;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [[self.navigationController navigationBar] setHidden:YES];
    [self performSelector:@selector(updateClock) withObject:nil afterDelay:0];
	clockUpdater = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(updateClock)
                                                  userInfo:nil
                                                   repeats:YES];
    nextAlarmLabel.text = @"Today 6:30";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
