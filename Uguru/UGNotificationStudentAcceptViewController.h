//
//  UGNotificationStudentAcceptViewController.h
//  Uguru
//
//  Created by Samir Makhani on 7/24/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UGNotificationStudentAcceptViewController : UITableViewController

- (IBAction)sendAction:(id)sender;

@property (nonatomic, strong) Notification *notification;

@end
