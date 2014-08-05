//
//  UGProfileViewController.h
//  Uguru
//
//  Created by Samir Makhani on 8/2/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UGProfileViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *year;
//@property (strong, nonatomic) IBOutlet UILabel *num_ratings;
@property (strong, nonatomic) IBOutlet UILabel *major;
@property (strong, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) IBOutlet UILabel *bio_header_text;
@property (strong, nonatomic) IBOutlet UITextView *bio_text;
@property (strong, nonatomic) IBOutlet UILabel *num_ratings;
- (IBAction)editProfileAction:(id)sender;


@end
