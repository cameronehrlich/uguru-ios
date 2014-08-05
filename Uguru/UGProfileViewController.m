//
//  UGProfileViewController.m
//  Uguru
//
//  Created by Samir Makhani on 8/2/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGProfileViewController.h"
#import "UGProfileEditViewController.h"

@interface UGProfileViewController ()
@end

@implementation UGProfileViewController
User *currentUser;
bool initialized;

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
    self.automaticallyAdjustsScrollViewInsets = NO;
    initialized = true;
    
    
    currentUser = [[UGModel sharedInstance] user];
    NSString *image_url = currentUser.image_url;
    
    if ([image_url rangeOfString:@"http"].location == NSNotFound) {
        [self.photo setImage:[UIImage imageNamed:@"notificationPlaceholder"]];
    }else{
        NSURL * imageURL = [NSURL URLWithString:image_url];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage * image = [UIImage imageWithData:imageData];
        [self.photo setImage:image];
    };
    
    self.name.text = currentUser.name;
    self.year.text = currentUser.year;
    self.bio_header_text.text = [NSString stringWithFormat:@"%@'s profile", self.name.text];
    self.bio_text.text = currentUser.bio;
    self.major.text = currentUser.major;
    
    if (currentUser.num_ratings) {
        self.num_ratings.text = [NSString stringWithFormat:@"%@", currentUser.num_ratings];
    } else {
        self.num_ratings.hidden = true;
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!initialized) {
        currentUser = [[UGModel sharedInstance] user];
        NSString *image_url = currentUser.image_url;
        
        if ([image_url rangeOfString:@"http"].location == NSNotFound) {
            [self.photo setImage:[UIImage imageNamed:@"notificationPlaceholder"]];
        }else{
            NSURL * imageURL = [NSURL URLWithString:image_url];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            UIImage * image = [UIImage imageWithData:imageData];
            [self.photo setImage:image];
        };
        
        self.name.text = currentUser.name;
        self.year.text = currentUser.year;
        self.bio_header_text.text = [NSString stringWithFormat:@"%@'s profile", self.name.text];
        self.bio_text.text = currentUser.bio;
        self.major.text = currentUser.major;
    }
    initialized = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)editProfileAction:(id)sender {
    [self performSegueWithIdentifier:@"profileToProfileEdit" sender:self];
}

@end
