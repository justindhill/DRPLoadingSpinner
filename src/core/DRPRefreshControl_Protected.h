//
//  DRPRefreshControl_Protected.h
//  DRPLoadingSpinner
//
//  Created by Justin Hill on 5/21/17.
//  Copyright © 2017 Justin Hill. All rights reserved.
//

#import "DRPRefreshControl.h"

@interface DRPRefreshControl ()

@property (strong) UIRefreshControl *refreshControl;
@property (weak) UIScrollView *scrollView;
@property (weak) id originalDelegate;
@property (strong) void (^refreshBlock)(void);
@property (weak) id refreshTarget;
@property (assign) SEL refreshSelector;

@end
