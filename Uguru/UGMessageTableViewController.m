//
//  UGMessageTableViewController.m
//  Uguru
//
//  Created by Cameron Ehrlich on 7/23/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <AFNetworking/UIKit+AFNetworking.h>
#import <NSDate+RelativeTime.h>
#import <UIColor+Hex.h>

#import "UGMessageTableViewController.h"
#import "UGMessageDescriptionTableViewCell.h"
#import "UGMessageYouTableViewCell.h"
#import "UGMessageMeTableViewCell.h"

@implementation UGMessageTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.stickeyKeyboardView = [[RDRStickyKeyboardView alloc] initWithScrollView:self.tableView];
//    [self.stickeyKeyboardView setFrame:self.view.bounds];
//    [self.stickeyKeyboardView setAutoresizingMask: (UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth) ];
//    [self.view addSubview:self.stickeyKeyboardView];
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
    return [self.currentConversation.messages count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UGMessageDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageDescriptionCell" forIndexPath:indexPath];
        return cell;
    }else
    {
        Message *message = [[self.currentConversation messages] objectAtIndex:indexPath.row - 1];
        
        if ([message.sender_server_id isEqualToNumber:[[[UGModel sharedInstance] user] server_id]]) {
            // Message was sent by me
            UGMessageMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageMeCell" forIndexPath:indexPath];
            NSURL *imageURL = [NSURL URLWithString:[[[UGModel sharedInstance] user] image_url]];
            [cell.messageImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"guru"]];
            [cell.messageContentView setText:message.contents];
            [cell.messageDateLabel setText:message.relativeTimeString];
            [cell.messageNameLabel setText:message.sender_name];
            
            return cell;
        }else{
            // Message was sent by other person
            UGMessageYouTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageYouCell" forIndexPath:indexPath];
            NSURL *imageURL = [NSURL URLWithString:self.currentConversation.image_url];
            [cell.messageImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"guru"]];
            [cell.messageContentView setText:message.contents];
            [cell.messageDateLabel setText:message.relativeTimeString];
            [cell.messageNameLabel setText:message.sender_name];
            return cell;
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
