//
//  UGNotificationViewController.m
//  Uguru
//
//  Created by Cameron Ehrlich on 7/22/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGNotificationViewController.h"

@implementation UGNotificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.blahField setText:self.notification.description];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
