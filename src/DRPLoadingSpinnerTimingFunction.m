//
//  DRPLoadingSpinnerTimingFunction.m
//  DRPLoadingSpinner
//
//  Created by Justin Hill on 3/21/17.
//  Copyright © 2017 Justin Hill. All rights reserved.
//

#import "DRPLoadingSpinnerTimingFunction.h"

@implementation DRPLoadingSpinnerTimingFunction

+ (CAMediaTimingFunction *)linear {
    return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
}

+ (CAMediaTimingFunction *)easeIn {
    return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

}

+ (CAMediaTimingFunction *)easeOut {
    return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

}

+ (CAMediaTimingFunction *)easeInOut {
    return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

}

+ (CAMediaTimingFunction *)sharpEaseInOut {
    return [CAMediaTimingFunction functionWithControlPoints:0.62 :0.0 :0.38 :1.0];
}

@end
