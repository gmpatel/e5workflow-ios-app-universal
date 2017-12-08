//
//  DTRFirstViewController.h
//  e5
//
//  Created by Gunjan Patel on 26/02/13.
//  Copyright (c) 2013 Dataract Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "DejalBezelActivityView.h"
//#import "DejalActivityView.h"

@interface DRFirstViewController : UIViewController<NSURLConnectionDelegate, UIWebViewDelegate> {
    BOOL _authed;
    NSString *_Title;
    NSString *_URL;
    NSString *_User;
    NSString *_Password;
    NSInteger _RefreshInterval;
}

@property (strong, nonatomic) IBOutlet UINavigationBar *myNavigationBar;

@property (strong, nonatomic) IBOutlet UINavigationItem *myNavigationTitle;

@property (strong, nonatomic) IBOutlet UIWebView *myWebView;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *myRefresh;

- (void) checkNetworkStatus:(NSNotification *)notice;

- (IBAction)myRefreshClicked:(id)sender;

- (void)loadURL;

- (void)loadSettings;

- (BOOL)connected;

@end
