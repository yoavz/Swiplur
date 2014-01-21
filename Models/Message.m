//
//  Message.m
//  Swiplur
//
//  Created by Yoav on 12/18/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

#import "Message.h"

@implementation Message

@dynamic recipient;
@dynamic sender;
@dynamic body;
@dynamic post;

+ (NSString *)parseClassName
{
    return @"Message";
}

@end
