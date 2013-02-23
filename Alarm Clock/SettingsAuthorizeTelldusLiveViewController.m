//
//  AuthorizeTelldusLiveViewController.m
//  Alarm Clock
//
//  Created by Jonas Dahl on 2013-02-23.
//  Copyright (c) 2013 Dahl & Montalvo Applications. All rights reserved.
//

#import "SettingsAuthorizeTelldusLiveViewController.h"

@interface SettingsAuthorizeTelldusLiveViewController ()

@end

@implementation SettingsAuthorizeTelldusLiveViewController

@synthesize requestToken, accessToken, webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:@"FEHUVEW84RAFR5SP22RABURUPHAFRUNU"
                                                    secret:@"ZUXEVEGA9USTAZEWRETHAQUBUR69U6EF"];
    NSURL *url = [NSURL URLWithString:@"http://api.telldus.com/oauth/requestToken"];
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:nil   // we don't have a Token yet
                                                                      realm:nil   // our service provider doesn't specify a realm
                                                          signatureProvider:nil]; // use the default method, HMAC-SHA1
    [request setHTTPMethod:@"POST"];
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    if (ticket.didSucceed) {
        NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        requestToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
        NSLog(@"Trying: %@", requestToken);
        
        webView.delegate = (id<UIWebViewDelegate>)self;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.telldus.com/oauth/authorize?oauth_token=%@&oauth_callback=done", [requestToken key]]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
    else {
        NSLog(@"Fel");
    }
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSData *)data {
    NSLog(@"Error: %@", data);
}

- (void)checkIfAuthenticated {
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:@"FEHUVEW84RAFR5SP22RABURUPHAFRUNU"
                                                    secret:@"ZUXEVEGA9USTAZEWRETHAQUBUR69U6EF"];
    
    NSURL *url = [NSURL URLWithString:@"http://api.telldus.com/oauth/accessToken"];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:requestToken   // we don't have a Token yet
                                                                      realm:nil   // our service provider doesn't specify a realm
                                                          signatureProvider:nil]; // use the default method, HMAC-SHA1
    
    [request setHTTPMethod:@"POST"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(accessTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(accessTokenTicket:didFailWithError:)];
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    if (ticket.didSucceed) {
        NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
        NSLog(@"Access!: %@", accessToken);
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:accessToken];
        [[[Singleton sharedSingleton] sharedPrefs] setObject:data forKey:@"TelldusAccessToken"];
        [[[Singleton sharedSingleton] sharedPrefs] synchronize];
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"Accesstoken: %@", [NSKeyedUnarchiver unarchiveObjectWithData:[[[Singleton sharedSingleton] sharedPrefs] objectForKey:@"TelldusAccessToken"]]);
    }
    else {
        NSLog(@"No access");
    }
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSData *)data {
    NSLog(@"Error: %@", data);
}

- (void)apiTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    NSLog(@"Data: %@", responseBody);
}

- (void)apiTicket:(OAServiceTicket *)ticket didFailWithError:(NSData *)data {
    NSLog(@"Error: %@", data);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error : %@",error);
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self checkIfAuthenticated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
