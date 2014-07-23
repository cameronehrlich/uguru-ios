//
//  UGInboxViewController.m
//  Uguru
//
//  Created by Cameron Ehrlich on 7/22/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGInboxViewController.h"
#import "UGInboxTableViewCell.h"
#import <AFNetworking/UIKit+AFNetworking.h>
#import <NSDate+RelativeTime.h>
#import <UIColor+Hex.h>
#import "UGMessageTableViewController.h"

@implementation UGInboxViewController
{
    Conversation *_selectedConversation;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    return [[[UGModel sharedInstance] conversations] count];
}

-(UGInboxTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ConversationCell";
    UGInboxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Conversation *convo = [[[UGModel sharedInstance] conversations]objectAtIndex:indexPath.row];
    
    if ([convo.image_url rangeOfString:@"http"].location == NSNotFound) {
        [cell.conversationImageView setImageWithURL:[NSURL URLWithString:convo.image_url relativeToURL:[NSURL URLWithString:API_BASE_URL]] placeholderImage:[UIImage imageNamed:@"notificationPlaceholder"]];
    }else{
        [cell.conversationImageView setImageWithURL:[NSURL URLWithString:convo.image_url] placeholderImage:[UIImage imageNamed:@"notificationPlaceholder"]];
    }
    
    [cell.nameLabel setText:convo.name];

    [cell.lastMessageLabel setText:convo.last_message];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    // Always use this locale when parsing fixed format date strings
    NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [formatter setLocale:posix];
    NSDate *date = [formatter dateFromString:convo.last_message_time];
    
    [cell.timeLabel setText:[date relativeTime]];
    
    if ([convo.read boolValue]) {
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    }else{
        UIColor *unreadColor = [UIColor colorWithCSS:@"c5eeff"];
        [cell.contentView setBackgroundColor:unreadColor];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedConversation = [[[UGModel sharedInstance] conversations] objectAtIndex:indexPath.row];

    [[UGModel sharedInstance] getMessagesForConversation:_selectedConversation
                                                 success:^(id responseObject) {
                                                     [self performSegueWithIdentifier:@"inboxToMessage" sender:self];
                                                 } fail:^(id responseObject) {
                                                     NSLog(@"SHIT FAILED");
                                                 }];

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"inboxToMessage"]) {
        UGMessageTableViewController *dst = [segue destinationViewController];
        [dst setCurrentConversation:_selectedConversation];
    }
}

@end
