//
//  detailEvent.h
//  ChillN
//
//  Created by Vincent Jardel on 06/06/2015.
//  Copyright (c) 2015 ChillCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EventDetailViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;
@property (strong, nonatomic) NSString *questionString;
@property (strong, nonatomic) IBOutlet UITextField *questionTextField;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property(nonatomic,strong) PFObject *event;
@property(nonatomic,strong) PFUser *currentUser;
@property(nonatomic, strong) NSArray *allParticipants;
@property(nonatomic, strong) NSArray *participants;
@property(nonatomic, strong) NSArray *refusedParticipants;

@end
