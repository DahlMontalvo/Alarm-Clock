//
//  AppDelegate.m
//  Alarm Clock
//
//  Created by Jonas Dahl on 2013-02-22.
//  Copyright (c) 2013 Dahl & Montalvo Applications. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize accessToken, alarms, actions;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Setup some globals
	databaseName = @"AlarmClock.sql";
    
	// Get the path to the documents directory and append the databaseName
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
    
	// Execute the "checkAndCreateDatabase" function
	[self checkAndCreateDatabase];
    
    [self getAlarms];
    [self getActions];
    
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }
    NSLog(@"Alarms: %@", alarms);
    
    UILocalNotification *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    [self receivedNotif:localNotif application:application];
    
    return YES;
}

- (void)receivedNotif:(UILocalNotification *)notif application:(UIApplication *)application {
    if (notif) {
        NSLog(@"Did receive local notif");
        //NSString *itemName = [notif.userInfo objectForKey:@"AlarmName"];
        
        AlarmViewController *vc = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"AlarmViewController"];
        
        /*AlarmDidSoundViewController *alarmDidSoundViewController = (AlarmDidSoundViewController *)[[AlarmDidSoundViewController alloc] initWithNibName:@"AlarmDidSoundViewController" bundle:nil];
        */
        UINavigationController *nvcontrol = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nvcontrol;
        [[self window] makeKeyAndVisible];
    }
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [self receivedNotif:notification application:application];
}

- (Alarm *)getAlarmWithId:(NSNumber *)alarmLocalId {
	// Init the animals Array
	Alarm *alarm;
    
    for(Alarm *aAlarm in alarms) {
        if ([aAlarm.localId intValue] == [alarmLocalId intValue])
            alarm = aAlarm;
    }
    
    return alarm;
}

- (TelldusAction *)getTelldusActionWithId:(NSNumber *)actionLocalId {
	// Init the animals Array
	TelldusAction *action;
    
    for(TelldusAction *aAction in actions) {
        if ([aAction.localId intValue] == [actionLocalId intValue])
            action = aAction;
    }
    
    return action;
}

- (void)setActive:(NSNumber *)a forAlarmWithId:(NSNumber *)i {
    // Setup the database object
	sqlite3 *database;
    
	// Init the animals Array
	alarms = [[NSMutableArray alloc] init];
    
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = [[NSString stringWithFormat:@"UPDATE alarms SET active = %i WHERE id = %i",[a intValue], [i intValue]] UTF8String];
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        
	}
	sqlite3_close(database);
    
    //Uppdatera alarmslistan
    [self getAlarms];
}

- (void)updateAlarmWithId:(NSNumber *)localId name:(NSString *)name datetime:(NSDate *)date active:(NSNumber *)active repeat:(NSMutableArray *)repeat {
    // Setup the database object
	sqlite3 *database;
    
	// Init the animals Array
	alarms = [[NSMutableArray alloc] init];
    
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
#warning ÄNDRA DATUMFORMATET!!! FEL!!! ENDAST FÖR TEST!!!
        NSString *dateString = [formatter stringFromDate:date];
        NSLog(@"Date: %@ %@", dateString, date);
		const char *sqlStatement = [[NSString stringWithFormat:@"UPDATE alarms SET name = '%@', time = '%@', active = '%i', repeat_mo = %i, repeat_tu = %i, repeat_we = %i, repeat_th = %i, repeat_fr = %i, repeat_sa = %i, repeat_su = %i WHERE id = %i",
                                     name,
                                     dateString,
                                     [active intValue],
                                     [[repeat objectAtIndex:0] intValue],
                                     [[repeat objectAtIndex:1] intValue],
                                     [[repeat objectAtIndex:2] intValue],
                                     [[repeat objectAtIndex:3] intValue],
                                     [[repeat objectAtIndex:4] intValue],
                                     [[repeat objectAtIndex:5] intValue],
                                     [[repeat objectAtIndex:6] intValue],
                                     [localId intValue]] UTF8String];
        NSLog(@"HERE: %s", sqlStatement);
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        
	}
	sqlite3_close(database);
    
    //Uppdatera alarmslistan
    [self getAlarms];
    
    [self scheduleAlarmWithId:localId];
}

- (void)deleteActionWithId:(NSNumber *)actionLocalId {
    // Setup the database object
	sqlite3 *database;
    
	// Init the animals Array
	alarms = [[NSMutableArray alloc] init];
    
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = [[NSString stringWithFormat:@"DELETE FROM actions WHERE id = %i", [actionLocalId intValue]] UTF8String];
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        
	}
	sqlite3_close(database);
    
    //Uppdatera alarmslistan
    [self getActions];
}

