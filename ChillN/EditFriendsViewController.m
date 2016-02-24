//
//  EditFriendsViewController.m
//
//  Created by Vincent Jardel on 20/05/2014.
//  Copyright (c) 2014 Jardel Vincent. All rights reserved.

#import "EditFriendsViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Person.h"
#import "MBProgressHUD.h"

@interface EditFriendsViewController ()
@end

@implementation EditFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentUser = [PFUser currentUser];
    self.allUsers = [[NSArray alloc] init];
    self.tableData = [[NSMutableArray alloc] init];
    self.searchResults = [[NSArray alloc] init];
    phoneUtil = [[NBPhoneNumberUtil alloc] init];
    
    self.friendRequestsWaiting = [NSMutableArray array];
    [self refreshWaitingFriend];
    
    [self getPersonOutOfAddressBook];
    
    [self refreshAllUsersAndLoadFriends];
    
    //  self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //UISearchController
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchBar.scopeButtonTitles = @[];
    self.definesPresentationContext = YES;
    [self.searchController.searchBar sizeToFit];
}

-(void)dealloc
{
    [self.searchController.view removeFromSuperview];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (self.segment.selectedSegmentIndex == 0)
    {
        return 1;
    }
    else if (self.segment.selectedSegmentIndex == 1)
    {
        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
    }
    else if (self.segment.selectedSegmentIndex == 2)
    {
        return 1;
    }
    
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection: (NSInteger)section
{
    if (self.segment.selectedSegmentIndex == 0)
    {
        return @"Friend List";
    }
    else if (self.segment.selectedSegmentIndex == 1)
    {
        BOOL showSection = [[self.sectionedPersonName objectAtIndex:section] count] != 0;
        //only show the section title if there are rows in the section
        return (showSection) ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
    }
    else if (self.segment.selectedSegmentIndex == 2)
    {
        return @"Pending Friends";
    }
    return nil;
}

- (IBAction) segmentedControlIndexChanged {
    if(self.segment.selectedSegmentIndex == 0)
    {
        [self loadFriends];
        
    }
    else if (self.segment.selectedSegmentIndex == 1)
    {
        [self loadFriends];
        
    }
    else if (self.segment.selectedSegmentIndex == 2)
    {
        [self refreshWaitingFriend];
    }
    
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(self.segment.selectedSegmentIndex == 0)
    {
    }
    else if (self.segment.selectedSegmentIndex == 1)
    {
        return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
    }
    else if (self.segment.selectedSegmentIndex == 2)
    {
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if (self.segment.selectedSegmentIndex == 0)
    {
        if (self.searchResults.count > 0)
        {
            return [self.searchResults count];
        }
        else
        {
            return [self.allUsers count];
        }
    }
    
    else if (self.segment.selectedSegmentIndex == 1)
    {
        return [[self.sectionedPersonName objectAtIndex:section] count];
    }
    else if (self.segment.selectedSegmentIndex == 2)
    {
        return [self.friendRequestsWaiting count];
    }
    
    return 0;
}


//        UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//        [accessoryView setImage:[UIImage imageNamed:@"circle_arrow_right.png"]];
//        [cell setAccessoryView:accessoryView];
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (self.segment.selectedSegmentIndex == 0)
    {
        NSArray *sourceData = (self.searchResults.count > 0 ? self.searchResults : self.allUsers);
        PFUser *selectedUser = [sourceData objectAtIndex:indexPath.row];
        NSString *name = [[sourceData objectAtIndex:indexPath.row] valueForKey:@"surname"];
        if ([self isFriend:selectedUser])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.text = name;
        cell.detailTextLabel.text = nil;
    }
    
    else if (self.segment.selectedSegmentIndex == 1)
    {
        //        cell.accessoryType = UITableViewCellAccessoryNone;
        Person *person = [[self.sectionedPersonName objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.textLabel.text = person.fullName;
        cell.detailTextLabel.text = nil;
        
        if ([[self.allUsers valueForKey:@"phone"] containsObject:person.number])
        {
            for (PFUser *user in self.allUsers)
            {
                if ([self isFriend:user])
                {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                else
                {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
            }
            // do found
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    else if (self.segment.selectedSegmentIndex == 2)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSString *name = [[self.friendRequestsWaiting objectAtIndex:indexPath.row] valueForKey:@"fromUsername"];
        cell.textLabel.text = name;
        cell.detailTextLabel.text = nil;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (self.segment.selectedSegmentIndex == 0)
    {
        self.tableView.userInteractionEnabled = NO;
        PFUser *selected = [self.allUsers objectAtIndex:indexPath.row];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
            // Already friend
        {
            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_check.png"]];
            self.hud.mode = MBProgressHUDModeCustomView;
            self.hud.labelText = @"Deleted";
            
            [PFCloud callFunctionInBackground:@"removeFriend" withParameters:@{@"friendRequest" : selected.objectId} block:^(id object, NSError *error)
             {
                 if (!error)
                 {
                     [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                         
                         if (succeeded)
                         {
                             cell.accessoryType = UITableViewCellAccessoryNone;
                             [self.hud removeFromSuperview];
                             [self loadFriends];
                             self.tableView.userInteractionEnabled = YES;
                         }
                     }];
                 }
                 else
                 {
                     NSLog(@"error");
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Try Again !" message:@"Check your network" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                     self.tableView.userInteractionEnabled = YES;
                 }
             }];
        }
        
        else
        {
            // Not friend
            [self checkSelectedUserRequest:selected forIndexPath:indexPath forCell:cell];
            self.tableView.userInteractionEnabled = YES;
        }
    }
    
    //CONTACT
    else if (self.segment.selectedSegmentIndex == 1)
    {
        Person *person = [[self.sectionedPersonName objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSLog(@"%@", person.number);
        
        NSMutableArray *realResult   = [NSMutableArray new];
        [self.tableData enumerateObjectsUsingBlock:^(Person *obj, NSUInteger idx, BOOL *stop) {
            self.result = [self.allUsers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K = %@", @"phone", obj.number]];
            if(self.result.count)
            {
                [realResult addObjectsFromArray:self.result];
            }
            for (PFUser *user in self.result)
            {
                if ([[self.result valueForKey:@"phone"] containsObject:person.number])
                {
                    self.selectedObjectId = user.objectId;
                    self.selectedUser = user;
                }
            }
        }];
        
        if (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator)
        {
            // Not friend
            [self checkSelectedUserRequest:self.selectedUser forIndexPath:indexPath forCell:cell];
            self.tableView.userInteractionEnabled = YES;
        }
        else if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
                // Already friend
            {
                self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_check.png"]];
                self.hud.mode = MBProgressHUDModeCustomView;
                self.hud.labelText = @"Deleted";
                
                [PFCloud callFunctionInBackground:@"removeFriend" withParameters:@{@"friendRequest" : self.selectedUser.objectId} block:^(id object, NSError *error)
                 {
                     if (!error)
                     {
                         [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                             
                             if (succeeded)
                             {
                                 cell.accessoryType = UITableViewCellAccessoryNone;
                                 [self.hud removeFromSuperview];
                                 [self loadFriends];
                                 self.tableView.userInteractionEnabled = YES;
                             }
                         }];
                     }
                     else
                     {
                         NSLog(@"error");
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Try Again !" message:@"Check your network" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                         [alert show];
                         self.tableView.userInteractionEnabled = YES;
                     }
                 }];
            }
        }
    }
    
    
    //AMIS EN ATTENTE
    else if (self.segment.selectedSegmentIndex == 2)
    {
        [self addFriend:indexPath forCell:cell];
    }
    [self.tableView reloadData];
}


- (void)getPersonOutOfAddressBook
{
    //1
    CFErrorRef error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error); // indirection
    
    if (addressBook)
    {
        NSLog(@"Succesful.");
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
        {
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                     {
                                                         if (granted)
                                                         {
                                                             NSLog(@"granted");
                                                             // First time, add contacts.
                                                             NSMutableSet *foundIDs = [NSMutableSet set];
                                                             NSArray *allContacts = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
                                                             
                                                             for (id record in allContacts)
                                                             {
                                                                 ABRecordRef contactPerson = (__bridge ABRecordRef)record;
                                                                 ABRecordID recordId = ABRecordGetRecordID(contactPerson);
                                                                 if (![foundIDs containsObject:@(recordId)])
                                                                 {
                                                                     Person *person = [[Person alloc] init];
                                                                     
                                                                     // get name
                                                                     
                                                                     person.firstName = CFBridgingRelease(ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty)) ?: @"";
                                                                     person.lastName = CFBridgingRelease(ABRecordCopyValue(contactPerson, kABPersonLastNameProperty)) ?: @"";
                                                                     person.fullName = [NSString stringWithFormat:@"%@ %@", person.firstName, person.lastName];
                                                                     
                                                                     // get phones
                                                                     
                                                                     ABMultiValueRef phones = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
                                                                     for (NSUInteger j = 0; j < ABMultiValueGetCount(phones); j++)
                                                                     {
                                                                         
                                                                         if ([CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, j)) hasPrefix:@"07"] || [CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, j)) hasPrefix:@"06"] ||[CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, j)) hasPrefix:@"+33"])
                                                                         {
                                                                             NSError *anError = nil;
                                                                             NBPhoneNumber *myNumber = [phoneUtil parse:[CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, j)) mutableCopy]
                                                                                                          defaultRegion:@"FR" error:&anError];
                                                                             NSString *phoneNumber = [NSString stringWithFormat:@"%@", [phoneUtil format:myNumber
                                                                                                                                            numberFormat:NBEPhoneNumberFormatNATIONAL
                                                                                                                                                   error:&anError]];
                                                                             person.number = phoneNumber;
                                                                         }
                                                                     }
                                                                     CFRelease(phones);
                                                                     
                                                                     // add the `Person` record
                                                                     
                                                                     [self.tableData addObject:person];
                                                                     
                                                                     // add the ID for this person (and all linked contacts) to our set of `foundIDs`
                                                                     
                                                                     NSArray *linkedPeople = CFBridgingRelease(ABPersonCopyArrayOfAllLinkedPeople(contactPerson));
                                                                     if (linkedPeople)
                                                                     {
                                                                         for (id record in linkedPeople)
                                                                         {
                                                                             [foundIDs addObject:@(ABRecordGetRecordID((__bridge ABRecordRef)record))];
                                                                         }
                                                                     }
                                                                     else
                                                                     {
                                                                         [foundIDs addObject:@(recordId)];
                                                                     }
                                                                 }
                                                             }
                                                             
                                                             CFRelease(addressBook);
                                                             
                                                             NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"fullName" ascending:YES];
                                                             [self.tableData sortUsingDescriptors:@[descriptor]];
                                                             self.sectionedPersonName = [self partitionObjects:self.tableData collationStringSelector:@selector(fullName)];
                                                         }
                                                         else
                                                         {
                                                             dispatch_async(dispatch_get_main_queue(), ^
                                                                            {
                                                                                UIAlertView *cantAddContactAlert = [[UIAlertView alloc] initWithTitle: @"Cannot Add Contact" message: @"You must give the app permission to add the contact first." delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
                                                                                [cantAddContactAlert show];
                                                                                // User denied access.Display an alert telling user that they must allow access to proceed to the "invites" page.
                                                                            });
                                                         }
                                                     });
        }
        
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
        {
            // The user has previously given access, add all the user's contacts to array.
            NSMutableSet *foundIDs = [NSMutableSet set];
            NSArray *allContacts = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
            
            for (id record in allContacts)
            {
                ABRecordRef contactPerson = (__bridge ABRecordRef)record;
                ABRecordID recordId = ABRecordGetRecordID(contactPerson);
                if (![foundIDs containsObject:@(recordId)])
                {
                    Person *person = [[Person alloc] init];
                    
                    // get name
                    
                    person.firstName = CFBridgingRelease(ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty)) ?: @"";
                    person.lastName = CFBridgingRelease(ABRecordCopyValue(contactPerson, kABPersonLastNameProperty)) ?: @"";
                    person.fullName = [NSString stringWithFormat:@"%@ %@", person.firstName, person.lastName];
                    
                    // get phones
                    
                    ABMultiValueRef phones = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
                    for (NSUInteger j = 0; j < ABMultiValueGetCount(phones); j++)
                    {
                        
                        if ([CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, j)) hasPrefix:@"07"] || [CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, j)) hasPrefix:@"06"] ||[CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, j)) hasPrefix:@"+33"])
                        {
                            NSError *anError = nil;
                            NBPhoneNumber *myNumber = [phoneUtil parse:[CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, j)) mutableCopy]
                                                         defaultRegion:@"FR" error:&anError];
                            NSString *phoneNumber = [NSString stringWithFormat:@"%@", [phoneUtil format:myNumber
                                                                                           numberFormat:NBEPhoneNumberFormatNATIONAL
                                                                                                  error:&anError]];
                            person.number = phoneNumber;
                        }
                    }
                    
                    CFRelease(phones);
                    
                    // add the `Person` record
                    
                    [self.tableData addObject:person];
                    
                    // add the ID for this person (and all linked contacts) to our set of `foundIDs`
                    
                    NSArray *linkedPeople = CFBridgingRelease(ABPersonCopyArrayOfAllLinkedPeople(contactPerson));
                    if (linkedPeople)
                    {
                        for (id record in linkedPeople)
                        {
                            [foundIDs addObject:@(ABRecordGetRecordID((__bridge ABRecordRef)record))];
                        }
                    }
                    else
                    {
                        [foundIDs addObject:@(recordId)];
                    }
                }
            }
            
            CFRelease(addressBook);
            
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"fullName" ascending:YES];
            [self.tableData sortUsingDescriptors:@[descriptor]];
            self.sectionedPersonName = [self partitionObjects:self.tableData collationStringSelector:@selector(fullName)];
        }
        
        else {
            //9
            NSLog(@"ERROR!!!");
            return;
        }
    }
    else
    {
        NSLog(@"No AddressBook");
        UIAlertView *cantAddContactAlert = [[UIAlertView alloc] initWithTitle: @"Cannot Search by Contact" message: @"You must give the app permission in Parameter > ChillN" delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [cantAddContactAlert show];
        // The user has previously denied access
        // Send an alert telling user that they must allow access to proceed to the "invites" page.
    }
    
}

