//
//  ViewController.h
//  ChillN
//
//  Created by Vincent Jardel on 28/04/2015.
//  Copyright (c) 2015 ChillCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ButtonTableViewCell.h"
#import "SwitchTableViewCell.h"
#import "LabelButtonTableViewCell.h"
#import "Constants.h"
#import <Parse.h>

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSArray *values;
    NSUInteger index;
    ActionSheetStringPicker *picker;
    UIAlertView *alert;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end