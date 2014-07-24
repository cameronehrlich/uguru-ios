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
#import <AudioToolbox/AudioToolbox.h>

#import "UGMessageViewController.h"
#import "UGMessageDescriptionTableViewCell.h"
#import "UGMessageYouTableViewCell.h"
#import "UGMessageMeTableViewCell.h"
#import "UGSendMessageTableViewCell.h"

@implementation UGMessageViewController
{
    UITextField *_composeField;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShown:) name:UIKeyboardDidShowNotification object:nil];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:self.currentConversation.messages.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshConversation];
}
- (void)keyboardShown:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top,
                                                   self.tableView.contentInset.left,
                                                   keyboardSize.height,
                                                   self.tableView.contentInset.right);
}

- (void)sendButtonAction:(UIButton *)sender
{
    Message *newMessage = [Message new];
    [newMessage setContents:_composeField.text];
    [newMessage setConversation_id:self.currentConversation.server_id];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[UGModel sharedInstance] postMessage:newMessage success:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [_composeField setText:@""];
        [_composeField resignFirstResponder];
        self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top,
                                                       self.tableView.contentInset.left,
                                                       0,
                                                       self.tableView.contentInset.right);
        [self refreshConversation];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:self.currentConversation.messages.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } fail:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:@"Oops"
                                    message:@"Your message couldn't be sent"
                                   delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil] show];
    }];
}

- (void)refreshConversation
{
    __block NSInteger numberOfMessages = self.currentConversation.messages.count;
    
    [[UGModel sharedInstance] getMessagesForConversation:self.currentConversation
                                                 success:^(id responseObject) {
                                                     
                                                     Conversation *retConv = responseObject;
                                                     
                                                     if ([retConv.messages count] > numberOfMessages) {
                                                         
                                                         self.currentConversation = responseObject;
                                                         [self.tableView reloadData];
                                                         if (![[[[retConv messages] lastObject] receiver_server_id] isEqualToNumber:[[[UGModel sharedInstance] user] server_id]]) {
                                                             AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
                                                         }
                                                     }
                                                     
                                                 } fail:^(id responseObject) {
                                                     NSLog(@"SHIT FAILED");
                                                 }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isViewLoaded && self.view.window) {
            [self refreshConversation];
        }
    });
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
    NSUInteger rows = [self.currentConversation.messages count] + 1;
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == [self.currentConversation.messages count]) {
        UGSendMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SendMessageCell" forIndexPath:indexPath];
        [[cell sendButton] addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _composeField = [cell textField];
        return cell;
    }
    
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

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
