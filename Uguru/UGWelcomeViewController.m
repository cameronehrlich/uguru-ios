//
//  UGWelcomeViewController.m
//  Uguru
//
//  Created by Cameron Ehrlich on 7/17/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGWelcomeViewController.h"
#import <UIColor+Hex.h>

@implementation UGWelcomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"welcomeBackground"]]];
    [[self.signUpCell textLabel] setTextColor:[UIColor colorWithCSS:@"#29ADE3"]];
    [[self.loginCell textLabel] setTextColor:[UIColor colorWithCSS:@"#5FBB46"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{    
    switch (indexPath.row) {
        case 0:
            return;
        case 1:
            [self performSegueWithIdentifier:@"welcomeToSignUp" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"welcomeToLogin" sender:self];
            break;
        default:
            break;
    }
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return NO;
    }else{
        return YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
