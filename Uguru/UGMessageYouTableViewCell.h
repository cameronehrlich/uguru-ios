//
//  UGMessageYouTableViewCell.h
//  Uguru
//
//  Created by Cameron Ehrlich on 7/23/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UGMessageYouTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *messageImageView;
@property (strong, nonatomic) IBOutlet UITextView *messageContentView;
@property (strong, nonatomic) IBOutlet UILabel *messageDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageNameLabel;

@end
