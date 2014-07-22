//
//  UGLoginViewController.h
//  Uguru
//
//  Created by Cameron Ehrlich on 7/17/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UGLoginViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;

- (IBAction)loginAction:(id)sender;

@end
