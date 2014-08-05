//
//  UGBillingTableViewController.m
//  Uguru
//
//  Created by Samir Makhani on 7/31/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGBillingTableViewController.h"
#import "UGModel.h"

@interface UGBillingTableViewController ()

@end

@implementation UGBillingTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSNumber *time_estimate = [self.billingDetails objectForKey:@"time-estimate"];
    NSNumber *hourly_estimate = [self.billingDetails objectForKey:@"hourly-rate"];
    UIColor *green_text_color = UIColorFromRGB(6404685);
    
    self.billingStudentName.text = [self.billingDetails objectForKey:@"student-name"];
    self.billingNumHours.text = [NSString stringWithFormat: @"%@hr", time_estimate];
    self.billingHourlyRate.text = [NSString stringWithFormat: @"%@/hr", hourly_estimate];
    self.billingTotalAmount.text = [NSString stringWithFormat: @"$%i", ([hourly_estimate intValue] * [time_estimate intValue])];
    
    self.billingStudentName.textColor = green_text_color;
    self.billingNumHours.textColor = green_text_color;
    self.billingHourlyRate.textColor = green_text_color;
    self.billingTotalAmount.textColor = green_text_color;
    
    self.billingHourlyRateSlider.continuous = NO;
    self.billingNumHoursSlider.continuous = NO;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendAction:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    NSNumber *billingHourlyRateVal = [NSNumber numberWithFloat:self.billingHourlyRateSlider.value];
    NSNumber *billingNumHoursVal = [NSNumber numberWithFloat:self.billingNumHoursSlider.value];
    NSNumber *request_id =  [self.billingDetails objectForKey:@"request-id"];
    
    [params setObject:@([billingNumHoursVal intValue]) forKey:@"time_estimate"];
    [params setObject:@([billingHourlyRateVal intValue]) forKey:@"hourly_amount"];
    [params setObject:@([request_id intValue]) forKey:@"request_id"];
    
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[UGModel sharedInstance] billStudentWithSuccess:params withSuccess:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[UGModel sharedInstance] user].pending_ratings =  [[responseObject objectForKey:@"bill_student"] objectForKey:@"pending_ratings"];
        [self performSegueWithIdentifier:@"billingToTutorRatingStudent" sender:self];
    } fail:^(id errorObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:[(NSArray *)errorObject componentsJoinedByString:@", "]
                                   delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil] show];
    }];
}



- (IBAction)billingNumHoursSliderAction:(UISlider *)sender {
    
    NSNumber *billHourlyRateVal = [NSNumber numberWithFloat:self.billingHourlyRateSlider.value];
    NSNumber *billingNumHoursVal = [NSNumber numberWithFloat:[sender value]];
    
    self.billingNumHours.text = [NSString stringWithFormat: @"%ldhr", (long) [billingNumHoursVal integerValue]];
    self.billingTotalAmount.text = [NSString stringWithFormat: @"$%i", ([billingNumHoursVal intValue] * [billHourlyRateVal intValue])];
}

- (IBAction)billingHourlyRateSliderAction:(UISlider *)sender {
    NSNumber *billingNumHoursVal = [NSNumber numberWithFloat:self.billingNumHoursSlider.value];
    NSNumber *billHourlyRateVal = [NSNumber numberWithFloat:[sender value]];
    self.billingHourlyRate.text = [NSString stringWithFormat: @"%ld/hr", (long)[billHourlyRateVal integerValue]];
    self.billingTotalAmount.text = [NSString stringWithFormat: @"$%i", ([billingNumHoursVal intValue] * [billHourlyRateVal intValue])];
}
@end
