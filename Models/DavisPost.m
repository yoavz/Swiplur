//
//  DavisPost.m
//  Swiplur
//
//  Created by Yoav on 11/25/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

#import "DavisPost.h"

@implementation DavisPost

+ (NSString *)locationString:(DavisLocation)location
{
    switch (location)
    {
        case TERCERO:
            return @"Tercero";
        case CUARTO:
            return @"Cuarto";
        case SEGUNDO:
            return @"Segundo";
        default:
            return @"Any";
    }
}

+ (NSArray *)locationStrings {
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    for (int i=0; i<DAVIS_locationsCount; i++) {
        [ret addObject:[self locationString:(DavisLocation)i]];
    }
    return [NSArray arrayWithArray:ret];
}

- (CLLocationCoordinate2D)coordinate
{
    NSString *location  = self.location;
    if ([location isEqualToString:[DavisPost locationString:TERCERO]]) {
        return CLLocationCoordinate2DMake(38.536312,-121.757479);
    }
    else if ([location isEqualToString:[DavisPost locationString:CUARTO]]) {
        return CLLocationCoordinate2DMake(38.547712,-121.76361);
    }
    else if ([location isEqualToString:[DavisPost locationString:SEGUNDO]]) {
        return CLLocationCoordinate2DMake(38.544096,-121.758097);
    }
    else {
        //general Davis
        return CLLocationCoordinate2DMake(38.539271,-121.760276);
    }
}

- (MKCoordinateRegion)region;
{
    NSString *location  = self.location;
    if ([location isEqualToString:[DavisPost locationString:DAVIS_ANY]]) {
        return MKCoordinateRegionMakeWithDistance([self coordinate], 1500, 1500);
    }
    else {
        return MKCoordinateRegionMakeWithDistance([self coordinate], 600, 600);
    }
}

@end
