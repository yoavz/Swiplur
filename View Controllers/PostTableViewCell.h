//
//  PostTableViewCell.h
//  Swiplur
//
//  Created by Yoav on 12/17/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface PostTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePic;

@end
