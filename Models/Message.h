//
//  Message.h
//  Swiplur
//
//  Created by Yoav on 12/18/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"
#import "Post.h"

@interface Message : PFObject<PFSubclassing>

@property (retain) User *sender;
@property (retain) User *recipient;
@property (retain) NSString *body ;
@property (retain) Post *post ;

+ (NSString *)parseClassName ;

@end
