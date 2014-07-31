//
//  UGEnterCreditCardInfoViewController.m
//  Uguru
//
//  Created by Samir Makhani on 7/29/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGEnterCreditCardInfoViewController.h"

@interface UGEnterCreditCardInfoViewController ()

@end

@implementation UGEnterCreditCardInfoViewController

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
    self.stripeView = [[STPView alloc] initWithFrame:CGRectMake(15, 20, 290, 55) andKey:@"pk_test_OHHalLRCnwixc5YXc9O29h3j"];
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
    [[UGModel sharedInstance] user].recipient_id = @"asda9d9j9adja";
    [self.navigationController popViewControllerAnimated:YES];
}
@end