- (NSArray *)partitionObjects:(NSArray *)array collationStringSelector:(SEL)selector
{
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    NSInteger sectionCount = [[collation sectionTitles] count]; //section count is take from sectionTitles and not sectionIndexTitles
    NSMutableArray *unsortedSections = [NSMutableArray arrayWithCapacity:sectionCount];
    
    //create an array to hold the data for each section
    for(int i = 0; i < sectionCount; i++)
    {
        [unsortedSections addObject:[NSMutableArray array]];
    }
    
    //put each object into a section
    for (id object in array)
    {
        NSInteger index = [collation sectionForObject:object collationStringSelector:selector];
        [[unsortedSections objectAtIndex:index] addObject:object];
    }
    
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:sectionCount];
    
    //sort each section
    for (NSMutableArray *section in unsortedSections)
    {
        [sections addObject:[collation sortedArrayFromArray:section collationStringSelector:selector]];
    }
    
    return sections;
}

- (BOOL)isFriend:(PFUser *)user
{
    for(PFUser *friend in self.friends)
    {
        if ([friend.objectId isEqualToString:user.objectId])
        {
            return YES;
        }
    }
    return NO;
}

- (void)loadFriends
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.friendsRelation = [self.currentUser objectForKey:@"friends"];
    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error)
         {
             NSLog(@"Error %@ %@", error, [error userInfo]);
             [self.hud removeFromSuperview];
         }
         else
         {
             self.friends = objects;
             [self.tableView reloadData];
             [self.hud removeFromSuperview];
         }
     }];
}

