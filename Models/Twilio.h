//
//  Twilio.h
//  Swipe
//
//  Created by Yoav on 11/18/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

#import <Foundation/Foundation.h>
#define VERIFICATION_KEY_LENGTH 6

@interface Twilio : NSObject

+ (void)sendVerificationText:(NSString *)number withKey:(NSString *)key ;
+ (NSString *)generateKey ;
@end
