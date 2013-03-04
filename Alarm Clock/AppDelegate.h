//
//  AppDelegate.h
//  Alarm Clock
//
//  Created by Jonas Dahl on 2013-02-22.
//  Copyright (c) 2013 Dahl & Montalvo Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthConsumer.h"
#import <sqlite3.h>
#import "Alarm.h"
#import "TelldusAction.h"
#import "AlarmViewController.h"
//#include "MainClockViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    NSString *databaseName;
	NSString *databasePath;
    NSMutableArray *alarms;
    NSMutableArray *actions;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) OAToken *accessToken;
@property (nonatomic, retain) NSMutableArray *alarms;
@property (nonatomic, retain) NSMutableArray *actions;

-(Alarm *)getAlarmWithId:(NSNumber *)alarmLocalId;
-(TelldusAction *)getTelldusActionWithId:(NSNumber *)actionLocalId;
-(void)deleteAlarmWithId:(NSNumber *)alarmLocalId;
-(void)deleteActionWithId:(NSNumber *)actionLocalId;
-(NSNumber *)addAlarm;
-(NSNumber *)addActionForAlarm:(NSNumber *)alarmId;
-(void)getAlarms;
-(void)getActions;
-(void)updateAlarmWithId:(NSNumber *)localId name:(NSString *)name datetime:(NSDate *)date active:(NSNumber *)active repeat:(NSMutableArray *)repeat;
-(void)setActive:(NSNumber *)a forAlarmWithId:(NSNumber *)i;

@end
