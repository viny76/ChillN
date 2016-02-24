//
//  ViewController.m
//  ChillN
//
//  Created by Vincent Jardel on 28/04/2015.
//  Copyright (c) 2015 ChillCompany. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

BOOL notificationOn = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
    
    UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Screen width], 50)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, [Screen width], 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorHeaderLabel];
    label.text = [NSString stringWithFormat:@"Version %@", version];
    [footerView addSubview:label];
    
    self.tableView.tableFooterView = footerView;
    
    // Check user notification in settings
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]) {
        // iOS 8+
        UIUserNotificationSettings *grantedSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        
        if (grantedSettings.types == UIUserNotificationTypeNone) {
            notificationOn = NO;
        } else {
            notificationOn = YES;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [picker hidePickerWithCancelAction];
    [alert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:YES];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 28)];
    view.backgroundColor = [UIColor colorHeaderViewBackground];
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, 4, self.view.frame.size.width, 24);
    
    if (section == 0) {
        label.text = Localized(@"Account");
    } else if (section == 1) {
        label.text = Localized(@"More");
    }
    
    [view addSubview:label];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    } else if (section == 1) {
        return 2;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (notificationOn || version < 8.0){
                SwitchTableViewCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
                
                switchCell.cellLabel.text = @"Notifications";
                [switchCell.cellSwitch addTarget:self action:@selector(setChangeSwitch:) forControlEvents:UIControlEventValueChanged];
                
                cell = switchCell;
            } else {
                LabelButtonTableViewCell *labelButtonCell = [tableView dequeueReusableCellWithIdentifier:@"LabelButtonCell" forIndexPath:indexPath];
                
                labelButtonCell.cellLabel.text = @"Notifications";
                [labelButtonCell.cellButton setTitle:Localized(@"SettingsNotification") forState:UIControlStateNormal];
                [labelButtonCell.cellButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                labelButtonCell.cellButton.tag = 4;
                cell = labelButtonCell;
            }
        } else if (indexPath.row == 1) {
            LabelButtonTableViewCell *labelButtonCell = [tableView dequeueReusableCellWithIdentifier:@"LabelButtonCell" forIndexPath:indexPath];
            
            labelButtonCell.cellLabel.text = Localized(@"Unit of weight");
            cell = labelButtonCell;
        } else if (indexPath.row == 2) {
            LabelButtonTableViewCell *labelButtonCell = [tableView dequeueReusableCellWithIdentifier:@"LabelButtonCell" forIndexPath:indexPath];
            
            labelButtonCell.cellLabel.text = Localized(@"Unit of height");
            cell = labelButtonCell;
        }
        else if (indexPath.row == 3) {
            LabelButtonTableViewCell *labelButtonCell = [tableView dequeueReusableCellWithIdentifier:@"LabelButtonCell" forIndexPath:indexPath];
            
            labelButtonCell.cellLabel.text = Localized(@"Pdf format");
            cell = labelButtonCell;
        }
        else if (indexPath.row == 4) {
            LabelButtonTableViewCell *labelButtonCell = [tableView dequeueReusableCellWithIdentifier:@"LabelButtonCell" forIndexPath:indexPath];
            
            labelButtonCell.cellLabel.text = Localized(@"Language");
            
            cell = labelButtonCell;
        }
    } else if (indexPath.section == 1) {
        ButtonTableViewCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCell" forIndexPath:indexPath];
        
        if (indexPath.row == 0) {
            buttonCell.cellLabel.text = Localized(@"Disconnect");
        } else if (indexPath.row == 1) {
            buttonCell.cellLabel.text = Localized(@"Terms and conditions");
        }
        
        cell = buttonCell;
    }
    
    return cell;
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

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Rows in section 1 should not be selectable
    if (indexPath.section == 1) {
        return NO;
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
    } else if (indexPath.section == 1) {
        // Nothing to do
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            // Disconnect User
            [PFUser logOut];
            AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
            
            UIViewController *rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
            
            UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
            appDelegateTemp.window.rootViewController = navigation;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"logged"];
        } else if (indexPath.row == 1) {
            // Launch terms
            UIViewController *termsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Terms"];
            [self.navigationController pushViewController:termsVC animated:YES];
        }
    }
}

