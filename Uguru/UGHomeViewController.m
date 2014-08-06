//
//  UGHomeViewController.m
//  Uguru
//
//  Created by Cameron Ehrlich on 7/21/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGHomeViewController.h"
#import "UGNotificationTableViewCell.h"
#import "UGAppDelegate.h"
#import "UGNotificationTutorAcceptViewController.h"
#import "UGNotificationStudentAcceptViewController.h"
#import "UGNotificationStudentMatchViewController.h"
#import "UGNotificationTutorMatchViewController.h"
#import "UGNotificationStudentRequestViewController.h"
#import "UGLeftMenuTableViewController.h"
#import "UGRatingsViewController.h"
#import "UGBillingContactsTableViewController.h"
#import <AFNetworking/UIKit+AFNetworking.h>
#import <NSDate+RelativeTime.h>
#import "TheSidebarController.h"

@interface UGHomeViewController() <TheSidebarControllerDelegate>
    
@end

@implementation UGHomeViewController
{
    Notification *_selectedNotification;
    NSDictionary *_billingContacts;
    bool menu_on;
    TheSidebarController *sidebarController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    // Create top right toolbar items
    UIBarButtonItem *messagesButton = [[UIBarButtonItem alloc] initWithTitle:@"M" style:UIBarButtonItemStylePlain target:self action:@selector(goToMessages)];
    UIBarButtonItem *requestsButton = [[UIBarButtonItem alloc] initWithTitle:@"A+" style:UIBarButtonItemStylePlain target:self action:@selector(goToRequests)];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = 10;
    
    [self.navigationItem setRightBarButtonItems:@[requestsButton, spacer, messagesButton, spacer]];
    
    // Create left toolbar item
    UIBarButtonItem *hamburger = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hamburger"] style:UIBarButtonItemStylePlain target:self action:@selector(showSidebar)];
    [self.navigationItem setLeftBarButtonItems:@[hamburger] animated:YES];
    
    // Setup pull to refresh
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(fetchNotifications) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    // Setup Sidebar
    NSArray *images = @[[UIImage imageNamed:@"guru"]];
    
    self.sidebar = [[RNFrostedSidebar alloc] initWithImages:images];
    [self.sidebar setDelegate:self];
    
    
    // Send up the apn token!
    User *currentUser = [[UGModel sharedInstance] user];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UGURU_APN_TOKEN]) {
        NSLog(@"Pushing up APS Token");
        [currentUser setApn_token:[[NSUserDefaults standardUserDefaults] stringForKey:UGURU_APN_TOKEN]];
        
        
        [[UGModel sharedInstance] updateUser:currentUser success:^(id responseObject) {
            NSLog(@"Successfully updated the APS token.");
        } fail:^(NSDictionary *errors) {
            NSLog(@"Failed to update the user.");
        }];
    }
    
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
//    UGHomeViewController *centerViewController = [main instantiateViewControllerWithIdentifier:@"UGHomeViewController"];
    UGLeftMenuTableViewController *leftSidebarViewController = [main instantiateViewControllerWithIdentifier:@"UGLeftMenuTableViewController"];
    UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:self];
    
    
    sidebarController = [[TheSidebarController alloc] initWithContentViewController:contentViewController leftSidebarViewController:leftSidebarViewController storyboardsUseAutoLayout:YES];
    
    sidebarController.delegate = self;
    
    UIWindow *mainWindow = [UIApplication sharedApplication].windows[0];
    mainWindow.rootViewController = sidebarController;
    [mainWindow makeKeyAndVisible];
    
    
    // Go get 'em
    [self fetchNotifications];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fetchNotifications];
    menu_on = false;
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchNotifications
{
    // Refresh notifications
    [[UGModel sharedInstance] getAllNotificationsWithSuccess:^(id responseObject) {
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    } fail:^(NSDictionary *errors) {
        [self.refreshControl endRefreshing];
        [[[UIAlertView alloc] initWithTitle:@"Oops"
                                    message:[NSString stringWithFormat:@"Couldn't load feed.\n %@", errors]
                                   delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil] show];
    }];
    
    
    // Refresh user
    [[UGModel sharedInstance] getUserWithSuccess:^(id responseObject) {
        
    } fail:^(NSDictionary *errors) {
        // DO SOMETHING ELSE???
    }];
    
    
    if ([[[UGModel sharedInstance] user].pending_ratings count]) {
        [self goToRatings];
    }
    
}

