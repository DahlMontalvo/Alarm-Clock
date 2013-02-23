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
#include "Alarm.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    NSString *databaseName;
	NSString *databasePath;
    NSMutableArray *alarms;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) OAToken *accessToken;
@property (nonatomic, retain) NSMutableArray *alarms;

- (Alarm *)getAlarmWithId:(NSNumber *)alarmLocalId;

@end
