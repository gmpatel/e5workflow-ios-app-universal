//
//  DTRThirdViewController.m
//  e5
//
//  Created by Gunjan Patel on 26/02/13.
//  Copyright (c) 2013 Dataract Pty Ltd. All rights reserved.
//

#import "DRThirdViewController.h"

@interface DRThirdViewController ()

@end

@implementation DRThirdViewController

@synthesize myRefresh;
@synthesize myNavigationBar;
@synthesize myWebView;
@synthesize myNavigationTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [DejalBezelActivityView activityViewForView:self.view];
    //[DejalActivityView activityViewForView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [DejalBezelActivityView removeViewAnimated:YES];
    //[DejalActivityView removeView];
}

-(void)autoRefresh{
    NSInteger currentTab = [[NSUserDefaults standardUserDefaults] integerForKey:@"CurrentTab"];
    NSInteger settingsVisible = [[NSUserDefaults standardUserDefaults] integerForKey:@"SettingsVisible"];
    
    if(currentTab == 3 && settingsVisible == 0){
        NSLog(@"#*#*#*#*#*#* Screen 3 : Auto Refreshing UIWebView #*#*#*#*##*#*");
        [self loadURL];
    }
}

- (BOOL)connected
{
    return TRUE;
}

- (void)viewWillAppear:(BOOL)animated {
    myWebView.delegate = self;
    
    [self loadSettings];
    [self loadURL];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)myRefreshClicked:(id)sender {
    [self loadURL];
}

- (void)loadSettings {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:3 forKey:@"CurrentTab"];
    [defaults setInteger:0 forKey:@"SettingsVisible"];
    
    
    _Title = [defaults objectForKey:@"Tab3Title"];
    _URL = [defaults objectForKey:@"Tab3URL"];
    _User = [defaults objectForKey:@"Tab3User"];
    _Password = [defaults objectForKey:@"Tab3Password"];
    _RefreshInterval = [defaults integerForKey:@"Tab3RefreshInterval"];
    
    if(_Title.length == 0) {
        self.myNavigationTitle.title = @"Scene 3";
    }
    else {
        self.myNavigationTitle.title = _Title;
    }
    
    NSLog(@"Title: %@, URL: %@, User: %@, Pass: %@", _Title, _URL, _User, _Password);
}

- (BOOL) isConnectionAvailable
{
	SCNetworkReachabilityFlags flags;
    BOOL receivedFlags;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(CFAllocatorGetDefault(), [@"dipinkrishna.com" UTF8String]);
    receivedFlags = SCNetworkReachabilityGetFlags(reachability, &flags);
    CFRelease(reachability);
    
    if (!receivedFlags || (flags == 0) )
    {
        return FALSE;
    } else {
		return TRUE;
	}
}

- (void)loadURL {
    if([self isConnectionAvailable]) {
        if(_URL.length > 0) {
            if(_User.length > 0 && _Password.length > 0)
                _authed = NO;
            else
                _authed = YES;
            
            [self.myWebView stopLoading];
            [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_URL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0]];
            
            if(_RefreshInterval > 0)
                [NSTimer scheduledTimerWithTimeInterval:_RefreshInterval target:self selector:@selector(autoRefresh) userInfo:nil repeats:FALSE];
        } else {
            [self.myWebView stopLoading];
            [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
        }
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No Internet !!" message:@"Please check your internet connection" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    if (!_authed) {
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
        NSLog(@"Did start loading: %@ auth:%d", [[request URL] absoluteString], _authed);
        return NO;
    }
    else {
        NSLog(@"Did start loading: %@ auth:%d", [[request URL] absoluteString], _authed);
        return YES;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
{
    NSLog(@"Got Auth Challange, Fail Count : %d", [challenge previousFailureCount]);
    
    if ([challenge previousFailureCount] == 0) {
        _authed = YES;
        [[challenge sender] useCredential:[NSURLCredential credentialWithUser:_User password:_Password persistence:NSURLCredentialPersistenceNone] forAuthenticationChallenge:challenge];
    } else {
        _authed = YES;
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        
        NSURL *url = [NSURL URLWithString:@"about:blank"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.myWebView loadRequest:request];
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Login Failed !!" message:@"Please check your credentials" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    NSLog(@"received response via nsurlconnection");
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_URL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0]];
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection;
{
    return NO;
}

@end


/*
 
 - (void)loadURL {
 if(_URL.length > 0)
 {
 if(_User.length > 0 && _Password.length > 0)
 _authed = NO;
 else
 _authed = YES;
 
 [self.myWebView stopLoading];
 [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_URL]]];
 
 if(_RefreshInterval > 0)
 [NSTimer scheduledTimerWithTimeInterval:_RefreshInterval target:self selector:@selector(autoRefresh) userInfo:nil repeats:FALSE];
 }
 else{
 [self.myWebView stopLoading];
 [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
 }
 }
 
 - (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
 {
 if (!_authed) {
 [[NSURLConnection alloc] initWithRequest:request delegate:self];
 NSLog(@"Did start loading: %@ auth:%d", [[request URL] absoluteString], _authed);
 return NO;
 }
 else {
 NSLog(@"Did start loading: %@ auth:%d", [[request URL] absoluteString], _authed);
 return YES;
 }
 }
 
 - (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
 {
 NSLog(@"Got Auth Challange, Fail Count : %d", [challenge previousFailureCount]);
 
 if ([challenge previousFailureCount] == 0) {
 _authed = YES;
 [[challenge sender] useCredential:[NSURLCredential credentialWithUser:_User password:_Password persistence:NSURLCredentialPersistencePermanent] forAuthenticationChallenge:challenge];
 } else {
 _authed = YES;
 [[challenge sender] cancelAuthenticationChallenge:challenge];
 
 NSURL *url = [NSURL URLWithString:@"about:blank"];
 NSURLRequest *request = [NSURLRequest requestWithURL:url];
 [self.myWebView loadRequest:request];
 
 UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Login Failed !!" message:@"Please check your credentials." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
 [alert show];
 }
 }
 
 - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
 {
 NSLog(@"received response via nsurlconnection");
 [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_URL]]];
 }
 
 - (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection;
 {
 return NO;
 }
 
*/
