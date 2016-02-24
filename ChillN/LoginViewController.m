//
//  LoginViewController.m
//  ChillN
//
//  Created by Vincent Jardel on 20/05/2014.
//  Copyright (c) 2014 Jardel Vincent. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface LoginViewController ()
@end

@implementation LoginViewController

//label.font = UIFont(name: "SFUIText-Regular", size: 16) --> San Francisco iOS9 Font.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
}


- (IBAction)login {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *user = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if ([user length] == 0 || [password length] == 0)
    {
        UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Error"  message:@"Login or Password is empty"  preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        [self.hud removeFromSuperview];
    }
    
    else
    {
        [PFUser logInWithUsernameInBackground:user
                                     password:password block:^(PFUser *user, NSError *error)
         {
             if(error)
             {
                 [self.hud removeFromSuperview];
                 UIAlertView *alertViewSignUp = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alertViewSignUp show];
             }
             else
             {
                 //GOOD LOGIN
                 
                 AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"logged"];
                 appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
                 [self.hud removeFromSuperview];
             }
         }];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailField)
    {
        [textField resignFirstResponder];
        [self.passwordField becomeFirstResponder];
    }
    else if (textField == self.passwordField)
    {
        
        if (self.emailField.text.length != 0 && self.passwordField.text.length != 0)
        {
            [textField resignFirstResponder];
            [self login];
        }
        else
        {
            [textField resignFirstResponder];
        }
    }
    return YES;
}

@end
