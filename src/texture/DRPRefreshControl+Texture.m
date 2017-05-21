//
//  DRPRefreshControl+Texture.m
//  DRPLoadingSpinner
//
//  Created by Justin Hill on 5/21/17.
//  Copyright © 2017 Justin Hill. All rights reserved.
//

#import "DRPRefreshControl+Texture.h"
#import "DRPRefreshControl_Protected.h"

@implementation DRPRefreshControl (Texture)

- (void)addToTableNode:(ASTableNode *)tableNode refreshBlock:(void (^)(void))refreshBlock {
    [self addToTableNode:tableNode];
    self.refreshBlock = refreshBlock;
}

- (void)addToTableNode:(ASTableNode *)tableNode {
    [self removeFromPartnerObject];
    self.scrollView = tableNode.view;
    self.scrollView.refreshControl = self.refreshControl;
    [self.refreshControl.subviews.firstObject removeFromSuperview];
    
    self.originalDelegate = tableNode.delegate;
    tableNode.delegate = self;
}

@end
