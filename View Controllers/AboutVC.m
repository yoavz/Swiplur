//
//  AboutVC.m
//  Swiplur
//
//  Created by Yoav on 2/9/14.
//  Copyright (c) 2014 Yoav Zimmerman. All rights reserved.
//

#import "AboutVC.h"
#import "SWRevealViewController.h"

@interface AboutVC ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;

@end

@implementation AboutVC



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer ];

}


@end
