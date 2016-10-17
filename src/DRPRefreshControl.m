//
//  DRPRefreshControl.m
//  DRPLoadingSpinner
//
//  Created by Justin Hill on 10/15/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

#import "DRPRefreshControl.h"
#import "DRPLoadingSpinner.h"

@interface DRPRefreshControl () <UITableViewDelegate>

@property (strong) UIRefreshControl *refreshControl;
@property (strong) DRPLoadingSpinner *loadingSpinner;
@property (weak) id<UITableViewDelegate> originalDelegate;
@property (weak) UITableViewController *tableViewController;
@property (strong) void (^refreshBlock)(void);
@property BOOL awaitingRefreshEnd;

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
    BOOL adjustScrollOffset = (self.tableViewController.tableView.contentInset.top == -self.tableViewController.tableView.contentOffset.y);

    self.loadingSpinner.hidden = NO;
    [self.refreshControl beginRefreshing];
    [self refreshControlTriggered:self.refreshControl];

    if (adjustScrollOffset) {
        [self.tableViewController.tableView setContentOffset:CGPointMake(0, -self.tableViewController.tableView.contentInset.top) animated:YES];
    }
}

- (void)endRefreshing {
    __weak DRPRefreshControl *weakSelf = self;

    if (self.tableViewController.tableView.isDragging) {
        [self.refreshControl endRefreshing];
        return;
    }

    self.awaitingRefreshEnd = YES;
    NSString * const animationGroupKey = @"animationGroupKey";

    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [weakSelf.loadingSpinner stopAnimating];
        [weakSelf.loadingSpinner.layer removeAnimationForKey:animationGroupKey];


        if (!weakSelf.tableViewController.tableView.isDecelerating) {
            weakSelf.awaitingRefreshEnd = NO;
        }
    }];

    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D scaleTransform = CATransform3DScale(CATransform3DIdentity, 0.25, 0.25, 1);
    scale.toValue = [NSValue valueWithCATransform3D:scaleTransform];

    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.toValue = @(0);

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[ scale, opacity ];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    
    [self.loadingSpinner.layer addAnimation:group forKey:animationGroupKey];
    [CATransaction commit];

    [self.refreshControl endRefreshing];
}

- (void)refreshControlTriggered:(UIRefreshControl *)refreshControl {
    [self.loadingSpinner startAnimating];

    if (self.refreshBlock) {
        self.refreshBlock();
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.originalDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.originalDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }

    if (self.loadingSpinner.isAnimating && !self.refreshControl.isRefreshing) {
        [self endRefreshing];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.originalDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.originalDelegate scrollViewDidEndDecelerating:scrollView];
    }

    if (!self.refreshControl.isRefreshing) {
        self.awaitingRefreshEnd = NO;
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

    if (!self.awaitingRefreshEnd) {
        self.loadingSpinner.hidden = NO;

        const CGFloat stretchLength = M_PI_2 + M_PI_4;
        CGFloat draggedOffset = scrollView.contentInset.top + scrollView.contentOffset.y;
        CGFloat percentToThreshold = draggedOffset / [self appleMagicOffset];

        self.loadingSpinner.staticArcLength = MIN(percentToThreshold * stretchLength, stretchLength);
    }
}

/**
 *  @brief After testing, this is what Apple believes is the perfect offset
 *         at which refreshing should commence.
 */
- (CGFloat)appleMagicOffset {
    __block NSInteger majorOSVersion;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        majorOSVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] firstObject] integerValue];
    });

    if (majorOSVersion <= 9) {
        return -109.0;
    } else {
        return -129.0;
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
