//
//  ContactVC.h
//  Swiplur
//
//  Created by Yoav on 12/21/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "User.h"
#import "Post.h"

@interface ContactVC : UIViewController<MFMessageComposeViewControllerDelegate>

- (void)setUser:(User *)user ;
- (void)setPost:(Post *)post ;

@end
