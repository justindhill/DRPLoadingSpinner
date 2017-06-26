//
//  DRPLoadingSpinner.h
//  DRPLoadingSpinner
//
//  Created by Justin Hill on 11/11/14.
//  Copyright (c) 2014 Justin Hill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRPLoadingSpinnerTimingFunction.h"
/**
 *  @brief The set of directions that DRPLoadingSpinner can spin
 */
typedef NS_ENUM(NSInteger, DRPRotationDirection) {
    DRPRotationDirectionClockwise,
    DRPRotationDirectionCounterClockwise
};

@interface DRPLoadingSpinner : UIView

/**
 *  @brief Which direction the spinner should spin. Defaults to clockwise.
 */
@property (nonatomic, assign) DRPRotationDirection rotationDirection;

/**
 *  @brief When the spinner is not animating, the length of the arc to be drawn. This can
 *         be used to implement things like pull-to-refresh as seen in DRPRefreshControl.
 */
@property (nonatomic, assign) CGFloat staticArcLength;

/**
 @brief When the arc is shrinking, how small it should get at a minimum in radians.
 */
@property (assign) CGFloat minimumArcLength;

/**
 *  @brief When the arc is growing, how large it should get at a maximum in radians
 */
@property (assign) CGFloat maximumArcLength;

/**
 *  @brief The width of the arc's line.
 */
@property (nonatomic) CGFloat lineWidth;

/**
 @brief How long in seconds it should take for the drawing to rotate 360 degrees.
        No easing function is applied to this duration, i.e. it is linear.
 */
@property (assign) CFTimeInterval rotationCycleDuration;

/**
 @brief How long in seconds it should take for a complete circle to be drawn
        or erased. An in-out easing function is applied to this duration.
 */
@property (assign) CFTimeInterval drawCycleDuration;

/**
 @brief The timing function that should be used for drawing the rail.
 */
@property (strong) CAMediaTimingFunction *drawTimingFunction;

/**
 @brief An array of UIColors that defines the colors the spinner will draw in
        and their order. The colors will loop back to the beginning when the
        cycle for the last color has been completed.
 */
@property (strong) NSArray<UIColor *> *colorSequence UI_APPEARANCE_SELECTOR;

/**
 @brief The color of the rail behind the spinner. Defaults to clear.
 */
@property (nonatomic) UIColor *backgroundRailColor;

/**
 @return YES if the spinner is animating, otherwise NO
 */
@property (readonly) BOOL isAnimating;

/**
 @brief Start animating.
 */
- (void)startAnimating;

/**
 @brief Stop animating and clear the drawing context.
 */
- (void)stopAnimating;

@end
