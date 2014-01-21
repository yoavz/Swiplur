//
//  Post.h
//  Swipe
//
//  Created by Yoav on 11/5/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>

#import "User.h"

@interface Post : PFObject

@property (retain) NSNumber *swipeCount;
@property (retain) NSNumber *askingPrice;
@property (retain) NSString *location;
@property (retain) NSDate *time;

@property (retain) User *user;

//abstract functions
- (MKCoordinateRegion)region;
- (CLLocationCoordinate2D)coordinate;
+ (NSArray *)locationStrings;

@end
