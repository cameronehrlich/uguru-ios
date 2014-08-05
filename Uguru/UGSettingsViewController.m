//
//  UGSettingsViewController.m
//  Uguru
//
//  Created by Samir Makhani on 8/2/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGSettingsViewController.h"

@interface UGSettingsViewController ()

@end

@implementation UGSettingsViewController

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
    User *currentUser = [[UGModel sharedInstance] user];
    self.email_notification.on = [currentUser.email_notification boolValue];
    self.push_notification.on = [currentUser.push_notification boolValue];
    self.old_password.secureTextEntry = YES;
    self.reset_password.secureTextEntry = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)savePasswordAction:(id)sender {
    if (self.old_password.text && self.old_password.text.length > 0 && self.reset_password.text
        && self.reset_password.text.length > 0)
    {
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setObject:self.old_password.text forKey:@"password"];
        [params setObject:self.reset_password.text forKey:@"new_password"];
        [[UGModel sharedInstance] updateUserWithAttr:[[UGModel sharedInstance] user]
                                              kvPair:params
                                             success:^(id responseObject) {
                                                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                 [[[UIAlertView alloc] initWithTitle:@"Success!"
                                                                             message:@"Password has been changed"
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"Okay"
                                                                   otherButtonTitles:nil] show];
                                                 [self.navigationController popViewControllerAnimated:YES];
                                             } fail:^(id errorObject) {
                                                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                 [[[UIAlertView alloc] initWithTitle:@"Oops!" message:[(NSArray *)errorObject componentsJoinedByString:@", "]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"Okay"
                                                                   otherButtonTitles:nil] show];
                                             }];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please feel in both fields."
                                   delegate:nil
                          cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
    }
}

- (IBAction)emailNotificationSwitch:(id)sender {
    [self sendSwitchActionToServer:sender
            sendSwitchNameToServer:@"email_notification"];
}

- (IBAction)pushNotificationSwitch:(id)sender {
    [self sendSwitchActionToServer:sender
            sendSwitchNameToServer:@"push_notification"];
}


- (void) sendSwitchActionToServer:(id)sender sendSwitchNameToServer:(NSString*)switch_name {
    int is_switch_on = (int) [sender isOn];
    BOOL result = false;
    if (is_switch_on) {
        result = true;
    }
    [[UGModel sharedInstance] updateUserWithAttr:[[UGModel sharedInstance] user]
                                          kvPair:@{switch_name:[NSNumber numberWithBool:result]}
                                         success:^(id responseObject) {
                                             //
                                             
                                         } fail:^(id errorObject) {
                                             [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please check your internet connection."
                                                                        delegate:nil
                                                               cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
                                         }];
}

@end
