//
//  UGSettingsViewController.h
//  Uguru
//
//  Created by Samir Makhani on 8/2/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UGSettingsViewController : UIViewController
- (IBAction)savePasswordAction:(id)sender;
- (IBAction)emailNotificationSwitch:(id)sender;
- (IBAction)pushNotificationSwitch:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *email_notification;
@property (strong, nonatomic) IBOutlet UISwitch *push_notification;
@property (strong, nonatomic) IBOutlet UITextField *old_password;
@property (strong, nonatomic) IBOutlet UITextField *reset_password;


@end
