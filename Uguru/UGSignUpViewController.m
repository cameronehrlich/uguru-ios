//
//  UGSignUpViewController.m
//  Uguru
//
//  Created by Cameron Ehrlich on 7/17/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGSignUpViewController.h"
#import <MBProgressHUD.h>

@implementation UGSignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setTitle:@"Sign Up"];
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

- (IBAction)signUpAction:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    User *newUser = [User new];
    newUser.name = self.name.text;
    newUser.email = self.email.text;
    newUser.password = self.password.text;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[UGModel sharedInstance] signUp:newUser success:^(id responseObject) {
        
        [self performSegueWithIdentifier:@"signUpToHome" sender:self];
        
    } fail:^(NSDictionary *errors) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:@"Oops"
                                    message:@"We were unable to sign you up for reasons that the server cannot yet describe."
                                   delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil] show];
    }];
}
@end
