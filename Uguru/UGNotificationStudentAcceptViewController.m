//
//  UGNotificationStudentAcceptViewController.m
//  Uguru
//
//  Created by Samir Makhani on 7/24/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGNotificationStudentAcceptViewController.h"

@interface UGNotificationStudentAcceptViewController ()

@end

@implementation UGNotificationStudentAcceptViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendAction:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObject:self.notification.server_id forKey:@"notif_id"];
    
    if (![[UGModel sharedInstance] user].customer_id) {
        [self performSegueWithIdentifier:@"studentAcceptToCreditCard" sender:self];
        return;
    } else{
        NSLog(@"%@", [[[UGModel sharedInstance] user] recipient_id]);
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[UGModel sharedInstance] studentAcceptTutor:params withSuccess:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^(id errorObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

@end
