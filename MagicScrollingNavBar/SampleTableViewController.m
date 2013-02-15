//
//  SampleTableViewController.m
//  MagicScrollingNavBar
//
//  Created by Brian Nickel on 2/14/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import "SampleTableViewController.h"

@interface SampleTableViewController ()
@property (nonatomic)CGFloat initialScrollOffset;
@property (nonatomic)CGFloat initialNavBarOffset;
@property (nonatomic)CGFloat shouldListenToScrollEvent;
@end

@implementation SampleTableViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.title = @"Sample";
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Row %d", indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Section %d", section];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *child = [[[self class] alloc] init];
    child.title = [NSString stringWithFormat:@"Section %d, Row %d", indexPath.section, indexPath.row];
    [self.navigationController pushViewController:child animated:YES];
}

#pragma mark - Scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.initialScrollOffset = scrollView.contentOffset.y;
    self.initialNavBarOffset = self.navigationController.navigationBar.center.y;
    self.shouldListenToScrollEvent = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        self.shouldListenToScrollEvent = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.shouldListenToScrollEvent = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.shouldListenToScrollEvent) {
        return;
    }
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    CGFloat currentScrollOffset = scrollView.contentOffset.y;
    CGFloat scrollDelta = currentScrollOffset - self.initialScrollOffset;
    CGFloat navBarOffset = self.initialNavBarOffset - scrollDelta;
    
    CGFloat navBarHeight = CGRectGetHeight(navBar.bounds);
    
    CGPoint navBarCenter = navBar.center;
    navBarCenter.y = MIN(navBarHeight / 2 + 20, MAX(-navBarHeight / 2 + 20, navBarOffset));
    navBar.center = navBarCenter;
}

@end
