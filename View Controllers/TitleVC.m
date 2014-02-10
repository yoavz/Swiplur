//
//  TitleVC.m
//  Swiplur
//
//  Created by Yoav on 12/10/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

#import "TitleVC.h"
#import "User.h"

#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TitleVC ()
@property (weak, nonatomic) IBOutlet UIButton *fbLoginButton;
@end

@implementation TitleVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fbLoginButton.layer.borderColor = self.fbLoginButton.tintColor.CGColor;
    self.fbLoginButton.layer.cornerRadius = 5.0f;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    User *currentUser = [User currentUser] ;
    //if user is already logged in, go to main view
    if (currentUser) {
        [self updateCurrentUserData];
        [self pushToMainView];
    }

}

- (IBAction)fbLogin:(id)sender {
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:nil block:^(PFUser *user, NSError *error) {
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"%@", error);
            }
        } else {
            [self updateCurrentUserData];
            [self pushToMainView];
        }
    }];
}

- (void)showAlertViewWithMessage:(id)msg
{
    UIAlertView *err =[[UIAlertView alloc] initWithTitle:@"Facebook Error"
                                                 message:[NSString stringWithFormat:@"%@", msg]
                                                delegate:self
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
    [err show];
}

- (void)pushToMainView
{
    UIStoryboard *storyboard = self.storyboard;
    SWRevealViewController *sv = [storyboard instantiateViewControllerWithIdentifier:@"rvc"];
    [self presentViewController:sv animated:YES completion:NULL];
}

- (void)updateCurrentUserData
{
    FBRequest *request = [FBRequest requestForMe];
    
    self.fbLoginButton.enabled = NO;
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            NSString *location = userData[@"location"][@"name"];
            
            User *currentUser = [User currentUser];
            currentUser.fullName = name;
            currentUser.imageURL = [pictureURL absoluteString];
            currentUser.facebookID = facebookID;
            currentUser.locationName = location;
            [currentUser saveInBackground];
        }
        self.fbLoginButton.enabled = YES;
    }];
}

@end
