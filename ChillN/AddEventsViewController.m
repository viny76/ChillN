//
//  ViewController.m
//  ChillN
//
//  Created by Vincent Jardel on 26/03/2015.
//  Copyright (c) 2015 ChillCompany. All rights reserved.
//

#import "AddEventsViewController.h"
#import "ChillN-Swift.h"

@interface AddEventsViewController () <UIScrollViewDelegate, HSDatePickerViewControllerDelegate>

@end

@implementation AddEventsViewController {
    BOOL dateModify;
    BOOL visibility;
    BOOL scrollingProgrammatically;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    scrollingProgrammatically = false;
    self.currentUser = [PFUser currentUser];
    //Hide Keyboard when tapping other area
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    //IMPORTANT !!!
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    self.recipientId = [[NSMutableArray alloc] init];
    self.recipientUser = [[NSMutableArray alloc] init];

    [self.mySwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    self.mySwitch.on = YES;
    [self.selectFriendButton setImage:[UIImage imageNamed:@"ChevronBottomBlue"] forState:UIControlStateNormal];
    [self.selectFriendButton setImage:[UIImage imageNamed:@"ChevronUpBlue"] forState:UIControlStateSelected];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    visibility = 1;
    [self loadFriends];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        if(!scrollingProgrammatically) {
            if (scrollView.contentOffset.y >= self.headerView.frame.origin.y && scrollView.contentOffset.y > 0) {
                // Reach details content view
                self.selectFriendButton.selected = true;
            }
            else {
                self.selectFriendButton.selected = false;
            }
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    scrollingProgrammatically = false;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.friendsList count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSString *name = [[self.friendsList objectAtIndex:indexPath.row] valueForKey:@"surname"];
    cell.textLabel.text = name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    PFUser *user = [self.friendsList objectAtIndex:indexPath.row];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.recipientId addObject:user.objectId];
        [self.recipientId addObject:self.currentUser.objectId];
        [self.recipientUser addObject:user[@"surname"]];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.recipientId removeObject:user.objectId];
        [self.recipientId removeObject:self.currentUser.objectId];
        [self.recipientUser removeObject:user[@"surname"]];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection: (NSInteger)section {
    return Localized(@"headerSectionFriend");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.questionTextField resignFirstResponder];
    return YES;
}

- (void)dismissKeyboard {
    [self.questionTextField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 25) ? NO : YES;// 25 is custom value. you can use your own.
}

- (IBAction)showDatePicker:(id)sender {
    HSDatePickerViewController *hsdpvc = [HSDatePickerViewController new];
    hsdpvc.delegate = self;
    [self presentViewController:hsdpvc animated:YES completion:nil];
}

//DATE PICKER
#pragma mark - HSDatePickerViewControllerDelegate
- (void)hsDatePickerPickedDate:(NSDate *)date {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    //The Z at the end of your string represents Zulu which is UTC
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    //Add the following line to display the time in the local time zone
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    NSString* finalTime = [dateFormatter stringFromDate:date];
    NSLog(@"%@", finalTime);
    [self.dateButton setTitle:[dateFormatter stringFromDate:date] forState:UIControlStateNormal];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    self.selectedDate = [dateFormatter dateFromString:finalTime];
    NSLog(@"%@", self.selectedDate);
}

//optional
- (void)hsDatePickerDidDismissWithQuitMethod:(HSDatePickerQuitMethod)method {
    //    NSLog(@"Picker did dismiss with %lu", (unsigned long)method);
}

//optional
- (void)hsDatePickerWillDismissWithQuitMethod:(HSDatePickerQuitMethod)method {
    //  NSLog(@"Picker will dismiss with %lu", (unsigned long)method);
}

- (void)loadFriends {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.friendsRelation = [self.currentUser objectForKey:@"friends"];
    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"surname"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error) {
             NSLog(@"Error %@ %@", error, [error userInfo]);
             [self.hud removeFromSuperview];
         } else {
             self.friendsList = objects;
             [self.tableView reloadData];
             [self.hud removeFromSuperview];
             self.friendHeight.constant = self.tableView.contentSize.height;
         }
     }];
}

- (IBAction)scrollToFriend:(id)sender {
    if (!self.selectFriendButton.selected) {
        scrollingProgrammatically = true;
        [self.scrollView scrollRectToVisible:self.friendView.frame animated:YES];
        //            UIView.animateWithDuration(0.1, animations: {
        //                self.gradientViewIphone.alpha = 0.0
        //            })
        self.selectFriendButton.selected = true;
    } else {
        scrollingProgrammatically = true;
        [self.scrollView scrollRectToVisible:self.headerView.frame animated:YES];
        //            gradientViewIphone.alpha = 1
        self.selectFriendButton.selected = false;
    }
    //    if (self.selectFriendButton.selected) {
    //        [self.scrollView scrollRectToVisible:self.headerView.frame animated:true];
    //    } else {
    //        [self.scrollView scrollRectToVisible:self.friendView.frame animated:true];
    //    }
}

- (IBAction)sendEvent:(id)sender {
    NSLog(@"tapped");
    if (self.questionTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Question is empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else if (self.recipientId.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Select Friend(s)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        PFObject *events = [PFObject objectWithClassName:@"Events"];
        [events setObject:self.currentUser.objectId forKey:@"fromUserId"];
        [events setObject:self.currentUser[@"surname"] forKey:@"fromUser"];
        
        [events setObject:self.recipientId forKey:@"toUserId"];
        [events setObject:self.recipientUser forKey:@"toUser"];
        [events setObject:self.questionTextField.text forKey:@"question"];
        [events setObject:[NSNumber numberWithBool:visibility] forKey:@"visibility"];
        [events addObject:[self.currentUser objectId] forKey:@"acceptedUser"];
        
        //        if (![self.dateButton.titleLabel.text isEqualToString:NSLocalizedString(@"modifyDateButton", nil)]) {
        if (![self.dateButton.titleLabel.text isEqualToString:@"Choisir Date"]) {
            NSLog(@"c good");
            NSLog(@"%@", NSLocalizedString(@"modifyDateButton", nil));
            [events setObject:self.selectedDate forKey:@"date"];
        }
        NSLog(@"%@", self.selectedDate);
        
        [events saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!"
                                                                    message:@"Please try sending your message again."
                                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            } else {
                NSLog(@"Alright!");
                AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
                appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
            }
        }];
    }
}

- (void)switchChanged:(id)sender {
    if ([sender isOn]) {
        NSLog(@"ON");
        visibility = YES;
        NSLog(@"Bool value: %d",visibility);
    }
    else {
        NSLog(@"OFF");
        visibility = NO;
        NSLog(@"Bool value: %d",visibility);
    }
}

@end
