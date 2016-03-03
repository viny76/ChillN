//
//  SignupViewController.m
//  Mindle
//
//  Created by Vincent Jardel on 20/05/2014.
//  Copyright (c) 2014 Jardel Vincent. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()
@end

@implementation SignupViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    asYouTypeFormatter = [[NBAsYouTypeFormatter alloc] initWithRegionCode:@"FR"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.numberField) {
        [textField resignFirstResponder];
        [self.userField becomeFirstResponder];
    }
    else if (textField == self.userField) {
        [textField resignFirstResponder];
        [self.emailField becomeFirstResponder];
    }
    else if (textField == self.emailField) {
        [textField resignFirstResponder];
        [self.passwordField becomeFirstResponder];
    }
    else if (textField == self.passwordField) {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (IBAction)signup {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    number = [self.numberField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    username = [self.userField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([self verificationsLength]) {
        if ([self verificationsDB]) {
            PFUser *newUser = [PFUser user];
            newUser[@"phone"] = number;
            newUser.username = email;
            newUser[@"surname"] = username;
            newUser.password = password;
            
            [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    UIAlertView *alertViewSignUp = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertViewSignUp show];
                    [self.hud removeFromSuperview];
                } else {
                    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"logged"];
                    appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
                    
                    UIAlertView *alertViewRegistered = [[UIAlertView alloc] initWithTitle:@"Completed Registration !" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertViewRegistered show];
                    [self.hud removeFromSuperview];
                }
            }];
        } else {
            [self.hud removeFromSuperview];
        }
    } else {
        [self.hud removeFromSuperview];
    }
}

- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Phone Number textfield formatting
# define LIMIT 14 // Or whatever you want
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.numberField) {
        if (!(([string length] + range.location) > LIMIT)) {
            // Something entered by user
            if (range.length == 0) {
                [textField setText:[asYouTypeFormatter inputDigit:string]];
            }
            // Backspace
            else if (range.length == 1) {
                [textField setText:[asYouTypeFormatter removeLastDigit]];
            }
        }
        return NO;
    }
    return YES;
}

- (BOOL)verificationsLength {
    BOOL ok = YES;
    UIAlertView *alertView;
    NSString *title;
    
    if ([number length] == 0 ) {
        alertView = [[UIAlertView alloc] initWithTitle:title message:@"Number field is empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [self.hud removeFromSuperview];
        [alertView show];
        ok = NO;
    }
    else if ([number length] != 14) {
        alertView = [[UIAlertView alloc] initWithTitle:title message:@"Number format is invalid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [self.hud removeFromSuperview];
        [alertView show];
        ok = NO;
    }
    else if ([username length] == 0) {
        alertView = [[UIAlertView alloc] initWithTitle:title message:@"Username field is empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [self.hud removeFromSuperview];
        [alertView show];
        ok = NO;
    }
    else if ([email length] == 0) {
        alertView = [[UIAlertView alloc] initWithTitle:title message:@"Email field is empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [self.hud removeFromSuperview];
        [alertView show];
        ok = NO;
    }
    else if ([password length] == 0 ) {
        alertView = [[UIAlertView alloc] initWithTitle:title message:@"Password field is empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [self.hud removeFromSuperview];
        [alertView show];
        ok = NO;
    }
    
    return ok;
}

- (BOOL)verificationsDB {
    BOOL ok = YES;
    PFQuery *query = [PFUser query];
    [query whereKey:@"surname" equalTo:username];
    
    if ([query getFirstObject]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops !" message:@"Username already exists" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [self.hud removeFromSuperview];
        [alertView show];
        ok = NO;
    }
    
    return ok;
}

@end
