//
//  DRPRefreshControl.h
//  DRPLoadingSpinner
//
//  Created by Justin Hill on 10/15/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

@import UIKit;

@class DRPLoadingSpinner;

@interface DRPRefreshControl : NSObject

/**
 *  @brief The underlying loading spinner. Customize this spinner to achieve the desired effect.
 */
@property (readonly) DRPLoadingSpinner *loadingSpinner;

/**
 *  @brief Adds the refresh control to the associated table view controller.
 *  @param refreshBlock A block to be called when the table view controller triggers a refresh.
 */
- (void)addToTableViewController:(UITableViewController *)tableViewController refreshBlock:(void (^)(void))refreshBlock;

/**
 *  @brief Removes the refresh control from its partner object, whether that be a table view controller, a collection
 *         view controller, or a scroll view.
 */
- (void)removeFromPartnerObject;

/**
 *  @brief Convenience API. This calls beginRefreshing on the underlying UIRefreshControl.
 */
- (void)beginRefreshing;

/**
 *  @brief Convenience API. This calls endRefreshing on the underlying UIRefreshControl.
 */
- (void)endRefreshing;

@end
