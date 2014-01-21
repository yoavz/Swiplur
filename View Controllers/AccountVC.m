//
//  SettingsVC.m
//  Swiplur
//
//  Created by Yoav on 11/24/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

#import "AccountVC.h"
#import "Utils.h"
#import "User.h"
#import "TitleVC.h"


@interface AccountVC ()

@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *fbFullName;
@property (weak, nonatomic) IBOutlet UILabel *fbLocation;

@end

@implementation AccountVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.settingsTable.dataSource = self;
    
    [self updateView];
}

- (void)updateView
{
    self.profilePic.profileID = [[User currentUser] facebookID];
    self.fbFullName.text = [[User currentUser] fullName];
    self.fbLocation.text = [[User currentUser] locationName];
}

/************/
/* FACEBOOK */
/************/

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView;
{
    //log out of parse
    [User logOut];
    
    //go back to title screen
    UIStoryboard *storyboard = self.storyboard;
    TitleVC *sv = [storyboard instantiateViewControllerWithIdentifier:@"title"];
    [self presentViewController:sv animated:YES completion:NULL];
}


/*********************/
/* Table Data Source */
/*********************/

/*
- (NSArray *) settings
{
    return @[@"Location", @"Phone Number"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self settings] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self settings];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self settings] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.textLabel.text = [[self settings] objectAtIndex:indexPath.section];
    
    return cell;
}

 */
/* UIPickerViewDelegate functions
 
 -(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
 {
 //One column
 return 1;
 }
 
 -(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
 {
 //set number of rows
 return [[self locations] count];
 }
 
 -(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
 {
 NSNumber *locNumber = [[self locations] objectAtIndex:row];
 Location loc = (Location) [locNumber intValue];
 return [self stringForLocation:loc];
 }
 
 - (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
 {
 Location loc = (Location)row;
 [Utils setLocation:loc];
 }

 */

@end
