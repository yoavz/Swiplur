//
//  Twilio.m
//  Swipe
//
//  Created by Yoav on 11/18/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

#import "Twilio.h"
#import "AFNetworking.h"

#define AUTH_KEY @"ccc3cc46f59518c3a1246eb1eca298f2"
#define SID @"ACd1ea0bdd4d126603542d45ece1467249"


@implementation Twilio

+ (void)sendVerificationText:(NSString *)number withKey:(NSString *)key
{
    NSString *swiplurNumber = @"+16503185929" ;
    NSString *outgoingNumber = [NSString stringWithFormat:@"+1%@", number];
    NSString *body = [NSString stringWithFormat:@"Your swiplur 6-digit identification ID is %@", key];
    NSString *twilioBaseURL = [NSString stringWithFormat:@"https://%@:%@@api.twilio.com/2010-04-01/Accounts/%@/Messages.json", SID, AUTH_KEY, SID];
    
    //for debugging
    NSString *device = [UIDevice currentDevice].model;
    if ([device isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"Found device type: %@", device);
        NSLog(@"Debug: sent %@ to %@", key, outgoingNumber);
    } else {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params = @{@"From": swiplurNumber,
                                 @"To": outgoingNumber,
                                 @"Body": body};
        [manager POST:twilioBaseURL parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  //NSLog(@"Response: %@", responseObject);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  //NSLog(@"Error: %@", error);
              }];
    }
}

+ (NSString *)generateKey
{
    //NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSString *numbers = @"0123456789";
    NSMutableString *s = [NSMutableString stringWithCapacity:VERIFICATION_KEY_LENGTH];
    for (int i=0; i<VERIFICATION_KEY_LENGTH; i++) {
        [s appendFormat:@"%C", [numbers characterAtIndex: arc4random() % [numbers length]]];
    }
    return [NSString stringWithString:s];
}

@end
