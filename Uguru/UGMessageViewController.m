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


#import "UGMessageViewController.h"
#import "UGMessageDescriptionTableViewCell.h"
#import "UGMessageYouTableViewCell.h"
#import "UGMessageMeTableViewCell.h"

@implementation UGMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.stickyKeyboardView = [[RDRStickyKeyboardView alloc] initWithScrollView:self.tableView];
    self.stickyKeyboardView.frame = self.view.bounds;
    [[self.stickyKeyboardView.inputView rightButton] addTarget:self
                                                        action:@selector(sendButtonAction:)
                                              forControlEvents:UIControlEventTouchUpInside];
    
    
    self.stickyKeyboardView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.stickyKeyboardView];
}

- (void)sendButtonAction:(UIButton *)sender
{
    Message *newMessage = [Message new];
    [newMessage setContents:self.stickyKeyboardView.inputView.textView.text];
    [newMessage setConversation_id:self.currentConversation.server_id];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[UGModel sharedInstance] postMessage:newMessage success:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self refreshConversation];
    } fail:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:@"Oops"
                                    message:@"Your message couldn't be sent"
                                   delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil] show];
    }];
    
    [self.stickyKeyboardView.inputView.textView setText:@""];
}

- (void)refreshConversation
{
    [[UGModel sharedInstance] getMessagesForConversation:self.currentConversation
                                                 success:^(id responseObject) {
                                                     self.currentConversation = responseObject;
                                                     [self.tableView reloadData];
                                                 } fail:^(id responseObject) {
                                                     NSLog(@"SHIT FAILED");
                                                 }];
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
    return [self.currentConversation.messages count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *message = [[self.currentConversation messages] objectAtIndex:indexPath.row];
    
    if ([message.sender_server_id isEqualToNumber:[[[UGModel sharedInstance] user] server_id]]) {
        // Message was sent by me
        UGMessageMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageMeCell" forIndexPath:indexPath];
        NSURL *imageURL = [NSURL URLWithString:[[[UGModel sharedInstance] user] image_url]];
        [cell.messageImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"guru"]];
        [cell.messageBodyLabel setText:message.contents];
        [cell.messageDateLabel setText:message.relativeTimeString];
        [cell.messageNameLabel setText:message.sender_name];
        
        return cell;
    }else{
        // Message was sent by other person
        UGMessageYouTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageYouCell" forIndexPath:indexPath];
        NSURL *imageURL = [NSURL URLWithString:self.currentConversation.image_url];
        [cell.messageImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"guru"]];
        [cell.messageBodyLabel setText:message.contents];
        [cell.messageDateLabel setText:message.relativeTimeString];
        [cell.messageNameLabel setText:message.sender_name];
        return cell;
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
