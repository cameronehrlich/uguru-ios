//
//  UGInboxTableViewCell.h
//  Uguru
//
//  Created by Cameron Ehrlich on 7/23/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UGInboxTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *conversationImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastMessageLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@end
