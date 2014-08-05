//
//  UGProfileEditViewController.m
//  Uguru
//
//  Created by Samir Makhani on 8/3/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGProfileEditViewController.h"

@interface UGProfileEditViewController ()

@end

@implementation UGProfileEditViewController

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
    self.automaticallyAdjustsScrollViewInsets = NO;
    User *currentUser = [[UGModel sharedInstance] user];
    
    NSString *image_url = currentUser.image_url;
    
    if ([image_url rangeOfString:@"http"].location == NSNotFound) {
        [self.photo setImage:[UIImage imageNamed:@"notificationPlaceholder"]];
    }else{
        NSURL * imageURL = [NSURL URLWithString:image_url];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage * image = [UIImage imageWithData:imageData];
        [self.photo setImage:image];
    };
    
    self.name.text = currentUser.name;
    self.year.text = currentUser.year;
    self.major.text = currentUser.major;
    self.email.text = currentUser.email;
    
    if ([[[UGModel sharedInstance] user].is_a_tutor boolValue]== NO) {
        self.slc_tutor.hidden = YES;
        self.hkn_tutor.hidden = YES;
        self.res_tutor.hidden = YES;
        self.la_tutor.hidden = YES;
        self.ta_tutor.hidden = YES;
        self.la_tutor_label.hidden = YES;
        self.ta_tutor_label.hidden = YES;
        self.slc_tutor_label.hidden = YES;
        self.hkn_tutor_label.hidden = YES;
        self.res_tutor_label.hidden = YES;
        self.bio_label.hidden = YES;
        self.bio_text.hidden = YES;
        self.relevant_experience_label.hidden = YES;
        
    } else {
        self.bio_text.text = currentUser.bio;
        self.slc_tutor.on = [currentUser.slc_tutor boolValue];
        self.hkn_tutor.on = [currentUser.hkn_tutor boolValue];
        self.ta_tutor.on = [currentUser.ta_tutor boolValue];
        self.la_tutor.on = [currentUser.la_tutor boolValue];
        self.res_tutor.on = [currentUser.res_tutor boolValue];
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    if ([[[UGModel sharedInstance] user].is_a_tutor boolValue]== NO) {
        self.scrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen]bounds].size.height + 100);
    } else {
        self.scrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 1000);
    }
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

- (IBAction)slcTutorAction:(id)sender {
    [self sendSwitchActionToServer:sender
            sendSwitchNameToServer:@"slc_tutor"];
}

- (IBAction)taTutorAction:(id)sender {
    [self sendSwitchActionToServer:sender
            sendSwitchNameToServer:@"ta_tutor"];
}
- (IBAction)laTutorAction:(id)sender {
    [self sendSwitchActionToServer:sender
            sendSwitchNameToServer:@"la_tutor"];
}

- (IBAction)resTutorAction:(id)sender {
    [self sendSwitchActionToServer:sender
            sendSwitchNameToServer:@"res_tutor"];
}

- (IBAction)hknTutorAction:(id)sender {
    [self sendSwitchActionToServer:sender
            sendSwitchNameToServer:@"hkn_tutor"];
}

- (IBAction)sendAction:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:self.email.text forKey:@"email"];
    [params setObject:self.bio_text.text forKey:@"tutor_introduction"];
    [params setObject:self.major.text forKey:@"major"];
    [params setObject:self.year.text forKey:@"year"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[UGModel sharedInstance] updateUserWithAttr:[[UGModel sharedInstance] user]
                                          kvPair:params
                                         success:^(id responseObject) {
                                             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                             if ([[[UGModel sharedInstance] user].is_a_tutor boolValue]== YES) {
                                                    [self.navigationController popViewControllerAnimated:YES];
                                             } else {
                                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                             }
                                         } fail:^(id errorObject) {
                                                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                             [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please check your internset connection."
                                                                        delegate:nil
                                                               cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
                                         }];
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
                                             [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please check your internset connection."
                                                                        delegate:nil
                                                               cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
                                         }];
}
@end
