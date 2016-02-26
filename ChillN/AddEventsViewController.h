//
//  ViewController.h
//  ChillN
//
//  Created by Vincent Jardel on 26/03/2015.
//  Copyright (c) 2015 ChillCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "HSDatePickerViewController.h"
#import "AppDelegate.h"
@class SevenSwitch;

@interface AddEventsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *questionTextField;
@property (strong, nonatomic) IBOutlet UIButton *dateButton;
@property (strong, nonatomic) IBOutlet SevenSwitch *mySwitch;
@property (strong, nonatomic) IBOutlet UIButton *selectFriendButton;

@property (strong, nonatomic) NSString *questionString;
@property (strong, nonatomic) NSArray *friendsList;
@property (strong, nonatomic) NSMutableArray *recipientId;
@property (strong, nonatomic) NSMutableArray *recipientUser;
@property (strong, nonatomic) NSString *fromUserId;
@property (strong, nonatomic) NSString *fromUser;
@property (strong, nonatomic) NSString *toUserId;
@property (strong, nonatomic) NSString *toUser;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) PFRelation *friendsRelation;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *friendHeight;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *friendView;

@end