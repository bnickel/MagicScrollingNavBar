//
//  MagicScrollingNavigationController.m
//  MagicScrollingNavBar
//
//  Created by Brian Nickel on 2/14/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import "MagicScrollingNavigationController.h"

@interface MagicScrollingNavigationController ()

@end

@implementation MagicScrollingNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.navigationBar.translucent = YES;
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    [self fixNavigationBarPosition];
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    [super setViewControllers:viewControllers];
    [self fixNavigationBarPosition];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *controller = [super popViewControllerAnimated:animated];
    [self fixNavigationBarPosition];
    return controller;
}

- (void)fixNavigationBarPosition
{
    CGPoint navBarCenter = self.navigationBar.center;
    CGFloat navBarHeight = CGRectGetHeight(self.navigationBar.bounds);
    navBarCenter.y = navBarHeight / 2 + 20;
    self.navigationBar.center = navBarCenter;
}

@end
