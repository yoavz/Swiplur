//
//  SellingTVC.m
//  Swipe
//
//  Created by Yoav on 11/4/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//
#import "PostTVC.h"
#import "Post.h"
#import "ViewPostVC.h"
#import "Utils.h"
#import "PostTableViewCell.h"

#import <Parse/Parse.h>
#import "SWRevealViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface PostTVC()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@end

@implementation PostTVC

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 20;
    }
    return self;
}

- (void)viewDidLoad
{
    self.parseClassName = [Utils getPostClassName];
    [super viewDidLoad];
    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer ];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self refreshLocation];
    [self loadObjects];
}

//sort by most recent
- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    [query includeKey:@"user"];
    [query orderByAscending:@"time"];
    return query;
}

- (NSString *)timeUntilDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents* components = [calendar components:(NSHourCalendarUnit|NSMinuteCalendarUnit) fromDate:now toDate:date options:0] ;
    NSString *timeUntilDate = [[NSString alloc] init];
    if (components.hour > 1) {
        timeUntilDate = [NSString stringWithFormat:@"In %ld hours", (long)components.hour];
    } else if (components.hour <= 1 && components.hour > 0) {
        timeUntilDate = [NSString stringWithFormat:@"In %ld hour and %ld minutes", (long)components.hour, (long)components.minute];
    } else if (components.minute > 0) {
        NSString *postfix = (components.minute > 1) ? @"minutes" : @"minute";
        timeUntilDate = [NSString stringWithFormat:@"In %ld %@", (long)components.minute, postfix];
    }
    else {
        timeUntilDate = @"Now";
    }
    return timeUntilDate;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"View Post"]) {
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            UITableViewCell *cell = (UITableViewCell *)sender;
            PFObject *object = [self objectAtIndexPath:[self.tableView indexPathForCell:cell]];
            if ([object isKindOfClass:[Post class]]) {
                Post *post = (Post *)object;
                [segue.destinationViewController performSelector:@selector(setPost:) withObject:post];
                [segue.destinationViewController setTitle:post.location];
            }
        }
    }
}

// Table View Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Post";
    
    PostTableViewCell *cell = (PostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([object isKindOfClass:[Post class]]) {
        Post *post = (Post *)object;
        NSString *postfix = ([post.swipeCount intValue] > 1) ? @"swipes" : @"swipe";
        NSString *postfix2 = ([post.swipeCount intValue] > 1) ? @" per swipe" : @"";
        cell.mainLabel.text = [NSString stringWithFormat:@"%@ %@ at $%@%@", post.swipeCount, postfix, post.askingPrice, postfix2];
        cell.detailLabel.text = [self timeUntilDate:post.time];
        cell.profilePic.profileID = post.user.facebookID;
    }
    
    return cell;
}

//Change the Height of the Cell [Default is 44]:
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 60 ;
}


//utility function
- (Post *)postAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.objects count]) {
        PFObject *obj = [self objectAtIndexPath:indexPath];
        if ([obj isKindOfClass:[Post class]]) {
            Post *post = (Post *)obj;
            return post;
        }
    }
    return nil;
}

- (void)refreshLocation
{
    self.parseClassName = [Utils getPostClassName];
}


@end
