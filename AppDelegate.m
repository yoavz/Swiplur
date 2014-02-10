//
//  AppDelegate.m
//  Swipe
//
//  Created by Yoav on 11/4/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

#import <Parse/Parse.h>

#import "AppDelegate.h"
#import "UCLABuyingPost.h"
#import "DavisBuyingPost.h"
#import "Conversation.h"
#import "Message.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBLoginView class];
    [FBProfilePictureView class];

    //register subclasses
    [UCLABuyingPost registerSubclass];
    [DavisBuyingPost registerSubclass];
    [User registerSubclass];
    [Message registerSubclass];
    
    [Parse setApplicationId:@"50eWKGJ0ShaSdXm5d4rtzVQBruFAnWddvLptyQno"
                  clientKey:@"VnddMuzskNgDCFr42grkYr8EGczimejPTjs4Onit"];
    
    //facebook integration
    [PFFacebookUtils initializeFacebook];
    
    //tracking?
    //[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    return YES;
}


/************************/
/* Facebook Integration */
/************************/

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}
@end
