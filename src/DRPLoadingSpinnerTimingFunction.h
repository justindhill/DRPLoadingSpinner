//
//  DRPLoadingSpinnerTimingFunction.h
//  DRPLoadingSpinner
//
//  Created by Justin Hill on 3/21/17.
//  Copyright © 2017 Justin Hill. All rights reserved.
//

@import UIKit;

@interface DRPLoadingSpinnerTimingFunction : NSObject

+ (CAMediaTimingFunction *)linear;
+ (CAMediaTimingFunction *)easeIn;
+ (CAMediaTimingFunction *)easeOut;
+ (CAMediaTimingFunction *)easeInOut;
+ (CAMediaTimingFunction *)sharpEaseInOut;

@end
