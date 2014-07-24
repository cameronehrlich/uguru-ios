//
//  UGMessageTableViewController.h
//  Uguru
//
//  Created by Cameron Ehrlich on 7/23/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RDRStickyKeyboardView.h>

@interface UGMessageTableViewController : UITableViewController

@property (nonatomic, strong) Conversation *currentConversation;
@property (nonatomic, strong) RDRStickyKeyboardView *stickeyKeyboardView;

@end
