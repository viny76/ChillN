//
//  detailEvent.m
//  ChillN
//
//  Created by Vincent Jardel on 06/06/2015.
//  Copyright (c) 2015 ChillCompany. All rights reserved.
//

#import "EventDetailViewController.h"
#import "EventDetailCell.h"

@interface EventDetailViewController ()
@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"HEY : %@", self.event);
    self.questionString = [self.event valueForKey:@"question"];
    self.questionTextField.text = [NSString stringWithFormat:@"%@", self.questionString];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [df setDateFormat:@"dd/MM/yyyy HH:mm"];
    NSString *date = [df stringFromDate:[self.event valueForKey:@"date"]];
    self.dateLabel.text = date;
    
//    if ([self.event valueForKey:@"date"] != nil) {
//
//    }
    
    if ([[self.event valueForKey:@"visibility"] isEqual:@NO]) {
        [self.tableView setHidden:YES];
        [self.segment setHidden:YES];
    } else {
        self.allParticipants = [self.event valueForKey:@"toUser"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allParticipants count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.allParticipants objectAtIndex:indexPath.row ]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    //   UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    PFUser *user = [[self.event valueForKey:@"toUser"] objectAtIndex:indexPath.row];
    NSLog(@"%@", user);
}

@end
