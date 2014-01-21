//
//  UCLAPost.m
//  Swipe
//
//  Created by Yoav on 11/5/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

#import "UCLAPost.h"

@implementation UCLAPost

+ (NSString *)locationString:(UCLALocation)location
{
    switch (location)
    {
        case DE_NEVE:
            return @"De Neve";
        case COVELL:
            return @"Covell";
        case BRUIN_PLATE:
            return @"Bruin Plate";
        case FEAST:
            return @"Feast";
        case HEDRICK:
            return @"Hedrick";
        case BRUIN_CAFE:
            return @"Bruin Café";
        case RENDEZVOUS:
            return @"Rendezvous";
        case CAFE_1919:
            return @"Café 1919";
        default:
            return @"Any";
    }
}

+ (NSArray *)locationStrings {
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    for (int i=0; i<UCLA_locationsCount; i++) {
        [ret addObject:[self locationString:(UCLALocation)i]];
    }
    return [NSArray arrayWithArray:ret];
}

- (CLLocationCoordinate2D)coordinate
{
    NSString *location  = self.location;
    if ([location isEqualToString:[UCLAPost locationString:DE_NEVE]]) {
        return CLLocationCoordinate2DMake(34.07051, -118.45012);
    }
    else if ([location isEqualToString:[UCLAPost locationString:COVELL]]) {
        return CLLocationCoordinate2DMake(34.07286, -118.45007);
    }
    else if ([location isEqualToString:[UCLAPost locationString:BRUIN_PLATE]]) {
        return CLLocationCoordinate2DMake(34.07204, -118.44976);
    }
    else if ([location isEqualToString:[UCLAPost locationString:FEAST]]) {
        return CLLocationCoordinate2DMake(34.07180, -118.45136);
    }
    else if ([location isEqualToString:[UCLAPost locationString:HEDRICK]]) {
        return CLLocationCoordinate2DMake(34.07321, -118.45216);
    }
    else if ([location isEqualToString:[UCLAPost locationString:BRUIN_CAFE]]) {
        return CLLocationCoordinate2DMake(34.07266,-118.450028);
    }
    else if ([location isEqualToString:[UCLAPost locationString:RENDEZVOUS]]) {
        return CLLocationCoordinate2DMake(34.072624,-118.451836);
    }
    else if ([location isEqualToString:[UCLAPost locationString:CAFE_1919]]) {
        return CLLocationCoordinate2DMake(34.072751,-118.45083);
    }
    else {
        //general UCLA
        return CLLocationCoordinate2DMake(34.06892, -118.44518);
    }
}

- (MKCoordinateRegion)region;
{
    NSString *location  = self.location;
    if ([location isEqualToString:[UCLAPost locationString:UCLA_ANY]]) {
        return MKCoordinateRegionMakeWithDistance([self coordinate], 1500, 1500);
    }
    else {
        return MKCoordinateRegionMakeWithDistance([self coordinate], 600, 600);
    }
}


@end
