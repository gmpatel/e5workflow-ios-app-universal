//
//  DTRViewController.m
//  WebViewTest
//
//  Created by Gunjan Patel on 28/02/13.
//  Copyright (c) 2013 Dataract Pty Ltd. All rights reserved.
//

#import "DTRViewController.h"

@interface DTRViewController ()

@end

@implementation DTRViewController

@synthesize myRefreshButton;
@synthesize myWebView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)myRefreshButton_Clicked:(id)sender {
    [self LoadUrl];
}

- (void)LoadUrl {
    NSURL *url = [NSURL URLWithString:@"http://v3demo.dataract.com.au/sites/pensions/e5%20pages/productivity.aspx"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.myWebView loadRequest:request];
}

- (void)LoadUrlWithAuthenticationChallenge {
    NSURL *url = [NSURL URLWithString:@"http://v3demo.dataract.com.au/sites/pensions/e5%20pages/productivity.aspx"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.myWebView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSLog(@"Did start loading: %@ auth:%d", [[request URL] absoluteString], _authed);
    
    if (!_authed) {
        _authed = NO;
        /* pretty sure i'm leaking here, leave me alone... i just happen to leak sometimes */
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
        return NO;
    }
    
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
{
    if ([challenge previousFailureCount] == 0) {
        NSLog(@"got auth challange");
        _authed = YES;
        /* SET YOUR credentials, i'm just hard coding them in, tweak as necessary */
        [[challenge sender] useCredential:[NSURLCredential credentialWithUser:@"dataract2\\gunjan" password:@"gmcm7880" persistence:NSURLCredentialPersistencePermanent] forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    NSLog(@"received response via nsurlconnection");
    
    /** THIS IS WHERE YOU SET MAKE THE NEW REQUEST TO UIWebView, which will use the new saved auth info **/
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://intranet.dataract.com.au"]];
    
    [self.myWebView loadRequest:urlRequest];
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection;
{
    return NO;
}

@end
