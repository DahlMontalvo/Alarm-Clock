//
//  AuthorizeTelldusLiveViewController.h
//  Alarm Clock
//
//  Created by Jonas Dahl on 2013-02-23.
//  Copyright (c) 2013 Dahl & Montalvo Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <sys/types.h>
#import "OAuthConsumer.h"
#include "AppDelegate.h"
#include "Singleton.h"

@interface SettingsAuthorizeTelldusLiveViewController : UIViewController

@property (nonatomic, retain) OAToken *requestToken;
@property (nonatomic, retain) OAToken *accessToken;

@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)doneButtonPressed:(id)sender;

@end
