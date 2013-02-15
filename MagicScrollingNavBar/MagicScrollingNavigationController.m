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
    [self fixNavigationBarPositionAnimated:animated];
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    [super setViewControllers:viewControllers];
    [self fixNavigationBarPositionAnimated:NO];
}

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated
{
    [super setViewControllers:viewControllers animated:animated];
    [self fixNavigationBarPositionAnimated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *controller = [super popViewControllerAnimated:animated];
    [self fixNavigationBarPositionAnimated:animated];
    return controller;
}

- (void)fixNavigationBarPositionAnimated:(BOOL)animated
{
    __weak UINavigationBar *navBar = self.navigationBar;
    CGPoint navBarCenter = navBar.center;
    CGFloat navBarHeight = CGRectGetHeight(navBar.bounds);
    CGFloat newNavBarCenterY = navBarHeight / 2 + 20;
    
    // If the difference between the current and the new center is more than half a pixel, animate to the new position.
    if (ABS(newNavBarCenterY - navBarCenter.y) > 0.5 && animated) {
        navBarCenter.y = newNavBarCenterY;
        
        [UIView animateWithDuration:0.35 animations:^{
            navBar.center = navBarCenter;
        }];
    } else {
        navBar.center = navBarCenter;
    }
}

@end
