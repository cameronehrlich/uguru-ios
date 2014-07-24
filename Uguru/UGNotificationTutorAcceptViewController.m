//
//  UGNotificationViewController.m
//  Uguru
//
//  Created by Cameron Ehrlich on 7/22/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGNotificationTutorAcceptViewController.h"
#import <AFNetworking/UIKit+AFNetworking.h>

@implementation UGNotificationTutorAcceptViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.titleLabel setText:self.notification.feed_message];
    [self.imageView setImageWithURL:[NSURL URLWithString:self.notification.image_url] placeholderImage:[UIImage imageNamed:@"guru"]]; // TODO : handle when the image doesn;t have the full path
    [self.professorLabel setText:[NSString stringWithFormat:@"Professor: %@", self.notification.request.professor_name]];
    [self.locationLabel setText:[NSString stringWithFormat:@"Preferred Meeting Location: %@", self.notification.request.location_name]];
    [self.sessionLengthLabel setText:[NSString stringWithFormat:@"The Session Would Take: %@ hours", self.notification.request.time_estimate]];
    [self.hourlyRateLabel setText:[NSString stringWithFormat:@"Hourly Rate: %@/hour", self.notification.request.student_estimated_hour]];
    [self.hourlyRateSlider setValue:[self.notification.request.student_estimated_hour floatValue] animated:YES];
    [self.descriptionView setText:self.notification.request._description];
//    [self.personalMessageToLabel setText:[NSString stringWithFormat:@"Your Personal Message To %@", self.notification.request.student_name]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hourlyRateSliderAction:(UISlider *)sender
{
    [self.hourlyRateLabel setText:[NSString stringWithFormat:@"Hourly Rate: $%@/hour", @([[NSNumber numberWithFloat:[sender value]] integerValue])]];
}

- (IBAction)sendAction:(id)sender {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObject:@([[NSNumber numberWithDouble:self.hourlyRateSlider.value] integerValue]) forKey:@"hourly_amount"];
    [params setObject:self.notification.request.server_id forKey:@"request_id"];
    [params setObject:self.notification.server_id forKey:@"notif_id"];
    [params setObject:self.messageField.text forKey:@"tutor_message"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[UGModel sharedInstance] tutorAcceptRequest:params withSuccess:^(id responseObject) {
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
@end
