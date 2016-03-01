//
//  SignupViewController.h
//  ChillN
//
//  Created by Vincent Jardel on 20/05/2014.
//  Copyright (c) 2014 Jardel Vincent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "NBPhoneNumberUtil.h"
#import "NBAsYouTypeFormatter.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface SignupViewController : UIViewController {
    NBAsYouTypeFormatter *asYouTypeFormatter;
    NSString *number;
    NSString *username;
    NSString *email;
    NSString *password;
}

@property (strong, nonatomic) IBOutlet UITextField *numberField;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;

@property (nonatomic, strong) MBProgressHUD *hud;

- (IBAction)signup;
- (IBAction)dismiss:(id)sender;

@end