//
//  UGBillingContactsTableViewController.m
//  Uguru
//
//  Created by Samir Makhani on 7/31/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGBillingContactsTableViewController.h"
#import "UGBillContactTableViewCell.h"
#import "UGBillingTableViewController.h"
#import <AFNetworking/UIKit+AFNetworking.h>

@interface UGBillingContactsTableViewController ()
@end

@implementation UGBillingContactsTableViewController {
    NSDictionary *_selectedBillingDetails;
}

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [self.billingContacts count];
}


- (UGBillContactTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UGBillContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BillingContactCell" forIndexPath:indexPath];
    NSDictionary *cellDetails = [self.billingContacts objectAtIndex:indexPath.row];
    NSString *image_url = [cellDetails objectForKey:@"'student-profile"];
    
    if ([image_url rangeOfString:@"http"].location == NSNotFound) {
        [cell.messageImageView setImageWithURL:[NSURL URLWithString:image_url relativeToURL:[NSURL URLWithString:API_BASE_URL]] placeholderImage:[UIImage imageNamed:@"notificationPlaceholder"]];
    }else{
        [cell.messageImageView setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:[UIImage imageNamed:@"notificationPlaceholder"]];
    }
    
    [cell.messageNameLabel setText:[cellDetails objectForKey:@"student-name"]];
    [cell.messageCourseLabel setText:[cellDetails objectForKey:@"course"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedBillingDetails = [self.billingContacts objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"billingContactstoBilling" sender:self];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"billingContactstoBilling"]) {
        UGBillingTableViewController *dst = [segue destinationViewController];
        [dst setBillingDetails:_selectedBillingDetails];
    }
}

@end
