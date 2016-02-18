//
//  DRPLoadingSpinner.m
//  DRPLoadingSpinner
//
//  Created by Justin Hill on 11/11/14.
//  Copyright (c) 2014 Justin Hill. All rights reserved.
//

#import "DRPLoadingSpinner.h"

#define kInvalidatedTimestamp -1

@interface DRPLoadingSpinner ()

@property BOOL isAnimating;
@property NSUInteger colorIndex;
@property CAShapeLayer *circleLayer;
@property CGFloat drawRotationOffsetRadians;
@property BOOL isFirstCycle;

@end

@implementation DRPLoadingSpinner

#pragma mark - Life cycle
- (instancetype)init {
    if (self = [super initWithFrame:CGRectZero]) {
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
    self.drawCycleDuration = 1;
    self.rotationCycleDuration = 2;
    self.minimumArcLength = M_PI_4;
    self.lineWidth = 2.;
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    
    self.colorSequence = @[
        [UIColor redColor],
        [UIColor orangeColor],
        [UIColor purpleColor],
        [UIColor blueColor]
    ];
    
    self.circleLayer = [[CAShapeLayer alloc] init];
    self.circleLayer.fillColor = [UIColor clearColor].CGColor;
    self.circleLayer.anchorPoint = CGPointMake(.5, .5);
    self.circleLayer.hidden = YES;
    [self refreshCircleFrame];
}

#pragma mark - Accessors
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self refreshCircleFrame];
}

#pragma mark - Layout
- (void)refreshCircleFrame {
    CGFloat sideLen = MIN(self.layer.frame.size.width, self.layer.frame.size.height) - (2 * self.lineWidth);
    CGFloat xOffset = ceilf((self.frame.size.width - sideLen) / 2.0);
    CGFloat yOffset = ceilf((self.frame.size.height - sideLen) / 2.0);
    
    self.circleLayer.frame = CGRectMake(xOffset, yOffset, sideLen, sideLen);
    self.circleLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, sideLen, sideLen)].CGPath;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    
    if (!self.circleLayer.superlayer) {
        [self.layer addSublayer:self.circleLayer];
    }
}

#pragma mark - Animation control
- (void)startAnimating {
    
    NSAssert(self.minimumArcLength > CGFLOAT_MIN, @"minimumArcLength must be set to a value > CGFLOAT_MIN. This value can be only slightly greater than CGFLOAT_MIN, but must be greater.");
    
    self.circleLayer.hidden = NO;
    [self.circleLayer removeAllAnimations];
    
    self.isAnimating = YES;
    self.isFirstCycle = YES;
    self.circleLayer.lineWidth = self.lineWidth;
    self.circleLayer.strokeEnd = [self proportionFromArcLengthRadians:self.minimumArcLength];
    
    self.colorIndex = 0;
    self.circleLayer.strokeColor = [self.colorSequence[self.colorIndex] CGColor];
    
    self.drawRotationOffsetRadians = -M_PI_2;
    self.circleLayer.actions = @{
        @"transform": [NSNull null],
        @"hidden": [NSNull null]
    };
    
    [self addAnimationsToLayer:self.circleLayer reverse:NO];
}

- (void)stopAnimating {
    self.isAnimating = NO;
    [self.circleLayer removeAllAnimations];
    self.circleLayer.hidden = YES;
}

#pragma mark - Auto Layout
- (CGSize)intrinsicContentSize {
    return CGSizeMake(40, 40);
}

#pragma mark

- (void)addAnimationsToLayer:(CAShapeLayer *)layer reverse:(BOOL)reverse {
    
    CGFloat maxArcLengthRadians = (2 * M_PI) - self.minimumArcLength;
    CABasicAnimation *strokeAnimation;
    
    if (reverse) {
        [CATransaction begin];
        
        strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        CGFloat newStrokeStart = maxArcLengthRadians - self.minimumArcLength;
        
        layer.strokeEnd = [self proportionFromArcLengthRadians:maxArcLengthRadians];
        layer.strokeStart = [self proportionFromArcLengthRadians:newStrokeStart];
        
        strokeAnimation.fromValue = @(0);
        strokeAnimation.toValue = @([self proportionFromArcLengthRadians:newStrokeStart]);
        
    } else {
        if (!self.isFirstCycle) {
            self.drawRotationOffsetRadians -= (2 * self.minimumArcLength);
        }
        
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.fromValue = @(self.drawRotationOffsetRadians);
        rotationAnimation.toValue = @(self.drawRotationOffsetRadians + (2 * M_PI));
        rotationAnimation.duration = self.rotationCycleDuration;
        rotationAnimation.repeatCount = CGFLOAT_MAX;
        rotationAnimation.fillMode = kCAFillModeForwards;
        [layer addAnimation:rotationAnimation forKey:nil];
        
        [CATransaction begin];
        
        strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeAnimation.fromValue = @([self proportionFromArcLengthRadians:self.minimumArcLength]);
        strokeAnimation.toValue = @([self proportionFromArcLengthRadians:maxArcLengthRadians]);
        
        layer.strokeStart = 0;
        layer.strokeEnd = [strokeAnimation.toValue doubleValue];
    }
    
    strokeAnimation.delegate = self;
    strokeAnimation.fillMode = kCAFillModeForwards;
    strokeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [CATransaction setAnimationDuration:self.drawCycleDuration];
    [layer removeAnimationForKey:@"strokeEnd"];
    [layer removeAnimationForKey:@"strokeStart"];
    
    [layer addAnimation:strokeAnimation forKey:nil];
    
    [CATransaction commit];
    
    self.isFirstCycle = NO;
}

- (void)advanceColorSequence {
    self.colorIndex = (self.colorIndex + 1) % self.colorSequence.count;
    self.circleLayer.strokeColor = [self.colorSequence[self.colorIndex] CGColor];
}

- (CGFloat)proportionFromArcLengthRadians:(CGFloat)radians {
    return ((fmodf(radians, 2 * M_PI)) / (2 * M_PI));
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)finished {
    if (finished && [anim isKindOfClass:[CABasicAnimation class]]) {
        CABasicAnimation *basicAnim = (CABasicAnimation *)anim;
        BOOL isStrokeStart = [basicAnim.keyPath isEqualToString:@"strokeStart"];
        BOOL isStrokeEnd = [basicAnim.keyPath isEqualToString:@"strokeEnd"];
        
        [self addAnimationsToLayer:self.circleLayer reverse:isStrokeEnd];
        
        if (isStrokeStart) {
            [self advanceColorSequence];
        }
    }
}

@end
