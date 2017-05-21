//
//  DRPRefreshControl.h
//  DRPLoadingSpinner
//
//  Created by Justin Hill on 10/15/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

@import UIKit;

@class DRPLoadingSpinner;
@class ASTableNode;

@interface DRPRefreshControl : NSObject

/**
 *  @brief The underlying loading spinner. Customize this spinner to achieve the desired effect.
 */
@property (readonly) DRPLoadingSpinner *loadingSpinner;

/**
 *  @brief Adds the refresh control to the associated table view controller.
 *  @param tableViewController The table view controller to attach the refresh control to.
 *  @param refreshBlock A block to be called when the table view controller triggers a refresh.
 */
- (void)addToTableViewController:(UITableViewController *)tableViewController refreshBlock:(void (^)(void))refreshBlock;

/**
 *  @brief Adds the refresh control to the associated table view controller.
 *  @param tableViewController The table view controller to attach the refresh control to.
 *  @param target The target to call the selector on when the refresh control is triggered.
 *  @param selector The selector to call.
 */
- (void)addToTableViewController:(UITableViewController *)tableViewController target:(id)target selector:(SEL)selector;

/**
 *  @brief Adds the refresh control to the associated scroll view.
 *  @param scrollView The scroll view to attach the refresh control to.
 *  @param refreshBlock A block to be called when the scroll view triggers a refresh.
 *  @warning The refreshControl property is only available on UIScrollView on iOS 10 and up.
 */
- (void)addToScrollView:(UIScrollView *)scrollView refreshBlock:(void (^)(void))refreshBlock;

/**
 *  @brief Adds the refresh control to the associated scroll view.
 *  @param scrollView The scroll view to attach the refresh control to.
 *  @param target The target to call the selector on when the refresh control is triggered.
 *  @param selector The selector to call.
 *  @warning The refreshControl property is only available on UIScrollView on iOS 10 and up.
 */
- (void)addToScrollView:(UIScrollView *)scrollView target:(id)target selector:(SEL)selector;

/**
 *  @brief Removes the refresh control from its partner object, whether that be a table view controller, a collection
 *         view controller, or a scroll view.
 */
- (void)removeFromPartnerObject;

/**
 *  @brief Begins refreshing. If the attached scroll view is scrolled to the top, animates the loading spinner
 *         into view.
 */
- (void)beginRefreshing;

/**
 *  @brief Ends refreshing.
 */
- (void)endRefreshing;

@end
