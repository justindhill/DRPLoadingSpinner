//
//  DRPLoadingSpinner.m
//  DRPLoadingSpinner
//
//  Created by Justin Hill on 11/11/14.
//  Copyright (c) 2014 Justin Hill. All rights reserved.
//

#import "DRPLoadingSpinner.h"

#define kInvalidatedTimestamp -1

@interface DRPLoadingSpinner () <CAAnimationDelegate>

@property BOOL isAnimating;
@property NSUInteger colorIndex;
@property CAShapeLayer *foregroundRailLayer;
@property CAShapeLayer *backgroundRailLayer;
@property BOOL isFirstCycle;

@end

@implementation DRPLoadingSpinner

#pragma mark - Life cycle
- (instancetype)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, 25, 25)]) {
        [self setup];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }

    return self;
}

- (void)setup {
    self.foregroundRailLayer = [[CAShapeLayer alloc] init];
    self.backgroundRailLayer = [[CAShapeLayer alloc] init];
    
    self.drawCycleDuration = 0.75;
    self.rotationCycleDuration = 1.5;
    self.staticArcLength = 0;
    self.maximumArcLength = (2 * M_PI) - M_PI_4;
    self.minimumArcLength = 0.1;
    self.lineWidth = 2.;
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    
    self.drawTimingFunction = [DRPLoadingSpinnerTimingFunction easeInOut];
    
    self.colorSequence = @[
        [UIColor redColor],
        [UIColor orangeColor],
        [UIColor purpleColor],
        [UIColor blueColor]
    ];
    
    self.backgroundRailLayer.fillColor = [UIColor clearColor].CGColor;
    self.backgroundRailLayer.strokeColor = [UIColor clearColor].CGColor;
    
    self.foregroundRailLayer.fillColor = [UIColor clearColor].CGColor;
    self.foregroundRailLayer.anchorPoint = CGPointMake(.5, .5);
    self.foregroundRailLayer.strokeColor = self.colorSequence.firstObject.CGColor;
    self.foregroundRailLayer.hidden = YES;

    self.foregroundRailLayer.actions = @{
        @"lineWidth": [NSNull null],
        @"strokeEnd": [NSNull null],
        @"strokeStart": [NSNull null],
        @"transform": [NSNull null],
        @"hidden": [NSNull null]
    };

    // If we have an apperance specified, then use it to override the defaults.
    if(nil != [DRPLoadingSpinner appearance].colorSequence)
    {
        self.colorSequence = [DRPLoadingSpinner appearance].colorSequence;
    }

    [self refreshCircleFrame];
}

#pragma mark - Accessors
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self refreshCircleFrame];
//    [self insertPlane:self.foregroundRailLayer];
}

- (void)setStaticArcLength:(CGFloat)staticArcLength {
    _staticArcLength = staticArcLength;

    if (!self.isAnimating) {
        self.foregroundRailLayer.hidden = NO;
        self.foregroundRailLayer.strokeColor = self.colorSequence.firstObject.CGColor;
        self.foregroundRailLayer.strokeStart = 0;
        self.foregroundRailLayer.strokeEnd = [self proportionFromArcLengthRadians:staticArcLength];
        self.foregroundRailLayer.transform = CATransform3DRotate(CATransform3DIdentity, -M_PI_2, 0, 0, 1);
    }
}

- (void)setLineWidth:(CGFloat)lineWidth {
    self.foregroundRailLayer.lineWidth = lineWidth;
    self.backgroundRailLayer.lineWidth = lineWidth;
}

- (CGFloat)lineWidth {
    return self.foregroundRailLayer.lineWidth;
}

- (void)setBackgroundRailColor:(UIColor *)backgroundRailColor {
    self.backgroundRailLayer.strokeColor = backgroundRailColor.CGColor;
}

- (UIColor *)backgroundRailColor {
    return [UIColor colorWithCGColor:self.backgroundRailLayer.strokeColor];
}

#pragma mark - Layout
//- (void)insertPlane:(CALayer *)layer {
//    [layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
//
//    CALayer *top = [[CALayer alloc] init];
//    top.backgroundColor = UIColor.cyanColor.CGColor;
//    top.frame = CGRectMake(layer.frame.size.width/2, 0, 1, layer.frame.size.height/2);
//    [layer addSublayer:top];
//
//    CALayer *bottom = [[CALayer alloc] init];
//    bottom.backgroundColor = UIColor.magentaColor.CGColor;
//    bottom.frame = CGRectMake(layer.frame.size.width/2, layer.frame.size.height/2, 1, layer.frame.size.height/2);
//    [layer addSublayer:bottom];
//
//    CALayer *left = [[CALayer alloc] init];
//    left.backgroundColor = UIColor.yellowColor.CGColor;
//    left.frame = CGRectMake(0, layer.frame.size.height/2, layer.frame.size.width/2, 1);
//    [layer addSublayer:left];
//
//    CALayer *right = [[CALayer alloc] init];
//    right.backgroundColor = UIColor.blackColor.CGColor;
//    right.frame = CGRectMake(layer.frame.size.width/2, layer.frame.size.height/2, layer.frame.size.width/2, 1);
//    [layer addSublayer:right];
//}

