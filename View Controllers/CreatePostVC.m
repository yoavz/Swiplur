//
//  CreateUCLASellingPost.m
//  Swipe
//
//  Created by Yoav on 11/5/13.
//  Copyright (c) 2013 Yoav Zimmerman. All rights reserved.
//

#import "CreatePostVC.h"
#import "UCLABuyingPost.h"
#import "Utils.h"
#import "ViewPostVC.h"

#import "MBProgressHUD.h"
#import "SWRevealViewController.h"

@interface CreatePostVC ()

@property (weak, nonatomic) IBOutlet UISlider *sliderOutlet;
@property (weak, nonatomic) IBOutlet UILabel *swipeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *askingPriceLabel;
@property (weak, nonatomic) IBOutlet UIStepper *askingPriceStepper;
@property (weak, nonatomic) IBOutlet UIPickerView *locationPicker;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property (weak, nonatomic) IBOutlet UILabel *absoluteTimeLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;

@property (strong, nonatomic) NSArray *locations;
@property (nonatomic) Class postType;

@end

@implementation CreatePostVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer ];
}

- (Class)postType {
    if (!_postType) {
        _postType = [Utils getPostClass];
    }
    return _postType;
}

- (NSArray *)locations {
    if (!_locations) {
        _locations = [self.postType locationStrings];
    }
    return _locations;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.locationPicker setDelegate:self];
    [self updateAbsoluteTime];
}

- (void)viewDidAppear:(BOOL)animated {
    [self refreshLocationPicker];
}

-(void)refreshLocationPicker
{
    _postType = [Utils getPostClass];
    _locations = [self.postType locationStrings];
    [self.locationPicker reloadAllComponents];
}

- (NSString *)getLocation {
    return [self.locations objectAtIndex:[self.locationPicker selectedRowInComponent:0]];
}

- (NSDate *)getTime {
    NSDate *now = [NSDate date];
    NSNumber *thirtyMinutes = [NSNumber numberWithInt:self.timeSlider.value];
    return [NSDate dateWithTimeInterval:(60 * 30 * [thirtyMinutes intValue]) sinceDate:now];
}

- (void)updateAbsoluteTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    self.absoluteTimeLabel.text = [formatter stringFromDate:[self getTime]];
}

- (IBAction)moveSlider:(id)sender {
    if ([sender isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)sender;
        NSNumber *approximation = [NSNumber numberWithInt:slider.value];
        NSString *postfix = [approximation isEqualToNumber:@1] ? @"swipe" : @"swipes" ;
        self.swipeCountLabel.text = [NSString stringWithFormat:@"%@ %@", approximation, postfix];
    }
}

- (IBAction)changePrice:(id)sender {
    if ([sender isKindOfClass:[UIStepper class]]) {
        UIStepper *control = (UIStepper *)sender;
        NSInteger amount = control.value;
        self.askingPriceLabel.text = [NSString stringWithFormat:@"$%li / swipe", (long)amount];
    }
}

- (IBAction)moveTimeSlider:(id)sender {
    if ([sender isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)sender;
        NSNumber *approximation = [NSNumber numberWithInt:slider.value];
        if ([approximation intValue] == 0) {
            self.timeLabel.text = @"Now";
        } else {
            NSString *time;
            if ([approximation intValue] % 2) {
                if ([approximation intValue] == 1) {
                    time = @"30 minutes";
                } else {
                    time = [NSString stringWithFormat:@"%d½ hours", [approximation intValue] / 2];
                }
            } else {
                if ([approximation intValue] == 2) {
                    time = @"1 hour";
                } else {
                    time = [NSString stringWithFormat:@"%d hours", [approximation intValue] / 2];
                }
            }
            self.timeLabel.text = [NSString stringWithFormat:@"%@ from now", time];
        }
        
        [self updateAbsoluteTime];
    }
}

/********/
/* POST */
/********/

//Check for phone number before you create the post
- (IBAction)tryCreatePost:(id)sender {
    if (![User currentUser]) {
        [self alertWithMessage:@"Account Error"];
    } else if (![[User currentUser] isVerified]) {
        [self alertWithMessage:@"You must verify a phone number before you can make a post!"];
    }
    else {
        [self createPost:sender];
    }
}


//Create the post now that you found a phone number
- (IBAction)createPost:(id)sender {
    Post *post = [self.postType object];

    //add the post information
    post.swipeCount = [NSNumber numberWithInt:self.sliderOutlet.value];
    post.askingPrice = [NSNumber numberWithDouble:self.askingPriceStepper.value];
    post.user = [User currentUser];
    post.location = [self getLocation];
    post.time = [self getTime];
    
    //disable post, navigation bar
    self.postButton.enabled = NO;
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Posting";
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.postButton.enabled = YES;
        self.navigationController.navigationBar.userInteractionEnabled = YES;
        if (succeeded) {
            [self goToPostVC:post];
        }
        if (!succeeded){
            [self alertWithMessage:@"Network Error. Please try again another time."];
        }
    }];
}

- (void)goToPostVC:(Post *)post
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewPostVC *vc = [sb instantiateViewControllerWithIdentifier:@"ViewPostVC"];
    [vc setPost:post];
    [self.navigationController pushViewController:vc animated:YES];
}

/*********/
/* ALERT */
/********/

- (void)alertWithMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

// UIPickerViewDelegate functions

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    return [self.locations count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    return [self.locations objectAtIndex:row];
}

@end
