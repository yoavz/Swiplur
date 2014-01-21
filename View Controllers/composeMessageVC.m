//
//  composeMessageVC.m
//  Swiplur
//
//  Created by Yoav on 12/21/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

#import "ComposeMessageVC.h"
#import "User.h"
#import "Post.h"
#import "Message.h"

@interface ComposeMessageVC () <UITextViewDelegate>

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Post *post;

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@property (weak, nonatomic) IBOutlet UIButton *send;
@property (weak, nonatomic) IBOutlet UITextView *textInput;

@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *senderName;
@property (weak, nonatomic) IBOutlet UILabel *timeNow;

@end

@implementation ComposeMessageVC

- (void)setUser:(User *)user
{
    _user = user;
    [self refresh];
}

- (void)setPost:(Post *)post
{
    _post = post;
    [self refresh];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addBorders];

    //keyboard notifications
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    [self refresh];
    [self.textInput becomeFirstResponder];
}

- (void)addBorders
{
    //add border to buttons
    self.cancel.layer.borderWidth=2.0f;
    self.cancel.layer.borderColor=[[UIColor whiteColor] CGColor];
    self.send.layer.borderWidth=2.0f;
    self.send.layer.borderColor=[[UIColor whiteColor] CGColor];
    
    //textview
    self.textInput.layer.borderWidth=2.0f;
    self.textInput.layer.borderColor=[[UIColor blackColor] CGColor];
}

- (void)refresh
{
    self.profilePic.profileID = self.user.facebookID;
    self.senderName.text = self.user.fullName;
    self.timeNow.text = [self formatMessageDate:[[NSDate alloc] init]];
}

- (NSString *)formatMessageDate:(NSDate *)time {
    NSDateFormatter *fmtTime = [[NSDateFormatter alloc] init];
    [fmtTime setTimeStyle:NSDateFormatterShortStyle];
    NSDateFormatter *fmtDate = [[NSDateFormatter alloc] init];
    [fmtDate setDateStyle:NSDateFormatterMediumStyle];
    return [NSString stringWithFormat:@"%@ %@", [fmtTime stringFromDate:time], [fmtDate stringFromDate:time]];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)send:(id)sender {
    [self sendMessage];
}

/************/
/* KEYBOARD */
/************/

//- (void)keyboardDidShow:(NSNotification *)notification
//{
//    // Get the size of the keyboard.
//    NSDictionary* info = [notification userInfo];
//    NSValue* aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
//    CGSize keyboardSize = [aValue CGRectValue].size;
//    
//    [self.buttonView setFrame:CGRectMake(0,-keyboardSize.height,320,460)];
//    
//}
//
//-(void)keyboardDidHide:(NSNotification *)notification
//{
//    [self.buttonView setFrame:CGRectMake(0,0,320,460)];
//}

/***********/
/* MESSAGE */
/***********/

- (void)sendMessage
{
    Message *newMessage = [[Message alloc] init];
    newMessage.body = self.textInput.text ;
    newMessage.sender = [User currentUser];
    newMessage.recipient = self.user;
    if (self.post)
        newMessage.post = self.post;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Sending";
    [newMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView = imageView;
            hud.labelText = @"Success";
            [self performSelector:@selector(hideHUDAndDismiss) withObject:nil afterDelay:0.75];
        } else {
            hud.labelText = @"Error";
            NSLog(@"%@", error);
            [self performSelector:@selector(hideHUD) withObject:nil afterDelay:0.75];
        }
    }];
}

- (void)hideHUDAndDismiss
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)hideHUD
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
