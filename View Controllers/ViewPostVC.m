//
//  ViewPostVC.m
//  Swipe
//
//  Created by Yoav on 11/6/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//
#import <MapKit/MapKit.h>

#import "ViewPostVC.h"
#import "Conversation.h"
#import "ContactVC.h"

@interface ViewPostVC ()

@property (strong, nonatomic) Post* post;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *buyerProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *buyerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *postPriceLabel;

@end

@implementation ViewPostVC

- (void)setPost:(Post *)post
{
    _post = post;
    [self reloadPost];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.post.location;
    [self reloadPost];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.mapView setRegion:[self.post region] animated:NO];
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = [self.post coordinate];
    NSString *postfix = [self.post.swipeCount intValue] > 1 ? @"swipes" : @"swipe" ;
    point.title = [NSString stringWithFormat:@"%@ %@", self.post.swipeCount, postfix];
    point.subtitle = [NSString stringWithFormat:@"$%@ per swipe", self.post.askingPrice];
    [self.mapView addAnnotation:point];
    [self.mapView setSelectedAnnotations:[NSArray arrayWithObject:point]];
    
}

- (NSString *)formatTime:(NSDate *)time {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeStyle:NSDateFormatterShortStyle];
    return [format stringFromDate:time];
}

- (void)reloadPost
{
    if (self.post) {
        NSString *postfix = [self.post.swipeCount intValue] > 1 ? @"swipes" : @"swipe" ;
        NSString *time = [self formatTime:self.post.time];
        
        self.buyerProfilePic.profileID = self.post.user.facebookID ;
        self.buyerNameLabel.text = self.post.user.fullName ;
        self.postInfoLabel.text = [NSString stringWithFormat:@"%@ %@ at %@", self.post.swipeCount, postfix, time];
        self.postPriceLabel.text = [NSString stringWithFormat:@"$%@ per swipe", self.post.askingPrice];
        
        [[self contactVC] setUser:self.post.user];
        [[self contactVC] setPost:self.post];
    }
}

- (ContactVC *)contactVC
{
    if ([self.childViewControllers count] > 0) {
        return (ContactVC *)[self.childViewControllers objectAtIndex:0];
    }
    return nil;
}

- (void)sendMessageTo:(User *)user
{
    if ([user isEqual:[User currentUser]]) {
        NSLog(@"cannot message own user");
        return;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:[Conversation parseClassName]];
    [query includeKey:@"user"];
    [query whereKey:@"participants" containsAllObjectsInArray:@[[User currentUser], user]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object && [object isKindOfClass:[Conversation class]]) {
            //if found the conversation, for now do nothing
            NSLog(@"found convo between %@ and %@", [[User currentUser] fullName], [user fullName]);
        } else {
            Conversation *newConvo = [[Conversation alloc] init];
            newConvo.participants = @[[User currentUser], user];
            newConvo.messages = [[NSMutableArray alloc] init];
            NSLog(@"created convo between %@ and %@", [[User currentUser] fullName], [user fullName]);
            [newConvo saveInBackground];
        }
    }];
}

@end
