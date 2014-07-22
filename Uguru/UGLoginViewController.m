//
//  UGLoginViewController.m
//  Uguru
//
//  Created by Cameron Ehrlich on 7/17/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGLoginViewController.h"

@implementation UGLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setTitle:@"Login"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"signInLoginBackground"]]];
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender
{
    User *newUser = [User new];
    newUser.email = self.email.text;
    newUser.password = self.password.text;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[UGModel sharedInstance] login:newUser success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self performSegueWithIdentifier:@"loginToHome" sender:self];
    } fail:^(NSDictionary *errors) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:@"Oops"
                                    message:@"We were unable to log you in for reasons that the server cannot yet describe."
                                   delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil] show];
    }];
}

@end
