//
//  UGProfileEditViewController.h
//  Uguru
//
//  Created by Samir Makhani on 8/3/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UGProfileEditViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *year;
@property (strong, nonatomic) IBOutlet UITextField *major;
@property (strong, nonatomic) IBOutlet UITextView *bio_text;
@property (strong, nonatomic) IBOutlet UISwitch *slc_tutor;

@property (strong, nonatomic) IBOutlet UISwitch *ta_tutor;
@property (strong, nonatomic) IBOutlet UISwitch *la_tutor;
@property (strong, nonatomic) IBOutlet UISwitch *res_tutor;
@property (strong, nonatomic) IBOutlet UISwitch *hkn_tutor;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *relevant_experience_label;
@property (strong, nonatomic) IBOutlet UILabel *slc_tutor_label;
@property (strong, nonatomic) IBOutlet UILabel *ta_tutor_label;
@property (strong, nonatomic) IBOutlet UILabel *la_tutor_label;
@property (strong, nonatomic) IBOutlet UILabel *res_tutor_label;
@property (strong, nonatomic) IBOutlet UILabel *hkn_tutor_label;
@property (strong, nonatomic) IBOutlet UILabel *bio_label;


- (IBAction)slcTutorAction:(id)sender;
- (IBAction)taTutorAction:(id)sender;
- (IBAction)laTutorAction:(id)sender;
- (IBAction)resTutorAction:(id)sender;
- (IBAction)hknTutorAction:(id)sender;
- (IBAction)sendAction:(id)sender;

@end