- (void)refreshAllUsers
{
    PFQuery *query = [PFUser query];
    //[query orderByAscending:@"name"];
    //    [query whereKey:@"objectId" notEqualTo:self.currentUser.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error)
         {
             NSLog(@"Error: %@ %@", error, [error userInfo]);
             [self.hud removeFromSuperview];
         }
         else
         {
             self.allUsers = objects;
             [self.tableView reloadData];
             [self.hud removeFromSuperview];
         }
     }];
}

- (void)refreshAllUsersAndLoadFriends
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.segment.userInteractionEnabled = NO;
    PFQuery *query = [PFUser query];
    //[query orderByAscending:@"name"];
    //    [query whereKey:@"objectId" notEqualTo:self.currentUser.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error)
         {
             NSLog(@"Error: %@ %@", error, [error userInfo]);
             [self.hud removeFromSuperview];
         }
         else
         {
             self.allUsers = objects;
             [self.tableView reloadData];
             self.friendsRelation = [self.currentUser objectForKey:@"friends"];
             PFQuery *query = [self.friendsRelation query];
             [query orderByAscending:@"username"];
             [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
              {
                  if (error)
                  {
                      NSLog(@"Error %@ %@", error, [error userInfo]);
                      [self.hud removeFromSuperview];
                  }
                  else
                  {
                      self.friends = objects;
                      [self.tableView reloadData];
                      self.segment.userInteractionEnabled = YES;
                      [self.hud removeFromSuperview];
                  }
              }];
         }
     }];
}

