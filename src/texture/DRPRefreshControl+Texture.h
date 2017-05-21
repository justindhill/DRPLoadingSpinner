//
//  DRPRefreshControl+Texture.h
//  DRPLoadingSpinner
//
//  Created by Justin Hill on 5/21/17.
//  Copyright © 2017 Justin Hill. All rights reserved.
//

#import "DRPRefreshControl.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface DRPRefreshControl (Texture) <ASTableDelegate>

- (void)addToTableNode:(ASTableNode *)tableNode refreshBlock:(void (^)(void))refreshBlock;
- (void)addToTableNode:(ASTableNode *)tableNode;

@end
