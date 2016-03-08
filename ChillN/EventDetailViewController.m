//
//  detailEvent.m
//  ChillN
//
//  Created by Vincent Jardel on 06/06/2015.
//  Copyright (c) 2015 ChillCompany. All rights reserved.
//

#import "EventDetailViewController.h"

@interface EventDetailViewController ()
@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Reload event
    PFQuery *query = [PFQuery queryWithClassName:@"Events"];
    [query whereKey:@"objectId" equalTo:[self.event objectId]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            self.event = object;
            self.participants = [self.event valueForKey:@"acceptedUser"];
            self.allParticipants = [self.event valueForKey:@"toUser"];
            self.refusedParticipants = [self.event valueForKey:@"refusedUser"];
            [self.tableView reloadData];
        } else {
            NSLog(@"Error");
        }
    }];
    self.usernameLabel.text = [self.event valueForKey:@"fromUser"];
    self.questionString = [self.event valueForKey:@"question"];
    self.questionTextField.text = [NSString stringWithFormat:@"%@", self.questionString];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [df setDateFormat:@"dd/MM/yyyy HH:mm"];
    NSString *date = [df stringFromDate:[self.event valueForKey:@"date"]];
    self.dateLabel.text = date;
    
    if ([[self.event valueForKey:@"visibility"] isEqual:@NO]) {
        [self.tableView setHidden:YES];
        [self.segment setHidden:YES];
    } else {
        self.participants = [self.event valueForKey:@"acceptedUser"];
        self.allParticipants = [self.event valueForKey:@"toUser"];
        self.refusedParticipants = [self.event valueForKey:@"refusedUser"];
    }
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (IBAction)segmentedControlIndexChanged {
    if (self.segment.selectedSegmentIndex == 0) {
        
    }
    else if (self.segment.selectedSegmentIndex == 1) {
        
    }
    else if (self.segment.selectedSegmentIndex == 2) {
        
    }
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.segment.selectedSegmentIndex == 0) {
        return [self.allParticipants count];
    }
    else if (self.segment.selectedSegmentIndex == 1) {
        return [self.participants count];
    }
    else if (self.segment.selectedSegmentIndex == 2) {
        return [self.refusedParticipants count];
    }
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
    if (self.segment.selectedSegmentIndex == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.allParticipants objectAtIndex:indexPath.row ]];
    }
    else if (self.segment.selectedSegmentIndex == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.participants objectAtIndex:indexPath.row ]];
    }
    else if (self.segment.selectedSegmentIndex == 2) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.refusedParticipants objectAtIndex:indexPath.row ]];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    PFUser *user = [[self.event valueForKey:@"toUser"] objectAtIndex:indexPath.row];
    NSLog(@"%@", user);
}

- (IBAction)yesButton:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Events"];
    [query whereKey:@"objectId" equalTo:[self.event objectId]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            if ([[object valueForKey:@"acceptedUser"] containsObject:[self.currentUser objectForKey:@"surname"]]) {
                NSLog(@"Already added");
            } else {
                if ([[object valueForKey:@"refusedUser"] containsObject:[self.currentUser objectForKey:@"surname"]]) {
                    [object addObject:[self.currentUser objectForKey:@"surname"] forKey:@"acceptedUser"];
                    [object removeObject:[self.currentUser objectForKey:@"surname"] forKey:@"refusedUser"];
                    [self reloadEvent];
                } else {
                    [object addObject:[self.currentUser objectForKey:@"surname"] forKey:@"acceptedUser"];
                    [self reloadEvent];
                }
            }
            
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    [self reloadEvent];
                }
            }];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (IBAction)noButton:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Events"];
    [query whereKey:@"objectId" equalTo:[self.event objectId]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            if ([[object valueForKey:@"refusedUser"] containsObject:[self.currentUser objectForKey:@"surname"]]) {
                NSLog(@"Already added");
            } else {
                if ([[object valueForKey:@"acceptedUser"] containsObject:[self.currentUser objectForKey:@"surname"]]) {
                    [object removeObject:[self.currentUser objectForKey:@"surname"] forKey:@"acceptedUser"];
                    [object addObject:[self.currentUser objectForKey:@"surname"] forKey:@"refusedUser"];
                } else {
                    [object addObject:[self.currentUser objectForKey:@"surname"] forKey:@"refusedUser"];
                }
            }
            
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    [self reloadEvent];
                }
            }];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)reloadEvent {
    PFQuery *query = [PFQuery queryWithClassName:@"Events"];
    [query whereKey:@"objectId" equalTo:[self.event objectId]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            self.event = object;
            NSLog(@"CHECK %@", object);
            self.participants = [self.event valueForKey:@"acceptedUser"];
            self.allParticipants = [self.event valueForKey:@"toUser"];
            self.refusedParticipants = [self.event valueForKey:@"refusedUser"];
            [self.tableView reloadData];
        } else {
            NSLog(@"Error");
        }
    }];
}

@end