- (void)addFriend:(NSIndexPath *)indexPath forCell:(UITableViewCell *)cell
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    //get the selected request
    PFObject *friendRequest = [self.friendRequestsWaiting objectAtIndex:indexPath.row];
    //get the user the request is from
    PFUser *fromUser = [friendRequest objectForKey:@"from"];
    //call the cloud function addFriendToFriendRelation which adds the current user to the from users friends:
    //we pass in the object id of the friendRequest as a parameter (you cant pass in objects, so we pass in the id)
    [PFCloud callFunctionInBackground:@"addFriendToFriendsRelation" withParameters:@{@"friendRequest" : friendRequest.objectId} block:^(id object, NSError *error)
     {
         
         if (!error)
         {
             //add the fromuser to the currentUsers friends
             PFRelation *friendsRelation = [self.currentUser relationForKey:@"friends"];
             [friendsRelation addObject:fromUser];
             
             //save the current user
             [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
              {
                  
                  if (succeeded)
                  {
                      cell.accessoryType = UITableViewCellAccessoryCheckmark;
                      [self.friendRequestsWaiting removeObjectAtIndex:indexPath.row];
                      NSLog(@"succeed");
                      NSLog(@"%@", friendRequest);
                      
                      [friendRequest deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                          if (succeeded)
                          {
                              NSLog(@"Clean !");
                              [self.tableView reloadData];
                              [self.hud removeFromSuperview];
                          }
                          else
                          {
                              [self.hud removeFromSuperview];
                          }
                      }];
                  }
                  else
                  {
                      [self.hud removeFromSuperview];
                  }
                  
              }];
         }
         else
         {
             [self.hud removeFromSuperview];
         }
     }];
}

