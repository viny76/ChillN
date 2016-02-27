//
//  EditFriendsViewController.h
//  Mindle
//
//  Created by Vincent Jardel on 21/05/2014.
//  Copyright (c) 2014 Jardel Vincent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "NBPhoneNumberUtil.h"
#import "NBAsYouTypeFormatter.h"
#import "MBProgressHUD.h"

@interface EditFriendsViewController : UITableViewController <UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UISearchResultsUpdating> {
    NBPhoneNumberUtil *phoneUtil;
}

@property (nonatomic, strong) NSArray *allUsers;
@property (nonatomic, strong) PFRelation *friendsRelation;
@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSArray *friendRequests;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSString *selectedObjectId;
@property (nonatomic, strong) NSMutableArray *friendRequestsWaiting;
@property(readwrite, copy, nonatomic) NSArray *sectionedPersonName;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (strong, nonatomic) NSArray *result;
@property (nonatomic, strong) PFUser *selectedUser;
@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) UISearchController *searchController;

-(BOOL)isFriend:(PFUser*)user;

@end
