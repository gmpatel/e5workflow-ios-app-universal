//
//  DTRSettingsNewViewController.m
//  e5
//
//  Created by Gunjan Patel on 28/02/13.
//  Copyright (c) 2013 Dataract Pty Ltd. All rights reserved.
//

#import "DRSettingsNewViewController.h"

@interface DRSettingsNewViewController ()
@end

@implementation DRSettingsNewViewController

@synthesize myCancelButton;
@synthesize mySaveButton;

@synthesize myTextTitle;
@synthesize myTextURL;
@synthesize myTextUser;
@synthesize myTextPassword;
@synthesize mySlider;
@synthesize mySliderLabel;
@synthesize mySegmentedControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    myTextTitle.delegate=self;
    myTextURL.delegate=self;
    myTextUser.delegate=self;
    myTextPassword.delegate=self;
    
    [self.view addGestureRecognizer:tap];
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadSettings];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [myTextTitle resignFirstResponder];
    [myTextURL resignFirstResponder];
    [myTextUser resignFirstResponder];
    [myTextPassword resignFirstResponder];
}

- (IBAction)mySegmentedControl_ValueCahnged:(id)sender {
    NSLog(@"mySegmentedControl Value = %d", mySegmentedControl.selectedSegmentIndex);
}

- (IBAction)mySaveButton_TouchDown:(id)sender {
    [self saveSettings];
    [self dismissViewControllerAnimated:YES completion:nil]; //[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)myCancelButton_TouchDown:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil]; //[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)myTextFields_EditingDidBegin:(id)sender {
    //UITextField *field = (UITextField *) sender;
    //[self animateTextField:field up:YES];
}

- (IBAction)myTextFields_EditingDidEnd:(id)sender {
    UITextField *field = (UITextField *) sender;
    
    if(field.tag == 2 && field.text.length > 0) // URL
    {
        if ([field.text rangeOfString:@"://"].location == NSNotFound) {
            field.text = [NSString stringWithFormat: @"http://%@", field.text];
        }
    }
    
    //[self animateTextField:field up:NO];
}

- (IBAction)myTextFields_TouchUpOutSide:(id)sender {
    //UITextField *field = (UITextField *) sender;
    //[sender resignFirstResponder];
}

- (IBAction)myTextFields_DidEndOrExit:(id)sender {
    [sender resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [myTextTitle resignFirstResponder];
    [myTextURL resignFirstResponder];
    [myTextUser resignFirstResponder];
    [myTextPassword resignFirstResponder];
    return YES;
}

- (IBAction)mySlider_ValueChanged:(id)sender {
    UISlider *slider = (UISlider *) sender;
    
    NSNumber *myNumber = [NSNumber numberWithDouble:(slider.value + 0.5)];
    NSInteger value = [myNumber intValue];
    if(value < mySlider.minimumValue) value = mySlider.minimumValue;
    if(value > mySlider.maximumValue) value = mySlider.maximumValue;
    
    if(value == 0){
        self.mySliderLabel.text = @"Disabled";
    }
    else if(value == 60){
        self.mySliderLabel.text = @"1 Minute";
    }
    else{
        self.mySliderLabel.text = [NSString stringWithFormat: @"%d Seconds", value];
    }
}

- (void)loadSettings {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSInteger currentTab = [defaults integerForKey:@"CurrentTab"];
    
    [defaults setInteger:1 forKey:@"SettingsVisible"];
    
    NSString *data;
    NSInteger value;
    
    NSString *keyTitle = [NSString stringWithFormat: @"Tab%dTitle", currentTab];
    NSString *keyURL = [NSString stringWithFormat: @"Tab%dURL", currentTab];
    NSString *keyUser = [NSString stringWithFormat: @"Tab%dUser", currentTab];
    NSString *keyPassword = [NSString stringWithFormat: @"Tab%dPassword", currentTab];
    NSString *keyRefreshInterval = [NSString stringWithFormat: @"Tab%dRefreshInterval", currentTab];
    NSString *keyLoadingStyle = [NSString stringWithFormat: @"Tab%dLoadingStyle", currentTab];
    
    data = [defaults objectForKey:keyTitle];
    self.myTextTitle.text = data;
    
    data = [defaults objectForKey:keyURL];
    self.myTextURL.text = data;
    
    data = [defaults objectForKey:keyUser];
    self.myTextUser.text = data;
    
    data = [defaults objectForKey:keyPassword];
    self.myTextPassword.text = data;
    
    value = [defaults integerForKey:keyRefreshInterval];
    self.mySlider.value = value;
    
    value = [defaults integerForKey:keyLoadingStyle];
    self.mySegmentedControl.selectedSegmentIndex = value;
    
    if(value == 0){
        self.mySliderLabel.text = @"Disabled";
    }
    else if(value == 60){
        self.mySliderLabel.text = @"1 Minute";
    }
    else{
        self.mySliderLabel.text = [NSString stringWithFormat: @"%d Seconds", value];
    }
}

- (void)saveSettings {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSInteger currentTab = [defaults integerForKey:@"CurrentTab"];
    
    NSString *data;
    NSInteger value;
    
    NSString *keyTitle = [NSString stringWithFormat: @"Tab%dTitle", currentTab];
    NSString *keyURL = [NSString stringWithFormat: @"Tab%dURL", currentTab];
    NSString *keyUser = [NSString stringWithFormat: @"Tab%dUser", currentTab];
    NSString *keyPassword = [NSString stringWithFormat: @"Tab%dPassword", currentTab];
    NSString *keyRefreshInterval = [NSString stringWithFormat: @"Tab%dRefreshInterval", currentTab];
    NSString *keyLoadingStyle = [NSString stringWithFormat: @"Tab%dLoadingStyle", currentTab];
    
    data = self.myTextTitle.text;
    [defaults setObject:data forKey:keyTitle];
    
    data = self.myTextURL.text;
    [defaults setObject:data forKey:keyURL];
    
    data = self.myTextUser.text;
    [defaults setObject:data forKey:keyUser];
    
    data = self.myTextPassword.text;
    [defaults setObject:data forKey:keyPassword];
    
    
    NSNumber *myNumber = [NSNumber numberWithDouble:(self.mySlider.value + 0.5)];
    value = [myNumber intValue];
    if(value < mySlider.minimumValue) value = mySlider.minimumValue;
    if(value > mySlider.maximumValue) value = mySlider.maximumValue;
    if(value > mySlider.minimumValue && value < 10) value = 10;
    
    [defaults setInteger:value forKey:keyRefreshInterval];
    
    value = mySegmentedControl.selectedSegmentIndex;
    [defaults setInteger:value forKey:keyLoadingStyle];
}

@end