- (void)checkSelectedUserRequest:(PFUser *)selectedUser forIndexPath:(NSIndexPath *)indexPath forCell:(UITableViewCell *)cell
{
    // Check if selected user has already sent a request.
    PFQuery *checkSelectedUserRequest = [PFQuery queryWithClassName:@"FriendRequest"];
    [checkSelectedUserRequest whereKey:@"to" equalTo:self.currentUser];
    [checkSelectedUserRequest whereKey:@"from" equalTo: selectedUser];
    [checkSelectedUserRequest getFirstObjectInBackgroundWithBlock:^(PFObject *user, NSError *error) {
        if (!user) {
            [self sendFriendRequest:selectedUser];
        }
        else {
            [PFCloud callFunctionInBackground:@"addFriend" withParameters:@{@"friendRequest" : selectedUser.objectId} block:^(id object, NSError *error)
             {
                 if (!error)
                 {
                     [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                         if (succeeded) {
                             [user deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                 if (succeeded) {
                                     [self loadFriends];
                                 }
                             }];
                         }
                     }];
                 }
             }];
        }
    }];
}

- (void)sendFriendRequest:(PFUser *)selectedUser
{
    // Request them
    PFObject *friendRequest = [PFObject objectWithClassName:@"FriendRequest"];
    friendRequest[@"from"] = self.currentUser;
    friendRequest[@"fromUsername"] = [self.currentUser objectForKey:@"surname"];
    //selected user is the user at the cell that was selected
    friendRequest[@"to"] = selectedUser;
    // set the initial status to pending
    friendRequest[@"status"] = @"pending";
    
    PFQuery *query = [PFQuery queryWithClassName:@"FriendRequest"];
    [query whereKey:@"from" equalTo:self.currentUser];
    [query whereKey:@"to" equalTo: selectedUser];
    [query countObjectsInBackgroundWithBlock:^(int object, NSError*error)
     {
         
         if(!error)
         {
             if(object == 0)
             {
                 //Save & Send Request
                 [friendRequest saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                  {
                      if (succeeded)
                      {
                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sent !" message:@"Friend request sent" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                          [alert show];
                          [self.hud removeFromSuperview];
                          self.tableView.userInteractionEnabled = YES;
                      }
                      else
                      {
                          [self.hud removeFromSuperview];
                          self.tableView.userInteractionEnabled = YES;
                          // error occurred
                      }
                  }];
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Friend Request is Already Submitted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [alert show];
                 self.tableView.userInteractionEnabled = YES;
             }
         }
         else
         {
             
         }
     }];
}

