//
//  EditFriendsViewController.h
//  Mindle
//
//  Created by Vincent Jardel on 21/05/2014.
//  Copyright (c) 2014 Jardel Vincent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "NBPhoneNumberUtil.h"
#import "NBAsYouTypeFormatter.h"
#import "MBProgressHUD.h"
#import "Person.h"
#import "AppDelegate.h"

@interface EditFriendsViewController : UITableViewController <UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UISearchResultsUpdating> {
    NBPhoneNumberUtil *phoneUtil;
}

@property (nonatomic, strong) IBOutlet UISegmentedControl *segment;
@property (nonatomic, strong) NSArray *allUsers;
@property (nonatomic, strong) PFRelation *friendsRelation;
@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSArray *friendRequests;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSString *selectedObjectId;
@property (nonatomic, strong) NSMutableArray *friendRequestsWaiting;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSArray *result;
@property (nonatomic, strong) PFUser *selectedUser;
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, readwrite, copy) NSArray *sectionedPersonName;

-(BOOL)isFriend:(PFUser*)user;

@end
