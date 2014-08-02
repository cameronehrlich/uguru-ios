//
//  UGRatingsViewController.h
//  Uguru
//
//  Created by Samir Makhani on 8/1/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMRatingControl.h"

@interface UGRatingsViewController : UIViewController

@property (nonatomic, strong) NSDictionary *ratings_info;
@property (strong, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UITextField *additionalDetails;
@property (strong, nonatomic) AMRatingControl *colorRatingControl;

- (IBAction)submitRating:(id)sender;

@end
