//
//  UserDefaults.m
//  Swipe
//
//  Created by Yoav on 11/5/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

#import "Utils.h"
#import "UCLABuyingPost.h"
#import "DavisBuyingPost.h"

@interface Utils()

#define LOCATION @"location"
#define TEXT_COUNTER @"text_counter"
#define VEF_KEY_SENT @"vefkeysent"


@end

@implementation Utils

/*********************/
/* GENERAL SETTINGS  */
/*********************/

+ (Location)getLocation
{
    return DAVIS;
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    long loc = [defaults integerForKey:LOCATION];
//    return (Location)loc;
}

+ (Class)getPostClass
{
    Location location = [self getLocation];
    if (location == LOS_ANGELES) {
        return [UCLABuyingPost class];
    } else if (location == DAVIS) {
        return [DavisBuyingPost class];
    } else {
        return [UCLABuyingPost class];
    }
}

+ (NSString *)getPostClassName
{
    return [[self getPostClass] parseClassName];
}

+ (void)setLocation:(Location)location
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(location) forKey:LOCATION];
    [defaults synchronize];
}

+ (BOOL)hasLocation
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([[[defaults dictionaryRepresentation] allKeys] containsObject:LOCATION]){
        return YES;
    }
    return NO;
}



/*****************/
/* TWILIO STUFF  */
/*****************/


+ (BOOL)verificationKeySent {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:VEF_KEY_SENT];
}

+ (void)setVerificationKeySent:(BOOL)b {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:b forKey:VEF_KEY_SENT];
    [defaults synchronize];
}


+ (void)incrementTextCounter
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger textCounter = [self textCounter];
    if (!textCounter)
        textCounter = 0;
    textCounter++;
    [defaults setInteger:textCounter forKey:TEXT_COUNTER];
    [defaults synchronize];
}

+ (NSInteger)textCounter
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:TEXT_COUNTER];
}


/*************/
/* UTILITIES */
/*************/


+ (void)debug
{
    NSLog(@"Phone Number: %@", [self getPhoneNumber]);
    NSLog(@"Text counter: %lu", (long)[self textCounter]);
}


+ (Location)determineLocationForLatitude:(NSNumber *)latitude andLongitude:(NSNumber *)longitude
{
    return DAVIS;
    
//    CLLocation *userLocation = [[CLLocation alloc]initWithLatitude:[latitude doubleValue] longitude:[latitude doubleValue]];
//    CLLocation *UCLA = [[CLLocation alloc]initWithLatitude:34.06892 longitude:-118.44518];
//    CLLocation *UCDavis = [[CLLocation alloc]initWithLatitude:38.539271 longitude:-121.760276];
//    
//    return ([userLocation distanceFromLocation:UCLA] <= [userLocation distanceFromLocation:UCDavis] ? LOS_ANGELES : DAVIS) ;
}
@end