- (void) updateUser
{
    //Refresh User
    [[UGModel sharedInstance] getUserWithSuccess:^(id responseObject) {
        return;
    } fail:^(NSDictionary *errors) {
        [[[UIAlertView alloc] initWithTitle:@"Oops"
                                    message:[NSString stringWithFormat:@"Couldn't load feed.\n %@", errors]
                                   delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil] show];
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
    [cell.notificationStatus setText:notification.status];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [[UGModel sharedInstance] getNotification:[[[[UGModel sharedInstance] notifications] objectAtIndex:indexPath.row] server_id]
                                  withSuccess:^(id responseObject) {
                                      
                                      _selectedNotification = responseObject;
                                      
                                      
                                      if (_selectedNotification.type) {
                                          //After tutor accepts there should still be a view
                                          if ([_selectedNotification.type isEqualToString:@"tutor-request-offer"]) {
                                              [self performSegueWithIdentifier:@"homeToNotificationTutorAccept" sender:self];
                                          }
                                          //After tutor accepts there should still be a view
                                          else if ([_selectedNotification.type isEqualToString:@"tutor-accept-request"]) {
                                              [self performSegueWithIdentifier:@"homeToNotificationTutorAccept" sender:self];
                                          }
                                          
                                          else if ([_selectedNotification.type isEqualToString:@"tutor-match"]) {
                                              [self performSegueWithIdentifier:@"homeToNotificationTutorMatch" sender:self];
                                          }
                                          else if ([_selectedNotification.type isEqualToString:@"student-match"]) {
                                              [self performSegueWithIdentifier:@"homeToNotificationStudentMatch" sender:self];
                                          }
                                          else if ([_selectedNotification.type isEqualToString:@"student-request-help"]) {
                                              [self performSegueWithIdentifier:@"homeToNotificationStudentRequest" sender:self];
                                          }
                                          else if ([_selectedNotification.type isEqualToString:@"student-incoming-offer"]) {
                                              [self performSegueWithIdentifier:@"homeToNotificationStudentAccept" sender:self];
                                          }
                                          else
                                          {
                                              [[[UIAlertView alloc] initWithTitle:@"Notification Info"
                                                                         message:_selectedNotification.description
                                                                        delegate:nil
                                                               cancelButtonTitle:@"Okay"
                                                                otherButtonTitles:nil] show];
                                          }

                                          
                                      }
                                      
                                  } fail:^(NSDictionary *errors) {
                                      [[[UIAlertView alloc] initWithTitle:@"Ooops"
                                                                  message:@"Couldn't fetch information about this notification."
                                                                 delegate:nil
                                                        cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
                                  }];
}

- (void)showSidebar
{
    if (menu_on) {
        [self.sidebarController dismissSidebarViewController];
        menu_on = false;
    } else {
        [self.sidebarController presentLeftSidebarViewControllerWithStyle:SidebarTransitionStyleFacebook];
        menu_on = true;
    }
}


- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
        {
            [[UGModel sharedInstance] logoutUserWithSuccess:^(id responseObject) {
                [self performSegueWithIdentifier:@"homeToWelcome" sender:self];
            } fail:^(id errorObject) {
                NSLog(@"FAILED TO LOGOUT, CHECK YOURSELF!");
                [self performSegueWithIdentifier:@"homeToWelcome" sender:self];
            }];
            break;
        }
        default:
            break;
    }
    [sidebar dismissAnimated:YES];
}

- (void)goToMessages
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[UGModel sharedInstance] getAllConversationsWithSuccess:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self performSegueWithIdentifier:@"homeToInbox" sender:self];
    } fail:^(NSDictionary *errors) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"Couldn't get your conversations, sorry!"
                                   delegate:nil
                          cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
    }];
    
}

