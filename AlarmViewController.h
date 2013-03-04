//
//  AlarmViewController.h
//  Alarm Clock
//
//  Created by Jonas Dahl on 2013-03-03.
//  Copyright (c) 2013 Dahl & Montalvo Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MainClockViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface AlarmViewController : UIViewController <AVAudioPlayerDelegate> {
    AVAudioPlayer *audioPlayer;
}

@property (nonatomic, retain) NSTimer *clockUpdater;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

- (IBAction)turnOffButtonPressed:(id)sender;
- (IBAction)snoozeButtonPressed:(id)sender;

@end
