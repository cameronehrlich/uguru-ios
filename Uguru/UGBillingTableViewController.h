//
//  UGBillingTableViewController.h
//  Uguru
//
//  Created by Samir Makhani on 7/31/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UGBillingTableViewController : UITableViewController

@property (nonatomic, strong) NSDictionary *billingDetails;
@property (strong, nonatomic) IBOutlet UILabel *billingStudentName;
@property (strong, nonatomic) IBOutlet UILabel *billingNumHours;
@property (strong, nonatomic) IBOutlet UILabel *billingHourlyRate;
@property (strong, nonatomic) IBOutlet UILabel *billingTotalAmount;
@property (strong, nonatomic) IBOutlet UISlider *billingNumHoursSlider;
@property (strong, nonatomic) IBOutlet UISlider *billingHourlyRateSlider;

- (IBAction)billingNumHoursSliderAction:(id)sender;
- (IBAction)billingHourlyRateSliderAction:(id)sender;
- (IBAction)sendAction:(id)sender;

@end
