//
//  PhoneNumberVC.m
//  Swiplur
//
//  Created by Yoav on 12/23/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

#import "PhoneNumberVC.h"
#import "User.h"
#import "Utils.h"
#import "Twilio.h"

#import "MBProgressHUD.h"

@interface PhoneNumberVC ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UIButton *phoneNumberButton;

@property (weak, nonatomic) IBOutlet UITextField *verificationKeyField;
@property (weak, nonatomic) IBOutlet UILabel *verificationKeyTitle;
@property (weak, nonatomic) IBOutlet UILabel *verificationKeyDetail;
@property (weak, nonatomic) IBOutlet UIButton *verificationKeyButton;


@property CGFloat animatedDistance;

@end

@implementation PhoneNumberVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refresh];
    
    [self.phoneNumberField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refresh];
}

- (void)refresh
{
    [self refreshButtons];
}

- (void)refreshButtons
{
    NSLog(@"Verification Key Sent?: %d", [Utils verificationKeySent]);
    if ([self.phoneNumberField.text length] == 10) {
        self.phoneNumberButton.enabled = YES;
    }
    else {
        self.phoneNumberButton.enabled = NO;
    }
    
    if ([Utils verificationKeySent]) {
        self.verificationKeyButton.hidden = NO;
        self.verificationKeyDetail.hidden = NO;
        self.verificationKeyField.hidden = NO;
        self.verificationKeyTitle.hidden = NO;
    } else {
        self.verificationKeyButton.hidden = YES;
        self.verificationKeyDetail.hidden = YES;
        self.verificationKeyField.hidden = YES;
        self.verificationKeyTitle.hidden = YES;
    }
}

/**************/
/* SEND TEXT  */
/**************/

- (IBAction)phoneNumberSubmit:(id)sender {
    User *current = [User currentUser];
    
    if ([self.phoneNumberField.text length] != 10)
        return;
    
    [self.phoneNumberField resignFirstResponder];
    
    NSString *key = [Twilio generateKey];
    
    [Twilio sendVerificationText:self.phoneNumberField.text withKey:key];
    current.verificationKey = key;
    current.phoneNumber = self.phoneNumberField.text;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Sending";
    [current saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //show verification key sent
            [Utils setVerificationKeySent:YES];
            
            [hud hide:YES];
            UIAlertView *success = [self messageWithTitle:@"Success" andMessage:[NSString stringWithFormat:@"A 6 digit verification key has been sent to %@.", self.phoneNumberField.text]];
            [success show];
            
            [self refresh];
        } else {
            [hud hide:YES];
            UIAlertView *error = [self messageWithTitle:@"Network Error" andMessage:@"Could not connect to the network"];
            [error show];
        }
    }];
    
}

- (IBAction)verificationKeySubmit:(id)sender {
    User *current = [User currentUser];
    
    if ([self.verificationKeyField.text isEqualToString:current.verificationKey]) {
        [Utils setVerificationKeySent:NO];
        current.isVerified = YES;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Verifying";
        [current saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"Phone Number Verified";
                [hud hide:YES afterDelay:1];
                
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [hud hide:YES];
                UIAlertView *error = [self messageWithTitle:@"Network Error" andMessage:@"Could not connect to the network"];
                [error show];
            }
        }];

    } else {
        UIAlertView *error = [self messageWithTitle:@"Incorrect" andMessage:@"The verification key entered was incorrect"];
        [error show];
    }
}

- (UIAlertView *)messageWithTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *error = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    return error;
}


/***********************/
/* TEXT FIELD DELEGATE */
/***********************/

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    [self refreshButtons];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.phoneNumberField resignFirstResponder];
    [self.verificationKeyField resignFirstResponder];
}


@end

/*
 //constants for sliding textfield up
 static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
 static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
 static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
 static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
 static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
 
 - (void)textFieldDidBeginEditing:(UITextField *)textField
 {
 CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
 CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
 
 CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
 CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
 CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
 CGFloat heightFraction = numerator / denominator;
 
 if (heightFraction < 0.0)
 heightFraction = 0.0;
 else if (heightFraction > 1.0)
 heightFraction = 1.0;
 
 UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
 if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
 self.animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
 else
 self.animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
 
 CGRect viewFrame = self.view.frame;
 viewFrame.origin.y -= self.animatedDistance;
 
 [UIView beginAnimations:nil context:NULL];
 [UIView setAnimationBeginsFromCurrentState:YES];
 [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
 
 [self.view setFrame:viewFrame];
 
 [UIView commitAnimations];
 }
 
 - (void)textFieldDidEndEditing:(UITextField *)textField
 {
 CGRect viewFrame = self.view.frame;
 viewFrame.origin.y += self.animatedDistance;
 
 [UIView beginAnimations:nil context:NULL];
 [UIView setAnimationBeginsFromCurrentState:YES];
 [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
 
 [self.view setFrame:viewFrame];
 
 [UIView commitAnimations];
 }
 */
