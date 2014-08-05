//
//  UGAccountViewController.h
//  Uguru
//
//  Created by Samir Makhani on 8/2/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UGAccountViewController : UIViewController <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *balance;
@property (strong, nonatomic) IBOutlet UILabel *total_earned;
@property (strong, nonatomic) IBOutlet UILabel *credit_last4;
@property (strong, nonatomic) IBOutlet UILabel *credit_last4_label;
@property (strong, nonatomic) IBOutlet UILabel *recipient_last4;
@property (strong, nonatomic) IBOutlet UILabel *recipient_last4_label;
- (IBAction)cashOutAction:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *change_credit_action_text;
@property (strong, nonatomic) IBOutlet UIButton *change_recipient_action_text;
@property (strong, nonatomic) IBOutlet UIButton *cash_out_action_text;

- (IBAction)changeRecipientAction:(id)sender;
- (IBAction)changeCreditAction:(id)sender;


@end
