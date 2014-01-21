//
//  User.h
//  Swiplur
//
//  Created by Yoav on 12/10/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

@interface User : PFUser<PFSubclassing>

@property (strong, retain) NSString *fullName ;
@property (strong, retain) NSString *imageURL ;
@property (strong, retain) NSString *facebookID ;
@property (strong, retain) NSString *locationName ;
@property (strong, retain) NSString *phoneNumber ;
@property (strong, retain) NSString *verificationKey ;
@property BOOL isVerified ;

- (void)resetNumberWithBlock:(void (^)(BOOL succeeded, NSError *error))finished ;

@end
