//
//  UGRatingsViewController.m
//  Uguru
//
//  Created by Samir Makhani on 8/1/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGRatingsViewController.h"
#import "AMRatingControl.h"


@interface UGRatingsViewController ()

@end

@implementation UGRatingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    User *currentUser = [[UGModel sharedInstance] user];
    self.ratings_info = currentUser.pending_ratings;
    NSString *image_url;
    
    if (currentUser.server_id == [self.ratings_info objectForKey:@"student_server_id"]) {
        self.name.text = [self.ratings_info objectForKey:@"tutor_name"];
        image_url = [self.ratings_info objectForKey:@"tutor_profile"];
    } else {
        self.name.text = [self.ratings_info objectForKey:@"student_name"];
        image_url = [self.ratings_info objectForKey:@"student_profile"];
    }
    
    if ([image_url rangeOfString:@"http"].location == NSNotFound) {
        [self.photo setImage:[UIImage imageNamed:@"notificationPlaceholder"]];
    }else{
        NSURL * imageURL = [NSURL URLWithString:image_url];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage * image = [UIImage imageWithData:imageData];
        [self.photo setImage:image];
    }
    
    CGRect photoRect = [self.photo convertRect:self.photo.bounds fromView:self.view];
    
    self.colorRatingControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(200, photoRect.size.height + photoRect.origin.y)
                                                                           emptyColor:[UIColor yellowColor]
                                                                           solidColor:[UIColor yellowColor]
                                                                         andMaxRating:5];
    
    self.colorRatingControl.center = CGPointMake(self.view.frame.size.width / 2, photoRect.size.height - photoRect.origin.y + 15);
    [self.view addSubview:self.colorRatingControl];
    
    [self.navigationItem setHidesBackButton:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)submitRating:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSNumber *star_rating =  [NSNumber numberWithInteger:self.colorRatingControl.rating];
    User *currentUser = [[UGModel sharedInstance] user];
    
    [params setObject:([self.ratings_info objectForKey:@"student_server_id"]) forKey:@"student_server_id"];
    [params setObject:([self.ratings_info objectForKey:@"tutor_server_id"]) forKey:@"tutor_server_id"];
    
    [params setObject: star_rating  forKey:@"star_rating"];
    
    if (currentUser.server_id == [self.ratings_info objectForKey:@"student_server_id"]) {
        [params setObject:@YES forKey:@"student_rating_tutor"];
    } else {
        [params setObject:@YES forKey:@"tutor_rating_student"];
    }
    
    [params setObject: self.additionalDetails.text  forKey:@"rating_description"];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[UGModel sharedInstance] submitRatingWithSuccess:params withSuccess:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } fail:^(id errorObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:[(NSArray *)errorObject componentsJoinedByString:@", "]
                                   delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil] show];
    }];
}
@end