#pragma mark - Actions

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (alertView.tag == 0) {
            // Update PIN Code
        } else if (alertView.tag == 1) {
            // Delete PIN Code
            }
        } else if (alertView.tag == 2) {
            // Define PIN Code
        }
}

- (IBAction)labelButtonCellTouched:(UIButton *)sender {
    if (sender.tag == 4) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
            if ([[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"] isEqualToString:@"AbbVie RD"]) {
                alert = [[UIAlertView alloc] initWithTitle:Localized(@"Notification disabled") message:Localized(@"Please go in Settings > Notification Center > My Rheumatology passport and enable notification.") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            } else {
                alert = [[UIAlertView alloc] initWithTitle:Localized(@"Notification disabled") message:Localized(@"Please go in Settings > Notification Center > My IBD passport and enable notification.") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            }
            
            [alert show];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    } else {
        NSString *mode = Localized(sender.titleLabel.text);
        NSString *pickerTitle = Localized(@"Unit");
        
        if ([mode isEqualToString:@"kg"] || [mode isEqualToString:@"lb"]) {
            values = [NSArray arrayWithObjects:@"kg", @"lb", nil];
            
        } else if ([mode isEqualToString:@"cm"] || [mode isEqualToString:Localized(@"inches")]) {
            values = [NSArray arrayWithObjects:@"cm", Localized(@"inches"), nil];
        } else if ([mode isEqualToString:@"US Letter"] || [mode isEqualToString:@"A4"]) {
            values = [NSArray arrayWithObjects:@"US Letter", @"A4", nil];
            pickerTitle = @"Format";
        } else {
            // Language
            values = [NSArray arrayWithObjects:Localized(@"English"), Localized(@"French"), nil];
            pickerTitle = Localized(@"Language");
        }
        
        picker =
        [[ActionSheetStringPicker alloc] initWithTitle:pickerTitle
                                                  rows:values
                                      initialSelection:index
                                             doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                 [sender setTitle:selectedValue forState:UIControlStateNormal];
                                                 
                                                 if ([mode isEqualToString:@"kg"] || [mode isEqualToString:@"lb"]) {
                                                 } else if ([mode isEqualToString:@"cm"] || [mode isEqualToString:Localized(@"inches")]) {
                                                 } else if ([mode isEqualToString:@"US Letter"] || [mode isEqualToString:@"A4"]) {
                                                 } else {
                                                     if ([selectedValue isEqualToString:Localized(@"English")]) {
                                                         [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en-US", nil]
                                                                                                   forKey:@"AppleLanguages"];
                                                         [[NSUserDefaults standardUserDefaults] synchronize];
                                                     } else {
                                                         [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"fr-US", nil]
                                                                                                   forKey:@"AppleLanguages"];
                                                         [[NSUserDefaults standardUserDefaults] synchronize];
                                                     }
                                                     
                                                     UIStoryboard *storyboard;
                                                     
                                                     if ([[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"] isEqualToString:@"AbbVie RD"]) {
                                                         storyboard = [UIStoryboard storyboardWithName:@"Main+RD" bundle:nil];
                                                     } else {
                                                         storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                     }
                                                     
                                                     UIStoryboard *storyboard2 = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
                                                     [self.navigationController setViewControllers:@[[storyboard instantiateViewControllerWithIdentifier:@"Menu"],
                                                                                                     [storyboard2 instantiateViewControllerWithIdentifier:@"Settings"]]
                                                                                          animated:NO];
                                                 }
                                             }
                                           cancelBlock:^(ActionSheetStringPicker *picker) {}
                                                origin:sender];
        
        [picker setCancelButton:[[UIBarButtonItem alloc] initWithTitle:Localized(@"Cancel") style:UIBarButtonItemStylePlain target:nil action:nil]];
        [picker setDoneButton:[[UIBarButtonItem alloc] initWithTitle:Localized(@"Done") style:UIBarButtonItemStylePlain target:nil action:nil]];
        
        [picker showActionSheetPicker];
    }
}

@end
