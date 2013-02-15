//
//  AppDelegate.m
//  MagicScrollingNavBar
//
//  Created by Brian Nickel on 2/14/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import "AppDelegate.h"
#import "SampleTableViewController.h"
#import "MagicScrollingNavigationController.h"

@interface AppDelegate () <UINavigationControllerDelegate>
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController *navigationController = [[MagicScrollingNavigationController alloc] initWithRootViewController:[[SampleTableViewController alloc] init]];
    
    
    // Your code goes here.
    navigationController.delegate = self;
    [navigationController setNavigationBarHidden:YES animated:NO];
    
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [navigationController setNavigationBarHidden:navigationController.viewControllers.count == 1 animated:YES];
}

@end
