//
//  DTRViewController.h
//  WebViewTest
//
//  Created by Gunjan Patel on 28/02/13.
//  Copyright (c) 2013 Dataract Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTRViewController : UIViewController<NSURLConnectionDelegate,UIWebViewDelegate>{
    BOOL _authed;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *myRefreshButton;
@property (strong, nonatomic) IBOutlet UIWebView *myWebView;


- (IBAction)myRefreshButton_Clicked:(id)sender;

- (void)LoadUrl;

@end
