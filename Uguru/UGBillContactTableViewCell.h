//
//  UGBillContactTableViewCell.h
//  Uguru
//
//  Created by Samir Makhani on 7/31/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UGBillContactTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *messageImageView;
@property (strong, nonatomic) IBOutlet UILabel *messageCourseLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageNameLabel;

@end
