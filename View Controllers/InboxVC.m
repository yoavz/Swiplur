//
//  InboxVC.m
//  Swiplur
//
//  Created by Yoav on 12/19/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

#import "SWRevealViewController.h"

#import "InboxVC.h"
#import "Message.h"
#import "User.h"

@interface InboxVC ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;

@end

@implementation InboxVC

- (void)viewDidLoad
{
    self.parseClassName = [Message parseClassName];
    [super viewDidLoad];
    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer ];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"View Message"]) {
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            UITableViewCell *cell = (UITableViewCell *)sender;
            PFObject *object = [self objectAtIndexPath:[self.tableView indexPathForCell:cell]];
            if ([object isKindOfClass:[Message class]]) {
                Message *message = (Message *)object;
                NSLog(@"%@", message.body);
                [segue.destinationViewController performSelector:@selector(setMessage:) withObject:message];
            }
        }
    }
}

/*****************************************/
/******* PFQueryTableViewController ******/
/*****************************************/

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    [query includeKey:@"sender"];
    [query includeKey:@"recipient"];
    [query includeKey:@"post"];
    
    [query orderByDescending:@"createdAt"];
    
    [query whereKey:@"recipient" equalTo:[User currentUser]];
    
    return query;
}

/*****************************************/
/******* TABLE VIEW DELEGATE *************/
/*****************************************/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *CellIdentifier = @"message";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        return cell;
    }

    Message *message = (Message *)object;
    cell.textLabel.text = message.sender.fullName;
    cell.detailTextLabel.text = message.createdAt;
    
    return cell;
}

//default height of cell
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 60 ;
}

/*******************/
/******* UTILS *****/
/*******************/

- (NSString *)formatMessageDate:(NSDate *)time {
    NSDateFormatter *fmtTime = [[NSDateFormatter alloc] init];
    [fmtTime setTimeStyle:NSDateFormatterShortStyle];
    NSDateFormatter *fmtDate = [[NSDateFormatter alloc] init];
    [fmtDate setDateStyle:NSDateFormatterMediumStyle];
    return [NSString stringWithFormat:@"%@ %@", [fmtTime stringFromDate:time], [fmtDate stringFromDate:time]];
}

@end
