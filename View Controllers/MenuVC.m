//
//  MenuViewController.m
//  Swiplur
//
//  Created by Yoav on 12/9/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

#import "MenuVC.h"
#import "Utils.h"
#import "PostTVC.h"
#import "User.h"

#import "SWRevealViewController.h"

@interface MenuVC ()

@property (strong, nonatomic) NSArray *menuItems ;

@end

@implementation MenuVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (NSArray *)menuItems
{
    if (!_menuItems) {
        _menuItems = @[@"forsale", @"addpost", @"settings", @"about"];
    }
    return _menuItems;
}

- (void)refreshView
{
    //self.userLabel.text = [[User currentUser] fullName];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self.menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[PostTVC class]]) {
        if ([segue.destinationViewController respondsToSelector:@selector(setParseClassName:)]) {
            [segue.destinationViewController performSelector:@selector(setParseClassName:) withObject:[Utils getPostClassName]];
        }
    }
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
}

@end
