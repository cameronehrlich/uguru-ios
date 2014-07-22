//
//  UGNotificationTableViewCell.h
//  Uguru
//
//  Created by Cameron Ehrlich on 7/21/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/UIKit+AFNetworking.h>

@interface UGNotificationTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *notificationImageView;
@property (strong, nonatomic) IBOutlet UILabel *notificationTitle;
@property (strong, nonatomic) IBOutlet UILabel *notificationDate;
@property (strong, nonatomic) IBOutlet UILabel *notificationStatus;


@end
