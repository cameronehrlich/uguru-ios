//
//  UGAccountViewController.m
//  Uguru
//
//  Created by Samir Makhani on 8/2/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGAccountViewController.h"
#import "PaymentViewController.h"

@interface UGAccountViewController ()

@end

@implementation UGAccountViewController

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
    [self.change_recipient_action_text setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.change_credit_action_text setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.cash_out_action_text setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    User *currentUser = [[UGModel sharedInstance] user];
    self.balance.text = [NSString stringWithFormat:@"%@", currentUser.balance];
    if ([[UGModel sharedInstance] user].total_earned == nil) {
        self.total_earned.text = @"$0";
    } else {
        self.total_earned.text = [NSString stringWithFormat:@"%@", currentUser.total_earned];
    }
    if ([[UGModel sharedInstance] user].customer_id) {
        [self.change_credit_action_text setTitle:@"Change" forState:UIControlStateNormal];
        self.credit_last4.text = currentUser.customer_last4;
        self.credit_last4.hidden = NO;
        self.credit_last4_label.hidden = NO;
    } else {
        [self.change_credit_action_text setTitle:@"Add" forState:UIControlStateNormal];
        self.credit_last4.hidden = YES;
        self.credit_last4_label.hidden = YES;
    }
    if ([[UGModel sharedInstance] user].recipient_id) {
        [self.change_recipient_action_text setTitle:@"Change" forState:UIControlStateNormal];
        self.recipient_last4.hidden = NO;
        self.recipient_last4_label.hidden = NO;
    } else {
        [self.change_recipient_action_text setTitle:@"Add" forState:UIControlStateNormal];
        self.recipient_last4.hidden = YES;
        self.recipient_last4_label.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"accountToEditRecipient"]) {
        PaymentViewController *dst = [segue destinationViewController];
        [dst setCardType:@"recipient"];
    } else if ([segue.identifier isEqualToString:@"accountToEditCard"]) {
        PaymentViewController *dst = [segue destinationViewController];
        [dst setCardType:@"customer"];
    }
}


- (IBAction)cashOutAction:(id)sender {
    
    if (![[UGModel sharedInstance] user].recipient_id) {
        [self performSegueWithIdentifier:@"accountToEditRecipient" sender:self];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Cashing out $%@", self.balance.text]
                                                    message:@"Press OK to cash out" delegate:self cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    
    [alert show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setObject:self.balance.text forKey:@"cashed_out"];
        [[UGModel sharedInstance] updateUserWithAttr:[[UGModel sharedInstance] user]
                                              kvPair:params
                                             success:^(id responseObject) {
                                                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                 [[[UIAlertView alloc] initWithTitle:@"Success!"
                                                                             message:[NSString stringWithFormat:@"You have cashed out $%@. The funds should appear in your account from 1-3 days.", self.balance.text]
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
    
    
    
}

- (IBAction)changeRecipientAction:(id)sender {
    [self performSegueWithIdentifier:@"accountToEditRecipient" sender:self];
}

- (IBAction)changeCreditAction:(id)sender {
    [self performSegueWithIdentifier:@"accountToEditCard" sender:self];
}
@end
