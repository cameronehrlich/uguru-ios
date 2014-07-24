//
//  UGRequestViewController.h
//  Uguru
//
//  Created by Cameron Ehrlich on 7/23/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UGRequestViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITextField *classField;
@property (strong, nonatomic) IBOutlet UITextField *professorField;
@property (strong, nonatomic) IBOutlet UITextView *helpField;
@property (strong, nonatomic) IBOutlet UITextField *locationField;
@property (strong, nonatomic) IBOutlet UISlider *sessionLengthSlider;
@property (strong, nonatomic) IBOutlet UILabel *sessionLengthLabel;
@property (strong, nonatomic) IBOutlet UISwitch *asapSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *sameGuruSwitch;
@property (strong, nonatomic) IBOutlet UISlider *offeringPriceSlider;
@property (strong, nonatomic) IBOutlet UILabel *offeringPriceLabel;


- (IBAction)sendAction:(id)sender;
- (IBAction)sessionLengthSliderAction:(id)sender;
- (IBAction)offeringPriceSliderAction:(id)sender;


@end
