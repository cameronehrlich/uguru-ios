//
//  UGHomeViewController.h
//  Uguru
//
//  Created by Cameron Ehrlich on 7/21/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RNFrostedSidebar.h>

@interface UGHomeViewController : UITableViewController <RNFrostedSidebarDelegate>

@property (nonatomic, strong) RNFrostedSidebar *sidebar;

@end
