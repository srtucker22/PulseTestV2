//
//  AppDelegate.m
//  StressBuster
//
//  Created by Simon Tucker on 10/26/12.
//  Copyright (c) 2012 Simon Tucker. All rights reserved.
//

#import "AppDelegate.h"

#import "ProcessViewController.h"

#import <Parse/Parse.h>

#import "User.h"

#import "IntroViewController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"APPID"
                  clientKey:@"KEY"];
    
    [PFFacebookUtils initializeWithApplicationId:@"APPID"];
    
    //If the user is new, assign an anonymous PFUser
    if(![PFUser currentUser])
    {
        [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error) {
            if (error) {
                NSLog(@"Anonymous login failed.");
            } else {
                NSLog(@"Anonymous user logged in.");
            }
        }];
    }
    
    [[[User sharedUser] locationManager] startUpdatingLocation];
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"timerLength"])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:30 forKey:@"timerLength"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.viewController = [[IntroViewController alloc] initWithNibName:@"IntroViewController" bundle:nil];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [[[User sharedUser] locationManager] stopUpdatingLocation];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[[User sharedUser] locationManager] stopUpdatingLocation];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[[User sharedUser] locationManager] startUpdatingLocation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[[User sharedUser] locationManager] startUpdatingLocation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[[User sharedUser] locationManager] stopUpdatingLocation];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}


@end