//
//  AlarmViewController.m
//  Alarm Clock
//
//  Created by Jonas Dahl on 2013-03-03.
//  Copyright (c) 2013 Dahl & Montalvo Applications. All rights reserved.
//

#import "AlarmViewController.h"

@interface AlarmViewController ()

@end

@implementation AlarmViewController

@synthesize timeLabel, clockUpdater;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [self updateClock];
    [[self.navigationController navigationBar] setHidden:YES];
}

- (void)viewDidLoad
{
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/TestSound.wav", [[NSBundle mainBundle] resourcePath]]];
	
	NSError *error = [[NSError alloc] init];
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	audioPlayer.numberOfLoops = -1;
	
	if (audioPlayer == nil)
		NSLog([error description]);
	else
		[audioPlayer play];
    clockUpdater = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(updateClock)
                                                  userInfo:nil
                                                   repeats:YES];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)updateClock {
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    timeLabel.text = [formatter stringFromDate:now];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)turnOffButtonPressed:(id)sender {
    [audioPlayer stop];
    NSLog(@"Stäng av");
    MainClockViewController *vc = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"MainClockViewController"];
    UINavigationController *nvcontrol = [[UINavigationController alloc] initWithRootViewController:vc];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = nvcontrol;
    [[appDelegate window] makeKeyAndVisible];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber]-1];
}

- (IBAction)snoozeButtonPressed:(id)sender {
    [audioPlayer stop];
    NSLog(@"Snooze");
    MainClockViewController *vc = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"MainClockViewController"];
    UINavigationController *nvcontrol = [[UINavigationController alloc] initWithRootViewController:vc];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = nvcontrol;
    [[appDelegate window] makeKeyAndVisible];
}

@end
