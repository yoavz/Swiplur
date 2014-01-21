//
//  UCLAPost.h
//  Swipe
//
//  Created by Yoav on 11/5/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

#import "Post.h"
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>

@interface UCLAPost : Post

typedef enum {
    UCLA_ANY,
    DE_NEVE,
    COVELL,
    BRUIN_PLATE,
    FEAST,
    HEDRICK,
    BRUIN_CAFE,
    RENDEZVOUS,
    CAFE_1919,
    UCLA_locationsCount //used to iterate over enum
} UCLALocation;

//returns an array of string locations
+ (NSArray *)locationStrings;

//returns a coordinate point of string location
//if cannot find location in locations, return UCLA in general
- (CLLocationCoordinate2D)coordinate;

//returns region for a string location
//if cannot find location in locations, return UCLA in general
- (MKCoordinateRegion)region;

@end
