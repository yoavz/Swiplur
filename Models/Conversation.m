//
//  Conversation.m
//  Swiplur
//
//  Created by Yoav on 12/18/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

#import "Conversation.h"

@implementation Conversation

@dynamic participants ;
@dynamic messages ;

+ (NSString *)parseClassName
{
    return @"Conversation";
}

@end
