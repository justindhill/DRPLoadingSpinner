//
//  DRPRefreshControl.m
//  DRPLoadingSpinner
//
//  Created by Justin Hill on 10/15/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

#import "DRPRefreshControl.h"
#import "DRPLoadingSpinner.h"

/**
 *  @brief After testing, this is what Apple believes is the perfect offset
 *         at which refreshing should commence.
 */
const CGFloat DRPMagicAppleRefreshOffset = -109.0;

@interface DRPRefreshControl () <UITableViewDelegate>

@property (strong) UIRefreshControl *refreshControl;
@property (strong) DRPLoadingSpinner *loadingSpinner;
@property (weak) id<UITableViewDelegate> originalDelegate;
@property (weak) UITableViewController *tableViewController;
@property (strong) void (^refreshBlock)(void);

@end

@implementation DRPRefreshControl

- (instancetype)init {
    if (self = [super init]) {
        self.loadingSpinner = [[DRPLoadingSpinner alloc] init];

        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(refreshControlTriggered:) forControlEvents:UIControlEventValueChanged];
        [self.refreshControl addSubview:self.loadingSpinner];
    }

    return self;
}

- (void)addToTableViewController:(UITableViewController *)tableViewController refreshBlock:(void (^)(void))refreshBlock {
    [self removeFromPartnerObject];

    self.tableViewController = tableViewController;
    self.refreshBlock = refreshBlock;

    self.tableViewController.refreshControl = self.refreshControl;
    [self.refreshControl.subviews.firstObject removeFromSuperview];
    
    self.originalDelegate = self.tableViewController.tableView.delegate;
    self.tableViewController.tableView.delegate = self;
}

- (void)removeFromPartnerObject {
    if (self.tableViewController) {
        self.tableViewController.tableView.delegate = self.originalDelegate;
        self.tableViewController.refreshControl = nil;
        self.tableViewController = nil;
    }
}

- (void)beginRefreshing {
    [self.refreshControl beginRefreshing];
}

- (void)endRefreshing {
    [self.loadingSpinner stopAnimating];
    [self.refreshControl endRefreshing];
}

- (void)refreshControlTriggered:(UIRefreshControl *)refreshControl {
    [self.loadingSpinner startAnimating];

    if (self.refreshBlock) {
        self.refreshBlock();
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.originalDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.originalDelegate scrollViewDidScroll:scrollView];
    }

    if (!self.refreshControl.hidden) {
        self.loadingSpinner.frame = CGRectMake(
            (self.refreshControl.frame.size.width - self.loadingSpinner.frame.size.width) / 2,
            (self.refreshControl.frame.size.height - self.loadingSpinner.frame.size.height) / 2,
            self.loadingSpinner.frame.size.width,
            self.loadingSpinner.frame.size.height
        );
    }
}

#pragma mark - UIScrollViewDelegate method forwarding
- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector] || [self.originalDelegate respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.originalDelegate;
}

@end
