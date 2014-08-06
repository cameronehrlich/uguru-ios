//
//  UGLeftMenuTableViewController.m
//  Uguru
//
//  Created by Samir Makhani on 8/5/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGLeftMenuTableViewController.h"
#import "UGProfileViewController.h"
#import "UGProfileEditViewController.h"
#import "UGHomeViewController.h"
#import "TheSidebarController.h"


@interface UGLeftMenuTableViewController ()

@end

@implementation UGLeftMenuTableViewController

User *currentUser;

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
    currentUser = [[UGModel sharedInstance] user];
    self.name.text = currentUser.name;
    
    NSString *image_url = currentUser.image_url;
    
    if ([image_url rangeOfString:@"http"].location == NSNotFound) {
        [self.photo setImage:[UIImage imageNamed:@"notificationPlaceholder"]];
    }else{
        NSURL * imageURL = [NSURL URLWithString:image_url];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage * image = [UIImage imageWithData:imageData];
        [self.photo setImage:image];
    }
    
    if ([currentUser.is_a_tutor boolValue] == YES) {
        self.billStudentCell.hidden = NO;
    } else {
        self.billStudentCell.hidden = YES;
    }

    self.faqCell.hidden = YES;
    self.becomeAGuruCell.hidden = YES;
    
}

- (void) viewWillAppear {
    [super viewWillAppear:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int index = (int) indexPath.row;
    CGFloat result = 0;
    switch (index) {
        case 0:
            result = (CGFloat) 20;
            break;
        case 1:
            result = (CGFloat) 80;
            break;
        case 2:
            if ([currentUser.is_a_tutor boolValue] == NO) {
                result = 0;
            } else {
                result = 40;
            }
            break;
        case 5:
            if ([currentUser.is_a_tutor boolValue] == YES) {
                result = 0;
            } else {
                result = 0;
            }
            break;
        case 6:
            result = 0;
            break;
        default:
            result = (CGFloat) 40;
            break;
            
    }
    return result;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int index = (int) indexPath.row;
    switch (index) {
        case 2:
            [UGModel sharedInstance].settings_dest = @"billing";
            break;
        case 3:
            [UGModel sharedInstance].settings_dest = @"account";
            break;
        case 4:
            [UGModel sharedInstance].settings_dest= @"settings";
            break;
        case 7:
            [UGModel sharedInstance].settings_dest = @"logout";
            break;
    }
    [self.sidebarController dismissSidebarViewController];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)goToProfile:(id)sender {
        [UGModel sharedInstance].settings_dest = @"profile";
        [self.sidebarController dismissSidebarViewController];
}

@end
