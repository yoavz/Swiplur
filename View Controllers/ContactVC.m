//
//  ContactVC.m
//  Swiplur
//
//  Created by Yoav on 12/21/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

#import "ContactVC.h"
#import "User.h"
#import "Post.h"

@interface ContactVC ()

@property (retain, nonatomic) User *user ;
@property (retain, nonatomic) Post *post ;

@property (weak, nonatomic) IBOutlet UIButton *textButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;

@end

@implementation ContactVC

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
	// Do any additional setup after loading the view.
}

- (void)refresh
{
    if (self.user.isVerified) {
        self.textButton.hidden = NO;
        self.phoneButton.hidden = NO;
    } else {
        self.textButton.hidden = YES;
        self.phoneButton.hidden = YES;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController performSelector:@selector(setUser:) withObject:self.user];
    if (self.post)
        [segue.destinationViewController performSelector:@selector(setPost:) withObject:self.post];
    
}

@end
