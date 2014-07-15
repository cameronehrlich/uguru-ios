//
//  UGMasterViewController.h
//  Uguru
//
//  Created by Cameron Ehrlich on 7/15/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UGDetailViewController;

@interface UGMasterViewController : UITableViewController

@property (strong, nonatomic) UGDetailViewController *detailViewController;

@end
