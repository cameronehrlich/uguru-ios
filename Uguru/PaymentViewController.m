//
//  PaymentViewController.m
//  Uguru
//
//  Created by Samir Makhani on 7/30/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "PaymentViewController.h"

@interface PaymentViewController ()

@end

@implementation PaymentViewController

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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.stripeView = [[STPView alloc] initWithFrame:CGRectMake(15,20,290,55) andKey:@"pk_test_OHHalLRCnwixc5YXc9O29h3j"];
    self.stripeView.delegate = self;
    [self.view addSubview:self.stripeView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)stripeView:(STPView *)view withCard:(PKCard *)card isValid:(BOOL)valid
{
    NSLog(@"sup");
    // Toggle navigation, for example
    // self.saveButton.enabled = valid;
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

- (IBAction)submitCreditCard:(id)sender {
        // Call 'createToken' when the save button is tapped
        [self.stripeView createToken:^(STPToken *token, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:@"Oops!"
                                            message:error.localizedDescription
                                           delegate:nil
                                  cancelButtonTitle:@"Try Again" otherButtonTitles:nil] show];
            } else {
                // Send off token to your server
                
                NSDictionary *params = nil;
                
                if ([self.cardType isEqualToString:@"recipient"]) {
                    params = @{@"stripe_recipient_token": token.tokenId};
                } else {
                    params = @{@"stripe-card-token": token.tokenId};
                }
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [[UGModel sharedInstance] updateUserWithAttr:[[UGModel sharedInstance] user]
                    kvPair:params
                    success:^(id responseObject) {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        User *currentUser = [[UGModel sharedInstance] user];
                        currentUser.customer_id = [responseObject customer_id];
                        currentUser.customer_last4 = [responseObject customer_last4];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    } fail:^(id errorObject) {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:[(NSArray *)errorObject componentsJoinedByString:@", "]
                                                   delegate:nil
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil] show];
                    }];
            }
        }];
}
@end
