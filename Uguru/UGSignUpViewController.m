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
    
    User *newUser = [[User alloc] init];
    newUser.name = self.name.text;
    newUser.email = self.email.text;
    newUser.phone_number = self.phoneNumber.text;
    newUser.password = self.password.text;

    [[[UGModel sharedInstance] requestManager] POST:@"sign_up" parameters:[newUser toDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *authenticationToken = [[responseObject objectForKey:@"user"] objectForKey:@"auth_token"];
        
        // setting the token returned into the manager's serializer's headers for all future requests!
        [[[[UGModel sharedInstance] requestManager] requestSerializer] setValue:authenticationToken forHTTPHeaderField:@"X-UGURU-Token"];
    
        NSString *descrip = [responseObject description];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [[[UIAlertView alloc] initWithTitle:@"Success" message:descrip delegate:nil cancelButtonTitle:@"Cool" otherButtonTitles:nil] show];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:error.debugDescription delegate:nil cancelButtonTitle:@"Cool" otherButtonTitles:nil] show];
    }];
}
@end
