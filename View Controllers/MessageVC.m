//
//  MessageVC.m
//  Swiplur
//
//  Created by Yoav on 12/21/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

#import "MessageVC.h"
#import "ContactVC.h"

@interface MessageVC ()

@property (nonatomic, retain) Message *message ;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *senderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePic;

@end

@implementation MessageVC

- (void)setMessage:(Message *)message
{
    _message = message ;
    [self refresh];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refresh];
}

- (void)refresh
{
    self.senderNameLabel.text = self.message.sender.fullName;
    self.createdAtLabel.text = [self formatMessageDate:self.message.createdAt];
    self.profilePic.profileID = self.message.sender.facebookID ;
    self.textView.text = self.message.body;
    
    [[self contactVC] setUser:self.message.sender];
    if (self.message.post) {
        NSLog(@"Post found");
        [[self contactVC] setPost:self.message.post];
    }
}

- (NSString *)formatMessageDate:(NSDate *)time {
    NSDateFormatter *fmtTime = [[NSDateFormatter alloc] init];
    [fmtTime setTimeStyle:NSDateFormatterShortStyle];
    NSDateFormatter *fmtDate = [[NSDateFormatter alloc] init];
    [fmtDate setDateStyle:NSDateFormatterMediumStyle];
    return [NSString stringWithFormat:@"%@ %@", [fmtTime stringFromDate:time], [fmtDate stringFromDate:time]];
}

- (ContactVC *)contactVC
{
    if ([self.childViewControllers count] > 0) {
        return (ContactVC *)[self.childViewControllers objectAtIndex:0];
    }
    return nil;
}

@end
