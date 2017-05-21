//
//  DRPRefreshControl.m
//  DRPLoadingSpinner
//
//  Created by Justin Hill on 10/15/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

#import "DRPRefreshControl.h"
#import "DRPLoadingSpinner.h"
#import "DRPRefreshControl_Protected.h"

@interface DRPRefreshControl () <UIScrollViewDelegate>

@property (strong) DRPLoadingSpinner *loadingSpinner;
@property (weak) UITableViewController *tableViewController;
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
    [self addToTableViewController:tableViewController];
    self.refreshBlock = refreshBlock;
}

- (void)addToTableViewController:(UITableViewController *)tableViewController target:(id)target selector:(SEL)selector {
    [self addToTableViewController:tableViewController];
    self.refreshTarget = target;
    self.refreshSelector = selector;
}

- (void)addToTableViewController:(UITableViewController *)tableViewController {
    [self removeFromPartnerObject];
    
    self.tableViewController = tableViewController;
    self.scrollView = self.tableViewController.tableView;

    self.tableViewController.refreshControl = self.refreshControl;
    [self.refreshControl.subviews.firstObject removeFromSuperview];
    
    self.originalDelegate = self.scrollView.delegate;
    self.scrollView.delegate = self;
}

- (void)addToScrollView:(UIScrollView *)scrollView refreshBlock:(void (^)(void))refreshBlock {
    [self addToScrollView:scrollView];
    self.refreshBlock = refreshBlock;
}

- (void)addToScrollView:(UIScrollView *)scrollView target:(id)target selector:(SEL)selector {
    [self addToScrollView:scrollView];
    self.refreshTarget = target;
    self.refreshSelector = selector;
}

- (void)addToScrollView:(UIScrollView *)scrollView {
    NSAssert([scrollView respondsToSelector:@selector(refreshControl)], @"refreshControl is only available on UIScrollView on iOS 10 and up.");
    
    [self removeFromPartnerObject];
    self.scrollView = scrollView;
    self.scrollView.refreshControl = self.refreshControl;
    [self.refreshControl.subviews.firstObject removeFromSuperview];

    self.originalDelegate = self.scrollView.delegate;
    self.scrollView.delegate = self;
}

- (void)removeFromPartnerObject {
    if (self.tableViewController) {
        self.tableViewController.refreshControl = nil;
        self.tableViewController = nil;
    }

    self.refreshTarget = nil;
    self.refreshSelector = NULL;

    self.scrollView.delegate = self.originalDelegate;
    self.scrollView = nil;
}

- (void)beginRefreshing {
    BOOL adjustScrollOffset = (self.scrollView.contentInset.top == -self.scrollView.contentOffset.y);

    self.loadingSpinner.hidden = NO;
    [self.refreshControl beginRefreshing];
    [self refreshControlTriggered:self.refreshControl];

    if (adjustScrollOffset) {
        [self.scrollView setContentOffset:CGPointMake(0, -self.scrollView.contentInset.top) animated:YES];
    }
}

- (void)endRefreshing {
    __weak DRPRefreshControl *weakSelf = self;

    if (self.scrollView.isDragging) {
        [self.refreshControl endRefreshing];
        return;
    }

    self.awaitingRefreshEnd = YES;
    NSString * const animationGroupKey = @"animationGroupKey";

    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [weakSelf.loadingSpinner stopAnimating];
        [weakSelf.loadingSpinner.layer removeAnimationForKey:animationGroupKey];


        if (!weakSelf.scrollView.isDecelerating) {
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
    } else if (self.refreshTarget && self.refreshSelector) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.refreshTarget performSelector:self.refreshSelector withObject:self];
        #pragma clang diagnostic pop
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
