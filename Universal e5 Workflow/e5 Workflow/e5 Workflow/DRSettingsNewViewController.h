//
//  DTRSettingsNewViewController.h
//  e5
//
//  Created by Gunjan Patel on 28/02/13.
//  Copyright (c) 2013 Dataract Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRSettingsNewViewController : UIViewController<UITextFieldDelegate> {
    
}

@property (strong, nonatomic) IBOutlet UITextField *myTextTitle;
@property (strong, nonatomic) IBOutlet UITextField *myTextURL;
@property (strong, nonatomic) IBOutlet UITextField *myTextUser;
@property (strong, nonatomic) IBOutlet UITextField *myTextPassword;
@property (strong, nonatomic) IBOutlet UISlider *mySlider;
@property (strong, nonatomic) IBOutlet UILabel *mySliderLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *mySegmentedControl;
@property (strong, nonatomic) IBOutlet UIButton *mySaveButton;
@property (strong, nonatomic) IBOutlet UIButton *myCancelButton;

- (IBAction)mySegmentedControl_ValueCahnged:(id)sender;
- (IBAction)mySaveButton_TouchDown:(id)sender;
- (IBAction)myCancelButton_TouchDown:(id)sender;
- (IBAction)mySlider_ValueChanged:(id)sender;
- (IBAction)myTextFields_EditingDidBegin:(id)sender;
- (IBAction)myTextFields_EditingDidEnd:(id)sender;
- (IBAction)myTextFields_TouchUpOutSide:(id)sender;
- (IBAction)myTextFields_DidEndOrExit:(id)sender;

@end
