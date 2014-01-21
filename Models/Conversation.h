//
//  Conversation.h
//  Swiplur
//
//  Created by Yoav on 12/18/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

#import <Parse/Parse.h>

@interface Conversation : PFObject<PFSubclassing>

@property (retain) NSArray *participants ;
@property (retain) NSMutableArray *messages ;

+ (NSString *)parseClassName;

@end
