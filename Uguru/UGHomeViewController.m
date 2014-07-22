//
//  UGHomeViewController.m
//  Uguru
//
//  Created by Cameron Ehrlich on 7/21/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGHomeViewController.h"
#import "UGNotificationTableViewCell.h"
#import <AFNetworking/UIKit+AFNetworking.h>
#import <NSDate+RelativeTime.h>

@implementation UGHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Create top right toolbar items
    UIBarButtonItem *feedButton = [[UIBarButtonItem alloc] initWithTitle:@"N" style:UIBarButtonItemStylePlain target:self action:@selector(goToFeed)];
    UIBarButtonItem *messagesButton = [[UIBarButtonItem alloc] initWithTitle:@"M" style:UIBarButtonItemStylePlain target:self action:@selector(goToMessages)];
    UIBarButtonItem *requestsButton = [[UIBarButtonItem alloc] initWithTitle:@"A+" style:UIBarButtonItemStylePlain target:self action:@selector(goToRequests)];
    
    [self.navigationItem setRightBarButtonItems:@[requestsButton, messagesButton, feedButton] animated:YES];
    
    // Create left toolbar item
    UIBarButtonItem *hamburger = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hamburger"] style:UIBarButtonItemStylePlain target:self action:@selector(showSidebar)];
    [self.navigationItem setLeftBarButtonItems:@[hamburger] animated:YES];
    
    // Setup pull to refresh
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(fetchNotifications) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;

    // Setup Sidebar
    NSArray *images = @[
                        [UIImage imageNamed:@"guru"],
                        [UIImage imageNamed:@"guru"],
                        [UIImage imageNamed:@"guru"],
                        [UIImage imageNamed:@"guru"]
                        ];
    
    self.sidebar = [[RNFrostedSidebar alloc] initWithImages:images];
    [self.sidebar setDelegate:self];
    
    // Go get 'em
    [self fetchNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchNotifications
{
    [[UGModel sharedInstance] getNotificationsWithSuccess:^(id responseObject) {
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    } fail:^(NSDictionary *errors) {
        [self.refreshControl endRefreshing];
        [[[UIAlertView alloc] initWithTitle:@"Oops" message:[NSString stringWithFormat:@"Couldn't load feed.\n %@", errors] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[UGModel sharedInstance] notifications] count];
}

- (void)showSidebar
{
    [self.sidebar show];
}


- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index
{
    [sidebar dismissAnimated:YES];
}
- (void)goToFeed
{
    
}

- (void)goToMessages
{
    
}

- (void)goToRequests
{
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the notification and dequeueueue a cell
    Notification *notification = [[[UGModel sharedInstance] notifications] objectAtIndex:indexPath.row];
    static NSString *cellIdentifier = @"NotificationCell";
    UGNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    // Configure da bitch
    [cell.notificationTitle setText:[notification feed_message]];
    if ([notification.image_url rangeOfString:@"http"].location == NSNotFound) {
        [cell.notificationImageView setImage:[UIImage imageNamed:@"notificationPlaceholder"]];
    }else{
        [cell.notificationImageView setImageWithURL:[NSURL URLWithString:notification.image_url] placeholderImage:[UIImage imageNamed:@"notificationPlaceholder"]];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    // Always use this locale when parsing fixed format date strings
    NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [formatter setLocale:posix];
    NSDate *date = [formatter dateFromString:notification.time_created];
    
    [cell.notificationDate setText:[date relativeTime]];
    
    if (![notification.status isEqual:[NSNull null]]) {
        [cell.notificationStatus setText:notification.status];
    }else{
        [cell.notificationStatus setText:@""];
    }

    return cell;
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

@end
