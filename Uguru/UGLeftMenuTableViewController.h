//
//  UGLeftMenuTableViewController.h
//  Uguru
//
//  Created by Samir Makhani on 8/5/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UGLeftMenuTableViewController : UITableViewController
- (IBAction)goToProfile:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) IBOutlet UITableViewCell *billStudentCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *becomeAGuruCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *faqCell;

@end
