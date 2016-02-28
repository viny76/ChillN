//
//  ViewController.m
//  ChillN
//
//  Created by Vincent Jardel on 26/03/2015.
//  Copyright (c) 2015 ChillCompany. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCell.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "AddEventsViewController.h"
#import "EventDetailViewController.h"
#import <AddressBook/AddressBook.h>

@interface HomeViewController() <UIScrollViewDelegate>
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    PFQuery *friendsQuery = [self.friendsRelation query];
    [friendsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        } else {
            self.friends = objects;
        }
    }];
    
    //reloadEvents
    self.currentUser = [PFUser currentUser];
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friends"];
    NSLog(@"%@", self.currentUser);
    NSLog(@"%@", self.friendsRelation);
    
    refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Last Refresh: 5min"];
    [refreshControl beginRefreshing];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(reloadEvents) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [self.tableView.backgroundView setContentMode:UIViewContentModeScaleAspectFill];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    if (!self.currentUser.objectId) {
        [PFUser logOut];
        AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
        
        UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
        appDelegateTemp.window.rootViewController = navigation;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"logged"];
    } else {
        [self reloadEvents];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mutableEvents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"parallaxCell";
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", [self.mutableEvents objectAtIndex:indexPath.row ]];
    cell.subtitleLabel.text = [NSString stringWithFormat:@"%@", [self.mutableAuthor objectAtIndex:indexPath.row ]];
    cell.yesButton.tag = indexPath.row;
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Get visible cells on table view.
    NSArray *visibleCells = [self.tableView visibleCells];
    for (HomeCell *cell in visibleCells) {
        [cell cellOnTableView:self.tableView didScrollOnView:self.view];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.selectedEvent = [self.events objectAtIndex:indexPath.row];
}

- (IBAction)yesButton:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Events"];
    [query whereKey:@"objectId" equalTo:[[self.events objectAtIndex:[sender tag]] valueForKey:@"objectId"]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            if ([[object valueForKey:@"acceptedUser"] containsObject:[self.currentUser objectId]]) {
                NSLog(@"Already added");
            } else {
                if ([[object valueForKey:@"refusedUser"] containsObject:[self.currentUser objectId]]) {
                    [object addObject:[self.currentUser objectId] forKey:@"acceptedUser"];
                    [object removeObject:[self.currentUser objectId] forKey:@"refusedUser"];
                } else {
                    [object addObject:[self.currentUser objectId] forKey:@"acceptedUser"];
                }
            }
            
            [object saveInBackground];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (IBAction)noButton:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Events"];
    [query whereKey:@"objectId" equalTo:[[self.events objectAtIndex:[sender tag]] valueForKey:@"objectId"]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            if ([[object valueForKey:@"refusedUser"] containsObject:[self.currentUser objectId]]) {
                NSLog(@"Already added");
            } else {
                if ([[object valueForKey:@"acceptedUser"] containsObject:[self.currentUser objectId]]) {
                    [object removeObject:[self.currentUser objectId] forKey:@"acceptedUser"];
                    [object addObject:[self.currentUser objectId] forKey:@"refusedUser"];
                } else {
                    [object addObject:[self.currentUser objectId] forKey:@"refusedUser"];
                }
            }
            
            [object saveInBackground];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addEvents"]) {
        AddEventsViewController *viewController = (AddEventsViewController *)segue.destinationViewController;
        viewController.friendsList = self.friends;
    } else if ([segue.identifier isEqualToString:@"detailEvent"]) {
        EventDetailViewController *viewController = (EventDetailViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        viewController.event = [self.events objectAtIndex:indexPath.row];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    PFUser *user = [[self.events valueForKey:@"fromUserId"] objectAtIndex:indexPath.row];
    if ([user  isEqual: [[PFUser currentUser] objectId]]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        PFObject *object = [self.events objectAtIndex:indexPath.row];
        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self.mutableEvents removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self reloadEvents];
            } else {
                NSLog(@"error");
            }
        }];
    }
}

- (void)reloadEvents {
    PFQuery *eventsQuery = [PFQuery queryWithClassName:@"Events"];
    [eventsQuery whereKey:@"toUserId" equalTo:[[PFUser currentUser] objectId]];
    [eventsQuery orderByAscending:@"date"];
    if (eventsQuery) {
        [eventsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            } else {
                // We found messages!
                self.events = objects;
                self.eventsTitle = [self.events valueForKey:@"question"];
                self.mutableEvents = [[NSMutableArray alloc] initWithArray:self.eventsTitle];
                self.author = [self.events valueForKey:@"fromUser"];
                self.mutableAuthor = [[NSMutableArray alloc] initWithArray:self.author];
                [refreshControl endRefreshing];
                [self.tableView reloadData];
            }
        }];
    }
}

@end