- (void)goToBilling {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[UGModel sharedInstance] getAllBillingContactsWithSuccess:^(id responseObject) {
        _billingContacts = responseObject;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self performSegueWithIdentifier:@"homeToBilling" sender:self];
    } fail:^(NSDictionary *errors) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"Couldn't get your conversations, sorry!"
                                   delegate:nil
                          cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
    }];
}

- (void) goToRatings {
    [self performSegueWithIdentifier:@"homeToRatings" sender:self];
    
}

- (void)goToRequests
{
    [self performSegueWithIdentifier:@"homeToRequest" sender:self];
}

- (void)goToSettings
{
    [self performSegueWithIdentifier:@"homeToSettings" sender:self];
}

- (void)goToAccount
{
    [self performSegueWithIdentifier:@"homeToAccount" sender:self];
}

- (void)goToProfile
{
    if ([[[UGModel sharedInstance] user].is_a_tutor boolValue]== YES) {
        [self performSegueWithIdentifier:@"homeToProfile" sender:self];
    } else {
        [self performSegueWithIdentifier:@"homeToEditProfile" sender:self];
    }
}

- (void) logoutUser {
    [[UGModel sharedInstance] logoutUserWithSuccess:^(id responseObject) {
        [self performSegueWithIdentifier:@"homeToWelcome" sender:self];
    } fail:^(id errorObject) {
        NSLog(@"FAILED TO LOGOUT, CHECK YOURSELF!");
        [self performSegueWithIdentifier:@"homeToWelcome" sender:self];
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"homeToNotificationTutorAccept"]) {
        UGNotificationTutorAcceptViewController *dst = [segue destinationViewController];
        [dst setNotification:_selectedNotification];
    }
    else if ([segue.identifier isEqualToString:@"homeToNotificationTutorMatch"]){
        UGNotificationTutorMatchViewController *dst = [segue destinationViewController];
        [dst setNotification:_selectedNotification];
    }
    else if ([segue.identifier isEqualToString:@"homeToBilling"]){
        UGBillingContactsTableViewController *dst = [segue destinationViewController];
        [dst setBillingContacts:[_billingContacts objectForKey:@"billing-contacts"]];
    }
    else if ([segue.identifier isEqualToString:@"homeToNotificationStudentMatch"]){
        UGNotificationStudentMatchViewController *dst = [segue destinationViewController];
        [dst setNotification:_selectedNotification];
    }
    else if ([segue.identifier isEqualToString:@"homeToNotificationStudentRequest"]){
        UGNotificationStudentRequestViewController *dst = [segue destinationViewController];
        [dst setNotification:_selectedNotification];
    }
    else if ([segue.identifier isEqualToString:@"homeToNotificationStudentAccept"]){
        UGNotificationStudentAcceptViewController *dst = [segue destinationViewController];
        [dst setNotification:_selectedNotification];
    }else if ([segue.identifier isEqualToString:@"homeToWelcome"]){
        [SSKeychain deletePasswordForService:UGURU_KEYCHAIN_SERVICE account:UGURU_KEYCHAIN_ACCOUNT];
    }
}

#pragma mark - TheSidebarController Delegate Methods
- (void)sidebarController:(TheSidebarController *)controller willShowViewController:(UIViewController *)viewController
{
    NSLog(@"sidebarController:%@ willShowViewController:%@", sidebarController, viewController);
    
}

- (void)sidebarController:(TheSidebarController *)controller didShowViewController:(UIViewController *)viewController
{
    NSLog(@"sidebarController:%@ didShowViewController:%@", controller, viewController);
}

- (void)sidebarController:(TheSidebarController *)controller willHideViewController:(UIViewController *)viewController
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)sidebarController:(TheSidebarController *)controller didHideViewController:(UIViewController *)viewController
{
    NSString *dst = [[UGModel sharedInstance] settings_dest];
    
    if ([dst isEqualToString:@"profile"]) {
        [self goToProfile];
    } else if ([dst isEqualToString:@"logout"]) {
        [self logoutUser];
    } else if ([dst isEqualToString:@"billing"]) {
        [self goToBilling];
    } else if ([dst isEqualToString:@"account"]) {
        [self goToAccount];
    } else if ([dst isEqualToString:@"settings"]) {
        [self goToSettings];
    }
    [UGModel sharedInstance].settings_dest = nil;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

@end
