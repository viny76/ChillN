//
//  SignupViewController.m
//  Mindle
//
//  Created by Vincent Jardel on 20/05/2014.
//  Copyright (c) 2014 Jardel Vincent. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"

@interface SignupViewController ()

@end

@implementation SignupViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    asYouTypeFormatter = [[NBAsYouTypeFormatter alloc] initWithRegionCode:@"FR"];
    //    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.numberField)
    {
        [textField resignFirstResponder];
        [self.userField becomeFirstResponder];
    }
    else if (textField == self.userField)
    {
        [textField resignFirstResponder];
        [self.emailField becomeFirstResponder];
    }
    else if (textField == self.emailField)
    {
        [textField resignFirstResponder];
        [self.passwordField becomeFirstResponder];
    }
    else if (textField == self.passwordField)
    {
        [textField resignFirstResponder];
    }
    return YES;
}

//-(void)textFieldDidBeginEditing:(UITextField *)textField {
//    if (textField == self.passwordField)
//    {
//        CGAffineTransform transform = CGAffineTransformMake(1, 0, 0, 1, 0, -65);
//        [UIView animateWithDuration:0.5 animations:^{
//            self.signUpButton.transform = transform;
//            [self.view layoutIfNeeded];
//        } completion:^(BOOL finished) {
//        }];
//    }
//}

- (IBAction)signup
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *number = [self.numberField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *username = [self.userField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([password length] == 0 || [email length] == 0 || [number length] == 0 || [username length] == 0)
    {
        UIAlertView *alertViewUsername = [[UIAlertView alloc] initWithTitle:@"Oops !" message:@"One field is empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [self.hud removeFromSuperview];
        [alertViewUsername show];
    }
    else
    {
        PFUser *newUser = [PFUser user];
        newUser[@"phone"] = number;
        newUser.username = email;
        newUser[@"surname"] = username;
        newUser.password = password;
        
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if(error)
             {
                 UIAlertView *alertViewSignUp = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alertViewSignUp show];
                 [self.hud removeFromSuperview];
             }
             else
             {
                 AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"logged"];
                 appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
                 
                 UIAlertView *alertViewRegistered = [[UIAlertView alloc] initWithTitle:@"Completed Registration !" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alertViewRegistered show];
                 [self.hud removeFromSuperview];
             }
         }];
    }
}

- (IBAction)dismiss:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Phone Number textfield formatting
# define LIMIT 14 // Or whatever you want
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.numberField)
    {
        if(!(([string length] + range.location) > LIMIT))
        {
            // Something entered by user
            if(range.length == 0)
            {
                [textField setText:[asYouTypeFormatter inputDigit:string]];
            }
            
            // Backspace
            else if(range.length == 1)
            {
                [textField setText:[asYouTypeFormatter removeLastDigit]];
            }
        }
        return NO;
    }
    return  YES;
}


@end