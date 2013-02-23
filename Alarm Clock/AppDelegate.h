//
//  AppDelegate.h
//  Alarm Clock
//
//  Created by Jonas Dahl on 2013-02-22.
//  Copyright (c) 2013 Dahl & Montalvo Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthConsumer.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) OAToken *accessToken;

@end
