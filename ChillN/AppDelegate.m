//
//  AppDelegate.m
//  ChillN
//
//  Created by Vincent Jardel on 26/03/2015.
//  Copyright (c) 2015 ChillCompany. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"AwOihECdAdj5Qz65boD7vsPMpM6h2Uj7DONpJvVm";
        configuration.clientKey = @"gIK1bG2n5yGmoo1K7zqK1pYmynQ8U9M1CNDn3Jo3";
        configuration.server = @"http://localhost:1337/parse";
//        configuration.server = @"http://mongodb://localhost:27017/dev";
    }]];
    
    
//    [Parse setApplicationId:@"AwOihECdAdj5Qz65boD7vsPMpM6h2Uj7DONpJvVm"
//                  clientKey:@"gIK1bG2n5yGmoo1K7zqK1pYmynQ8U9M1CNDn3Jo3"];
//    [PFUser enableRevocableSessionInBackground];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"logged"])
    { // LOGGED = TRUE
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    }
    else
    {
        UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
        
        self.window.rootViewController = navigation;
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
