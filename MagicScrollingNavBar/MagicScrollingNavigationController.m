//
//  MagicScrollingNavigationController.m
//  MagicScrollingNavBar
//
//  Created by Brian Nickel on 2/14/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import "MagicScrollingNavigationController.h"

@interface MagicScrollingNavigationController ()
@property (nonatomic)CGFloat lastScrollOffset;
@property (nonatomic, weak)UIScrollView *scrollViewOfInterest;
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

- (void)fixNavigationBarIfPartiallyObscured
{
    __weak UINavigationBar *navBar = self.navigationBar;
    CGPoint navBarCenter = navBar.center;
    CGFloat navBarHeight = CGRectGetHeight(navBar.bounds);
    
    CGFloat minNavBarCenterY = -navBarHeight / 2 + 20;
    if (ABS(navBarCenter.y - minNavBarCenterY) > 0.5) {
        
        navBarCenter.y = navBarHeight / 2 + 20;
        
        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
            navBar.center = navBarCenter;
        }];
    }
}

#pragma mark - Scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.lastScrollOffset = scrollView.contentOffset.y;
    self.scrollViewOfInterest = scrollView;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate && scrollView == self.scrollViewOfInterest) {
        self.scrollViewOfInterest = nil;
        [self fixNavigationBarIfPartiallyObscured];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollViewOfInterest) {
        self.scrollViewOfInterest = nil;
        [self fixNavigationBarIfPartiallyObscured];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.scrollViewOfInterest != scrollView) {
        return;
    }
    
    UINavigationBar *navBar = self.navigationBar;
    CGFloat currentScrollOffset = scrollView.contentOffset.y;
    CGFloat scrollDelta = currentScrollOffset - self.lastScrollOffset;
    
    CGFloat navBarHeight = CGRectGetHeight(navBar.bounds);
    
    CGPoint navBarCenter = navBar.center;
    navBarCenter.y = MIN(navBarHeight / 2 + 20, MAX(-navBarHeight / 2 + 20, navBarCenter.y - scrollDelta));
    navBar.center = navBarCenter;
    
    self.lastScrollOffset = currentScrollOffset;
}

@end

@implementation UIViewController (MagicScrollingNavigationController)

- (MagicScrollingNavigationController *)magicScrollingNavController
{
    UINavigationController *navigationController = self.navigationController;
    if ([navigationController isKindOfClass:[MagicScrollingNavigationController class]]) {
        return (MagicScrollingNavigationController *)navigationController;
    }
    return nil;
}

@end
