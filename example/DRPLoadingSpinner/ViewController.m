//
//  ViewController.m
//  DRPLoadingSpinner
//
//  Created by Justin Hill on 11/11/14.
//  Copyright (c) 2014 Justin Hill. All rights reserved.
//

#import "ViewController.h"
#import "DRPLoadingSpinner.h"

@interface ViewController ()

@property (strong) DRPLoadingSpinner *spinner;
@property (strong) DRPLoadingSpinner *spinner2;
@property (strong) DRPLoadingSpinner *spinner3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.spinner = [[DRPLoadingSpinner alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    self.spinner.center = self.view.center;
    self.spinner.rotationCycleDuration = 1;
    self.spinner.drawCycleDuration = .5;
    self.spinner.lineWidth = 2;
    self.spinner.colorSequence = @[[UIColor colorWithRed:64.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1]];
    self.spinner.maximumArcLength = M_PI / 3;
    self.spinner.minimumArcLength = M_PI / 3;
    self.spinner.backgroundRailColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
    self.spinner.rotationDirection = DRPRotationDirectionCounterClockwise;
    [self.view addSubview:self.spinner];
    
    self.spinner2 = [[DRPLoadingSpinner alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    self.spinner2.rotationCycleDuration = 1.5;
    self.spinner2.drawCycleDuration = 0.75;
    self.spinner2.drawTimingFunction = [DRPLoadingSpinnerTimingFunction sharpEaseInOut];
    [self.view addSubview:self.spinner2];
    
    CGRect spinner2Frame = self.spinner.frame;
    spinner2Frame.origin.y -= 60;
    self.spinner2.frame = spinner2Frame;
    
    self.spinner3 = [[DRPLoadingSpinner alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    self.spinner3.rotationCycleDuration = 500000;
    self.spinner3.minimumArcLength = M_PI / 2.;
    self.spinner3.maximumArcLength = M_PI;
    self.spinner3.drawCycleDuration = 0.5;
    self.spinner3.drawTimingFunction = [DRPLoadingSpinnerTimingFunction easeInOut];
    self.spinner3.colorSequence = @[ [UIColor lightGrayColor] ];
    self.spinner3.lineWidth = 2.;
    
    [self.view addSubview:self.spinner3];
    
    CGRect spinner3Frame = self.spinner.frame;
    spinner3Frame.origin.y += 60;
    spinner3Frame.size = CGSizeMake(25, 25);
    self.spinner3.frame = spinner3Frame;
    
    UIButton *toggleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [toggleButton setTitle:@"Toggle animation" forState:UIControlStateNormal];
    [toggleButton addTarget:self action:@selector(toggleAnimation) forControlEvents:UIControlEventTouchUpInside];
    [toggleButton sizeToFit];
    
    [self.view addSubview:toggleButton];
    
    toggleButton.center = self.view.center;
    
    CGRect shiftedToggleFrame = toggleButton.frame;
    shiftedToggleFrame.origin.y += 100;
    toggleButton.frame = shiftedToggleFrame;
    
    [self.spinner startAnimating];
    [self.spinner2 startAnimating];
    [self.spinner3 startAnimating];
}

- (void)toggleAnimation {
    if (self.spinner.isAnimating) {
        [self.spinner stopAnimating];
        [self.spinner2 stopAnimating];
        [self.spinner3 stopAnimating];
    } else {
        [self.spinner startAnimating];
        [self.spinner2 startAnimating];
        [self.spinner3 startAnimating];
    }
}

@end
