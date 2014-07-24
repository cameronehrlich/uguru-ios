//
//  UGRequestViewController.m
//  Uguru
//
//  Created by Cameron Ehrlich on 7/23/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGRequestViewController.h"

@implementation UGRequestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)sendAction:(id)sender
{
    Request *newRequest = [Request new];
    [newRequest setCourse_name:self.classField.text];
    [newRequest setProfessor_name:self.professorField.text];
    [newRequest set_description:self.helpField.text];
    [newRequest setLocation_name:self.locationField.text];
    [newRequest setEstimated_hourly:@([[NSNumber numberWithDouble:self.sessionLengthSlider.value] integerValue])];
    [newRequest setUrgency:[NSNumber numberWithBool:self.asapSwitch.on]];
    [newRequest setRecurring:[NSNumber numberWithBool:self.sameGuruSwitch.on]];
    [newRequest setStudent_estimated_hour:@([[NSNumber numberWithDouble:self.offeringPriceSlider.value] integerValue])];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[UGModel sharedInstance] postRequest:newRequest withSuccess:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^(id errorObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:[(NSArray *)errorObject componentsJoinedByString:@", "]
                                   delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil] show];
    }];
}

- (IBAction)offeringPriceSliderAction:(UISlider *)sender
{
    [self.offeringPriceLabel setText:[NSString stringWithFormat:@"$%ld/hr", (long)[[NSNumber numberWithFloat:[sender value]] integerValue]]];
}

- (IBAction)sessionLengthSliderAction:(UISlider *)sender
{
    [self.sessionLengthLabel setText:[NSString stringWithFormat:@"%ld hrs", (long)[[NSNumber numberWithFloat:[sender value]] integerValue]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
