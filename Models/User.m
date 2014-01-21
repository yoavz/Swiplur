//
//  User.m
//  Swiplur
//
//  Created by Yoav on 12/10/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

#import "User.h"
#import <Parse/Parse.h>
#import "Utils.h"

@implementation User

@dynamic fullName;
@dynamic imageURL;
@dynamic facebookID;
@dynamic locationName;
@dynamic phoneNumber;
@dynamic verificationKey;
@dynamic isVerified;

- (void)resetNumberWithBlock:(void (^)(BOOL, NSError *))finished
{
    self.phoneNumber = NO;
    self.isVerified = NO;
    self.verificationKey = NO;
    [Utils setVerificationKeySent:NO];
    
    [self saveInBackgroundWithBlock:finished];
}

@end
