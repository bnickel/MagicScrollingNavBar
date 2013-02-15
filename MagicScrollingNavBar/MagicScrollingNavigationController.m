//
//  MagicScrollingNavigationController.m
//  MagicScrollingNavBar
//
//  Created by Brian Nickel on 2/14/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import "MagicScrollingNavigationController.h"

@interface MagicScrollingNavigationController ()
@property (nonatomic)CGFloat initialScrollOffset;
@property (nonatomic)CGFloat initialNavBarOffset;
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

#pragma mark - Scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.initialScrollOffset = scrollView.contentOffset.y;
    self.initialNavBarOffset = self.navigationBar.center.y;
    self.scrollViewOfInterest = scrollView;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate && scrollView == self.scrollViewOfInterest) {
        self.scrollViewOfInterest = nil;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollViewOfInterest) {
        self.scrollViewOfInterest = nil;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.scrollViewOfInterest != scrollView) {
        return;
    }
    
    UINavigationBar *navBar = self.navigationBar;
    CGFloat currentScrollOffset = scrollView.contentOffset.y;
    CGFloat scrollDelta = currentScrollOffset - self.initialScrollOffset;
    CGFloat navBarOffset = self.initialNavBarOffset - scrollDelta;
    
    CGFloat navBarHeight = CGRectGetHeight(navBar.bounds);
    
    CGPoint navBarCenter = navBar.center;
    navBarCenter.y = MIN(navBarHeight / 2 + 20, MAX(-navBarHeight / 2 + 20, navBarOffset));
    navBar.center = navBarCenter;
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
