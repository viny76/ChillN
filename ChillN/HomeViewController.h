//
//  ViewController.h
//  ChillN
//
//  Created by Vincent Jardel on 26/03/2015.
//  Copyright (c) 2015 ChillCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface HomeViewController : UIViewController {
    UIRefreshControl *refreshControl;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *events;
@property (strong, nonatomic) NSArray *eventsTitle;
@property (strong, nonatomic) NSMutableArray *mutableEvents;
@property (strong, nonatomic) NSArray *author;
@property (strong, nonatomic) NSMutableArray *mutableAuthor;
@property(nonatomic, strong) PFUser *currentUser;
@property(nonatomic,strong) PFRelation *friendsRelation;
@property(nonatomic,strong) PFObject *selectedEvent;
@property(nonatomic, strong) NSArray *friends;

@end