- (void)deleteAlarmWithId:(NSNumber *)alarmLocalId {
    // Setup the database object
	sqlite3 *database;
    
	// Init the animals Array
	alarms = [[NSMutableArray alloc] init];
    
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = [[NSString stringWithFormat:@"DELETE FROM alarms WHERE id = %i", [alarmLocalId intValue]] UTF8String];
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        
	}
	sqlite3_close(database);
    
    //Uppdatera alarmslistan
    [self getAlarms];
}

- (NSNumber *)addAlarm {
    NSNumber *Id = 0;
    
    // Setup the database object
	sqlite3 *database;
    
    int randomInt = arc4random() % 10000000 + 489823;
    
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        NSString *dateString;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        dateString = [formatter stringFromDate:[NSDate date]];
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = [[NSString stringWithFormat:@"INSERT INTO alarms (name, active, time, signal) VALUES ('%i', 1, '%@:00', 'Default')", randomInt, dateString] UTF8String];
        NSLog(@"%s", sqlStatement);
		sqlite3_stmt *compiledStatement;
        sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
        }
		sqlite3_finalize(compiledStatement);
        
        
        // Setup the SQL Statement and compile it for faster access
		const char *sqlStatement2 = [[NSString stringWithFormat:@"SELECT * FROM alarms WHERE name = '%i'", randomInt] UTF8String];
		sqlite3_stmt *compiledStatement2;
		if(sqlite3_prepare_v2(database, sqlStatement2, -1, &compiledStatement2, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement2) == SQLITE_ROW) {
                Id = [NSNumber numberWithInt:(int)sqlite3_column_int(compiledStatement2, 0)];
                NSLog(@"ID: %@", Id);
			}
		}
		sqlite3_finalize(compiledStatement2);
        
        const char *sqlStatement3 = [[NSString stringWithFormat:@"UPDATE alarms SET name = 'Alarm' WHERE id = %i", [Id intValue]] UTF8String];
		sqlite3_stmt *compiledStatement3;
		sqlite3_prepare_v2(database, sqlStatement3, -1, &compiledStatement3, NULL);
        while(sqlite3_step(compiledStatement3) == SQLITE_ROW) {
        }
		sqlite3_finalize(compiledStatement3);
	}
	sqlite3_close(database);
    
    //Uppdatera alarmslistan
    [self getAlarms];
    return Id;
}

-(void)scheduleAlarmWithId:(NSNumber *)localId {
    Alarm *thisAlarm = [self getAlarmWithId:localId];
    NSMutableArray *repeat = [thisAlarm repeat];
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *todayComponents = [calendar components:NSWeekdayCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
    
    NSDateComponents *weekdayComponents = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:[thisAlarm datetime]];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    
    [dateComps setDay:[todayComponents day]];
    [dateComps setMonth:[todayComponents month]];
    [dateComps setYear:[todayComponents year]];
    
    [dateComps setHour:[weekdayComponents hour]];
    [dateComps setMinute:[weekdayComponents minute]];
    NSDate *itemDate = [calendar dateFromComponents:dateComps];
    
    //Veckodag idag - 0 är måndag 6 är söndag
    int weekday = [todayComponents weekday]-2; if (weekday == -1) weekday = 6;
    
    for (int i = 0; i < [repeat count]; i++) {
        if ([[repeat objectAtIndex:i] intValue] == 1) {
            int daysLeft = i-weekday;
            if (daysLeft < 0) {
                daysLeft+=7;
            }
            else if (daysLeft == 0) {
                if ([[thisAlarm datetime] timeIntervalSinceDate:[NSDate date]] < 0)
                    daysLeft += 7;
            }
            
            NSDate *newDate = [itemDate dateByAddingTimeInterval:86400*daysLeft];
            
            UILocalNotification *alarmNotif = [[UILocalNotification alloc] init];
            NSDictionary *infoDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[thisAlarm localId], [NSNumber numberWithInt:i], nil] forKeys:[NSArray arrayWithObjects:@"AlarmId", @"Weekday", nil]];
            alarmNotif.repeatCalendar = calendar;
            alarmNotif.repeatInterval = NSWeekCalendarUnit;
            alarmNotif.fireDate = newDate;
            NSLog(@"New date: %@", newDate);
            alarmNotif.timeZone = [NSTimeZone defaultTimeZone];
            alarmNotif.alertBody = @"Alarm";
            alarmNotif.alertAction = NSLocalizedString(@"Turn off", nil);
            alarmNotif.soundName = @"TestSound.wav";
            alarmNotif.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber]+1;
            alarmNotif.userInfo = infoDict;
            [[UIApplication sharedApplication] scheduleLocalNotification:alarmNotif];
        }
    }
}

