//
//  UserDefaults.h
//  Swipe
//
//  Created by Yoav on 11/5/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

@interface Utils : NSObject

typedef enum {
    LOS_ANGELES,
    DAVIS
} Location;

//returns phone number saved in NSUserDefaults, or nil if phone number doesn't exist
+ (NSString *)getPhoneNumber;
+ (Location)getLocation;
+ (Class)getPostClass;
+ (NSString *)getPostClassName;

+ (void)setLocation:(Location)location;

//checks if a user has a phone number entered
//  -> not necessarily verified
+ (BOOL)hasLocation;

//text counter for controlling twilio usage
+ (void)incrementTextCounter;
+ (NSInteger)textCounter;

+ (BOOL)verificationKeySent;
+ (void)setVerificationKeySent:(BOOL)b;


//clear all data
+ (void)clear;
+ (void)debug;
+ (Location)determineLocationForLatitude:(NSNumber *)latitude andLongitude:(NSNumber *)longitude ;
@end
