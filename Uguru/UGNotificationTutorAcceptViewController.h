//
//  UGNotificationViewController.h
//  Uguru
//
//  Created by Cameron Ehrlich on 7/22/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UGNotificationTutorAcceptViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *professorLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *sessionLengthLabel;
@property (strong, nonatomic) IBOutlet UILabel *hourlyRateLabel;
@property (strong, nonatomic) IBOutlet UISlider *hourlyRateSlider;
@property (strong, nonatomic) IBOutlet UITextView *descriptionView;
@property (strong, nonatomic) IBOutlet UILabel *personalMessageToLabel;
@property (strong, nonatomic) IBOutlet UITextField *messageField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *acceptButton;



@property (nonatomic, strong) Notification *notification;
- (IBAction)hourlyRateSliderAction:(id)sender;

- (IBAction)sendAction:(id)sender;
- (IBAction)goToCalendar:(id)sender;

@end