- (void)refreshWaitingFriend
{
    PFQuery *requestsToCurrentUser = [PFQuery queryWithClassName:@"FriendRequest"];
    [requestsToCurrentUser whereKey:@"to" equalTo:self.currentUser];
    [requestsToCurrentUser whereKey:@"status" equalTo:@"pending"];
    [requestsToCurrentUser findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             //this property stores the data for the tableView
             self.friendRequestsWaiting = [NSMutableArray arrayWithArray:objects];
             //reload the table
             [self.tableView reloadData];
             NSLog(@"%@", self.friendRequestsWaiting);
         }
         else
         {
             [self.hud removeFromSuperview];
             //error occcurred
         }
     }];
}


//- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
//{
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"surname contains[c] %@", searchText];
//    self.searchResults = [self.allUsers filteredArrayUsingPredicate:predicate];
//
//}
//
//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
//    [self filterContentForSearchText:searchString
//                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
//                                      objectAtIndex:[self.searchDisplayController.searchBar
//                                                     selectedScopeButtonIndex]]];
//
//    return YES;
//}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    [self searchForText:searchString];
    [self.tableView reloadData];
    NSLog(@"updateSearchResultsForSearchController");
    
}

- (void)searchForText:(NSString*)searchText
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"surname beginswith[c] %@", searchText];
    self.searchResults = [self.allUsers filteredArrayUsingPredicate:predicate];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}

@end