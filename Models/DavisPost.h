//
//  DavisPost.h
//  Swiplur
//
//  Created by Yoav on 11/25/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

#import "Post.h"

@interface DavisPost : Post

typedef enum {
    DAVIS_ANY,
    SEGUNDO,
    TERCERO,
    CUARTO,
    DAVIS_locationsCount //used to iterate over enum
} DavisLocation;

//returns an array of string locations
+ (NSArray *)locationStrings;

//returns a coordinate point of string location
//if cannot find location in locations, return UCLA in general
- (CLLocationCoordinate2D)coordinate;

//returns region for a string location
//if cannot find location in locations, return UCLA in general
- (MKCoordinateRegion)region;

@end
