//
//  UGMessageTableViewController.h
//  Uguru
//
//  Created by Cameron Ehrlich on 7/23/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RDRStickyKeyboardView.h>

@interface UGMessageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) RDRStickyKeyboardView *stickyKeyboardView;
@property (nonatomic, strong) Conversation *currentConversation;

@end