- (NSNumber *)addActionForAlarm:(NSNumber *)alarmId {
    NSNumber *Id = 0;
    
    // Setup the database object
	sqlite3 *database;
    
    int randomInt = arc4random() % 10000000 + 489823;
    
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = [[NSString stringWithFormat:@"INSERT INTO actions (telldusId, telldusName, offset, action, alarmId) VALUES (%i, '', 0, 'turnon', %i)", randomInt, [alarmId intValue]] UTF8String];
		sqlite3_stmt *compiledStatement;
        sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
        }
		sqlite3_finalize(compiledStatement);
        
        
        // Setup the SQL Statement and compile it for faster access
		const char *sqlStatement2 = [[NSString stringWithFormat:@"SELECT * FROM actions WHERE telldusId = %i", randomInt] UTF8String];
		sqlite3_stmt *compiledStatement2;
		if(sqlite3_prepare_v2(database, sqlStatement2, -1, &compiledStatement2, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement2) == SQLITE_ROW) {
                Id = [NSNumber numberWithInt:(int)sqlite3_column_int(compiledStatement2, 0)];
                NSLog(@"ID: %@", Id);
			}
		}
		sqlite3_finalize(compiledStatement2);
        
        const char *sqlStatement3 = [[NSString stringWithFormat:@"UPDATE actions SET telldusId = 0 WHERE id = %i", [Id intValue]] UTF8String];
		sqlite3_stmt *compiledStatement3;
		sqlite3_prepare_v2(database, sqlStatement3, -1, &compiledStatement3, NULL);
        while(sqlite3_step(compiledStatement3) == SQLITE_ROW) {
        }
		sqlite3_finalize(compiledStatement3);
	}
	sqlite3_close(database);
    
    //Uppdatera alarmslistan
    [self getActions];
    NSLog(@"Actions: %@", actions);
    return Id;
}

- (void)getAlarms {
    // Setup the database object
	sqlite3 *database;
    
	// Init the animals Array
	alarms = [[NSMutableArray alloc] init];
    
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = "SELECT * FROM alarms";
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
                NSNumber *aId = [NSNumber numberWithInt:(int)sqlite3_column_int(compiledStatement, 0)];
				NSString *aName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *date = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //this is the sqlite's format
                NSDate *aDatetime = [formatter dateFromString:date];
				NSNumber *aActive = [NSNumber numberWithInt:(int)sqlite3_column_int(compiledStatement, 2)];
                
                NSMutableArray *repeat = [[NSMutableArray alloc] init];
                [repeat addObject:[NSNumber numberWithInt:(int)sqlite3_column_int(compiledStatement, 4)]];
                [repeat addObject:[NSNumber numberWithInt:(int)sqlite3_column_int(compiledStatement, 5)]];
                [repeat addObject:[NSNumber numberWithInt:(int)sqlite3_column_int(compiledStatement, 6)]];
                [repeat addObject:[NSNumber numberWithInt:(int)sqlite3_column_int(compiledStatement, 7)]];
                [repeat addObject:[NSNumber numberWithInt:(int)sqlite3_column_int(compiledStatement, 8)]];
                [repeat addObject:[NSNumber numberWithInt:(int)sqlite3_column_int(compiledStatement, 9)]];
                [repeat addObject:[NSNumber numberWithInt:(int)sqlite3_column_int(compiledStatement, 10)]];
                
				// Create a new animal object with the data from the database
				Alarm *alarm = [[Alarm alloc] initWithName:aName localId:aId datetime:aDatetime active:aActive repeat:repeat];
                
				// Add the animal object to the animals Array
				[alarms addObject:alarm];
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        
	}
	sqlite3_close(database);
}

- (void)getActions {
    // Setup the database object
	sqlite3 *database;
    
	// Init the animals Array
	actions = [[NSMutableArray alloc] init];
    
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = "SELECT * FROM actions";
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
                NSNumber *aId = [NSNumber numberWithInt:(int)sqlite3_column_int(compiledStatement, 0)];
                NSNumber *aTelldusId = [NSNumber numberWithInt:(int)sqlite3_column_int(compiledStatement, 1)];
				NSString *aTelldusName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSNumber *aOffset = [NSNumber numberWithInt:(int)sqlite3_column_int(compiledStatement, 3)];
				NSString *aAction = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                NSNumber *aAlarmId = [NSNumber numberWithInt:(int)sqlite3_column_int(compiledStatement, 5)];
				
                // Create a new animal object with the data from the database
				TelldusAction *action = [[TelldusAction alloc] initWithTelldusDeviceId:aTelldusId telldusDeviceName:aTelldusName action:aAction offset:aOffset localId:aId alarmId:aAlarmId];
                
				// Add the animal object to the animals Array
				[actions addObject:action];
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        
	}
	sqlite3_close(database);
}

- (void)checkAndCreateDatabase{
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
    
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
    
	// If the database already exists then return without doing anything
	if(success) return;
    
	// If not then proceed to copy the database from the application to the users filesystem
    
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
    
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