- (void)refreshCircleFrame {
    CGFloat sideLen = MIN(self.layer.frame.size.width, self.layer.frame.size.height) - (2 * self.lineWidth);
    CGFloat xOffset = ceilf((self.frame.size.width - sideLen) / 2.0);
    CGFloat yOffset = ceilf((self.frame.size.height - sideLen) / 2.0);
    
    self.foregroundRailLayer.frame = CGRectMake(xOffset, yOffset, sideLen, sideLen);
    self.foregroundRailLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, sideLen, sideLen)].CGPath;
    
    self.backgroundRailLayer.frame = CGRectMake(xOffset, yOffset, sideLen, sideLen);
    self.backgroundRailLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, sideLen, sideLen)].CGPath;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    
    if (!self.backgroundRailLayer.superlayer) {
        [self.layer addSublayer:self.backgroundRailLayer];
    }
    
    if (!self.foregroundRailLayer.superlayer) {
        [self.layer addSublayer:self.foregroundRailLayer];
    }
}

#pragma mark - Animation control
- (void)startAnimating {
    [self stopAnimating];
    self.foregroundRailLayer.hidden = NO;
    
    self.isAnimating = YES;
    self.isFirstCycle = YES;
    self.foregroundRailLayer.strokeEnd = [self proportionFromArcLengthRadians:self.minimumArcLength];
    
    self.colorIndex = 0;
    self.foregroundRailLayer.strokeColor = [self.colorSequence[self.colorIndex] CGColor];
    
    [self addAnimationsToLayer:self.foregroundRailLayer reverse:NO rotationOffset:-M_PI_2];
}

- (void)stopAnimating {
    self.isAnimating = NO;
    self.foregroundRailLayer.hidden = YES;
    [self.foregroundRailLayer removeAllAnimations];
}

#pragma mark - Auto Layout
- (CGSize)intrinsicContentSize {
    return CGSizeMake(40, 40);
}

#pragma mark

- (void)addAnimationsToLayer:(CAShapeLayer *)layer reverse:(BOOL)reverse rotationOffset:(CGFloat)rotationOffset {

    CABasicAnimation *strokeAnimation;
    CGFloat strokeDuration = self.drawCycleDuration;
    CGFloat currentDistanceToStrokeStart = 2 * M_PI * layer.strokeStart;

    if (reverse) {
        [CATransaction begin];

        strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        CGFloat newStrokeStart = self.maximumArcLength - self.minimumArcLength;

        layer.strokeEnd = [self proportionFromArcLengthRadians:self.maximumArcLength];
        layer.strokeStart = [self proportionFromArcLengthRadians:newStrokeStart];

        strokeAnimation.fromValue = @(0);
        strokeAnimation.toValue = @([self proportionFromArcLengthRadians:newStrokeStart]);

    } else {
        CGFloat strokeFromValue = self.minimumArcLength;
        CGFloat rotationStartRadians = rotationOffset;

        if (self.isFirstCycle) {
            if (self.staticArcLength > 0) {
                if (self.staticArcLength > self.maximumArcLength) {
                    NSLog(@"DRPLoadingSpinner: staticArcLength is set to a value greater than maximumArcLength. You probably didn't mean to do this.");
                }

                strokeFromValue = self.staticArcLength;
                strokeDuration *= (self.staticArcLength / self.maximumArcLength);
            }

            self.isFirstCycle = NO;
        } else {
            rotationStartRadians += currentDistanceToStrokeStart;
        }

        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.fromValue = @(rotationStartRadians);
        rotationAnimation.toValue = @(rotationStartRadians + (2 * M_PI));
        rotationAnimation.timingFunction = [DRPLoadingSpinnerTimingFunction linear];
        rotationAnimation.duration = self.rotationCycleDuration;
        rotationAnimation.repeatCount = HUGE_VALF;
        rotationAnimation.fillMode = kCAFillModeForwards;

        [layer removeAnimationForKey:@"rotation"];
        [layer addAnimation:rotationAnimation forKey:@"rotation"];


        [CATransaction begin];

        strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeAnimation.fromValue = @([self proportionFromArcLengthRadians:strokeFromValue]);
        strokeAnimation.toValue = @([self proportionFromArcLengthRadians:self.maximumArcLength]);

        layer.strokeStart = 0;
        layer.strokeEnd = [strokeAnimation.toValue doubleValue];
    }

    strokeAnimation.delegate = self;
    strokeAnimation.fillMode = kCAFillModeForwards;
    strokeAnimation.timingFunction = self.drawTimingFunction;
    [CATransaction setAnimationDuration:strokeDuration];

    [layer removeAnimationForKey:@"stroke"];
    [layer addAnimation:strokeAnimation forKey:@"stroke"];

    [CATransaction commit];
}

- (void)advanceColorSequence {
    self.colorIndex = (self.colorIndex + 1) % self.colorSequence.count;
    self.foregroundRailLayer.strokeColor = [self.colorSequence[self.colorIndex] CGColor];
}

- (CGFloat)proportionFromArcLengthRadians:(CGFloat)radians {
    return ((fmodf(radians, 2 * M_PI)) / (2 * M_PI));
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)finished {
    if (finished && [anim isKindOfClass:[CABasicAnimation class]]) {
        CABasicAnimation *basicAnim = (CABasicAnimation *)anim;
        BOOL isStrokeStart = [basicAnim.keyPath isEqualToString:@"strokeStart"];
        BOOL isStrokeEnd = [basicAnim.keyPath isEqualToString:@"strokeEnd"];

        CGFloat rotationOffset = fmodf([[self.foregroundRailLayer.presentationLayer valueForKeyPath:@"transform.rotation.z"] floatValue], 2 * M_PI);
        [self addAnimationsToLayer:self.foregroundRailLayer reverse:isStrokeEnd rotationOffset:rotationOffset];
        
        if (isStrokeStart) {
            [self advanceColorSequence];
        }
    }
}

@end
