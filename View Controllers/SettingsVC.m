//
//  SettingsVC.m
//  Swiplur
//
//  Created by Yoav on 12/23/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

#import "SettingsVC.h"
#import "User.h"
#import "Utils.h"

#import "SWRevealViewController.h"

@interface SettingsVC () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@property (weak, nonatomic) IBOutlet UITableViewCell *accountCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *phoneNumberCell;

@property BOOL phoneNumberCheck;

@end

@implementation SettingsVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self refresh];
    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer ];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refresh];
}

- (void)refresh
{
    User *current = [User currentUser];
    
    //account
    self.accountCell.textLabel.text = current.fullName;
    
    //phone
    if (current.isVerified && current.phoneNumber) {
        self.phoneNumberCell.textLabel.text = [NSString stringWithFormat:@"%@ - ✅", current.phoneNumber];
        self.phoneNumberCell.accessoryType = UITableViewCellAccessoryNone ;
        self.phoneNumberCheck = YES ;
    } else if (current.phoneNumber) {
        self.phoneNumberCell.textLabel.text = [NSString stringWithFormat:@"%@ - ⛔️", current.phoneNumber];
        self.phoneNumberCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
        self.phoneNumberCheck = NO ;
    } else {
        self.phoneNumberCell.textLabel.text = @"Add a phone number";
        self.phoneNumberCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
        self.phoneNumberCheck = NO ;
    }
    
    //location
    NSIndexPath *path = [NSIndexPath indexPathForRow:[Utils getLocation] inSection:[self locationSection]];
    [self.tableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
}

/*********/
/* Alert */
/*********/

#define PHONE_NUMBER_ALERT_TAG 3

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Phone Number"]) {
        if ([[User currentUser] isVerified]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Phone Number" message:@"Would you like to delete this phone number? If you would like to enter a new number, you must go through the verification process again." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alert setTag:PHONE_NUMBER_ALERT_TAG];
            [alert show];
            return NO;
        }
        else
            return YES;
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == PHONE_NUMBER_ALERT_TAG) {
        if (buttonIndex == 1) {
            NSLog(@"reseting number");
            [[User currentUser] resetNumberWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    //[self performSegueWithIdentifier:@"Phone Number" sender:self];
                } else {
                    UIAlertView *error = [self messageWithTitle:@"Network Error" andMessage:@"Could not connect to the network"];
                    [error show];
                }
                [self refresh];
            }];
        } else {
            [self refresh];
        }
    }
}

- (UIAlertView *)messageWithTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *error = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    return error;
}


/***********************/
/* Table View Delegate */
/***********************/

- (NSInteger)locationSection
{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //location cells
    if (indexPath.section == [self locationSection]) {
        [Utils setLocation:(Location)indexPath.row];
        NSLog(@"Set location %@", [self stringForLocation:(Location)indexPath.row]);
    }
    
    //phone number cell
    if (indexPath == [self.tableView indexPathForCell:self.phoneNumberCell]) {
        NSLog(@"clicked phone number cell");
    }
}

- (NSArray *)locations
{
    return [NSArray arrayWithObjects:[NSNumber numberWithInt:LOS_ANGELES], [NSNumber numberWithInt:DAVIS], nil];
}

- (NSString *)stringForLocation:(Location)location
{
    if (location == LOS_ANGELES) {
        return @"Los Angeles";
    } else if (location == DAVIS){
        return @"Davis";
    } else {
        return @"Any";
    }
}
@end
