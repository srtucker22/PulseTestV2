/*
    File: ProcessViewController.m
Abstract: Controls display of video preview, color recognition rectangle, and settings controls.
 Version: 1.0

Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
Inc. ("Apple") in consideration of your agreement to the following
terms, and your use, installation, modification or redistribution of
this Apple software constitutes acceptance of these terms.  If you do
not agree with these terms, please do not use, install, modify or
redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and
subject to these terms, Apple grants you a personal, non-exclusive
license, under Apple's copyrights in this original Apple software (the
"Apple Software"), to use, reproduce, modify and redistribute the Apple
Software, with or without modifications, in source and/or binary forms;
provided that if you redistribute the Apple Software in its entirety and
without modifications, you must retain this notice and the following
text and disclaimers in all such redistributions of the Apple Software.
Neither the name, trademarks, service marks or logos of Apple Inc. may
be used to endorse or promote products derived from the Apple Software
without specific prior written permission from Apple.  Except as
expressly stated in this notice, no other rights or licenses, express or
implied, are granted by Apple herein, including but not limited to any
patent rights that may be infringed by your derivative works or by other
works in which the Apple Software may be incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

Copyright (C) 2010 Apple Inc. All Rights Reserved.

*/

#import "ProcessViewController.h"
#import "User.h"
#import "ResultsViewController.h"

@implementation ProcessViewController

@synthesize captureManager;
@synthesize overlayLayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        progressSize = 220/[[NSUserDefaults standardUserDefaults] integerForKey:@"timerLength"];
    }
    return self;
}

- (void)viewDidLoad {
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setToolbarHidden:YES];
    
	redrawDelta = 10;

	captureManager = [[CaptureSessionManager alloc] init];

	// Configure capture session
	[captureManager addVideoInput];
	[captureManager addVideoDataOutput];

	// Set up video preview layer
	[captureManager addVideoPreviewLayer];
	CGRect layerRect = self.view.layer.bounds;
	captureManager.previewLayer.bounds = layerRect;
	captureManager.previewLayer.position = CGPointMake(CGRectGetMidX(layerRect), CGRectGetMidY(layerRect));
	[self.view.layer addSublayer:captureManager.previewLayer];
	
	// Set up recognition rectangle overlay
	overlayLayer = [CALayer layer]; 
    CGRect frame = self.view.layer.bounds;
    frame.origin.x += 10.0f;
	frame.origin.y += 10.0f;
	frame.size.width = 20.0f;
	frame.size.height = 20.0f;
	overlayLayer.frame = frame;
    overlayLayer.backgroundColor = [[UIColor clearColor] CGColor];
	overlayLayer.delegate = self;
    [self.view.layer addSublayer:overlayLayer];
    
    // Set the cancel button
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-40, 0, 40, 40)];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(exitProcessView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    // Set the instructions label
    instructions = [[UILabel alloc]initWithFrame:CGRectMake(25, 25, self.view.frame.size.width - 50, 50)];
    instructions.backgroundColor = [UIColor blackColor];
    instructions.layer.cornerRadius = 10;
    [instructions setAlpha:0];
    instructions.textColor = [UIColor whiteColor];
    instructions.textAlignment = NSTextAlignmentCenter;
    [instructions setText:@"Click the heart to start!"];
    [instructions setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:20]];
    [self.view addSubview:instructions];
    
    // Set the heart background
    heartBackground = [[UIImageView alloc] initWithFrame:CGRectMake(160, 220, 0, 0)];
    [heartBackground setImage:[UIImage imageNamed:@"heart_icon_empty.png"]];
    [self.view addSubview:heartBackground];
    
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         heartBackground.frame = CGRectMake(35,95,250,250);
                     } completion:^(BOOL finished) {
                         // Start the animation
                         [UIView animateWithDuration:0.2
                                               delay:0.0
                                             options:UIViewAnimationCurveEaseOut
                                          animations:^{
                                              heartBackground.frame = CGRectMake(60,120,200,200);
                                          } completion:^(BOOL finished) {
                                              // Set the start button
                                              UIButton *startPulseCheckerButton = [[UIButton alloc] initWithFrame:heartBackground.frame];
                                              [startPulseCheckerButton addTarget:self action:@selector(startPulseChecker:) forControlEvents:UIControlEventTouchUpInside];
                                              [self.view addSubview:startPulseCheckerButton];
                                              
                                              // Start the animation
                                              [UIView animateWithDuration:0.5
                                                                    delay:0.0
                                                                  options:UIViewAnimationCurveEaseOut
                                                               animations:^{
                                                                   [instructions setAlpha:.5];
                                                               } completion:^(BOOL finished) {
                                                                   //Set the bounds properly
                                                                   maskLayer = [CALayer layer];
                                                                   UIImage *mask = [UIImage imageNamed:@"Default.png"];
                                                                   maskLayer.contents = (id)mask.CGImage;
                                                                   maskLayer.frame = CGRectMake(-250,0,250,250);
                                                                   
                                                                   heartProgress = [[UIImageView alloc] initWithFrame:CGRectMake(60, 120, 200, 200)];
                                                                   heartProgress.image = [UIImage imageNamed:@"heart_icon_inside.png"];
                                                                   heartProgress.layer.mask = maskLayer;
                                                                   [self.view addSubview:heartProgress];
                                                               }];
                                          }];
                         
                     }];
    
    // Set the time remaining label
    timeRemainingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 100)];
    [timeRemainingLabel setBackgroundColor:[UIColor clearColor]];
    [timeRemainingLabel setHidden:YES];
    [self.view addSubview:timeRemainingLabel];
	
	[captureManager.captureSession startRunning];

}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

-(IBAction)startPulseChecker:(id)sender
{
    NSLog(@"Oh yeah");
    
    // Remove the start button
    [sender removeFromSuperview];
    
    // Show progress
    [timeRemainingLabel setHidden:NO];
    
    // Start the animation
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         [instructions setAlpha:0];
                     } completion:^(BOOL finished) {
                         [instructions removeFromSuperview];
                     }];
    
    if (countdownTimer)
        return;
    
    remainingTicks = [[NSUserDefaults standardUserDefaults] integerForKey:@"timerLength"];
    [self updateTimeRemainingLabel];
    
    countdownTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector(handleTimerTick) userInfo: nil repeats: YES];
    
    [captureManager startRecordingPulse];
}

-(void)handleTimerTick;
{
    remainingTicks--;
    [self updateTimeRemainingLabel];
    
    if (remainingTicks <= 0) {
        [countdownTimer invalidate];
        countdownTimer = nil;
        [self stopPulseChecker];
    }
}

- (void) stopPulseChecker
{
    [captureManager stopRecordingPulse];
    [captureManager setTorchMode:AVCaptureTorchModeOff];
    [[User sharedUser] setPulseScore:captureManager.brightnessArray completionHandler:^(NSInteger pulse, NSError *error){
        if(!error)
        {
            [[User sharedUser] savePulse];
            
            ResultsViewController *resultsView = [[ResultsViewController alloc] initWithNibName:@"ResultsViewController" bundle:nil];
            [resultsView setScore:pulse];
            [self.navigationController pushViewController:resultsView animated:YES];
            NSLog(@"%@",error);
        }
    }];
}

- (void) updateTimeRemainingLabel
{
    [timeRemainingLabel setText:[NSString stringWithFormat:@"Time remaining: %i seconds", remainingTicks]];
    
    [UIView animateWithDuration:0.2
                          delay:0.6
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         heartBackground.transform = CGAffineTransformMakeScale(1.25, 1.25);
                         heartProgress.transform = CGAffineTransformMakeScale(1.25, 1.25);
                     } completion:^(BOOL finished) {
                         
                         // Prepare the animation from the current position to the new position
                         CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
                         animation.fromValue = [maskLayer valueForKey:@"position"];
                         
                         CGPoint point = CGPointMake(100-progressSize*remainingTicks, 120);
                         
                         // iOS
                         animation.toValue = [NSValue valueWithCGPoint:point];
                         
                         // Update the layer's bounds so the layer doesn't snap back when the animation completes.
                         maskLayer.position = point;
                         
                         // Add the animation, overriding the implicit animation.
                         [maskLayer addAnimation:animation forKey:@"position" ];
                         
                         [UIView animateWithDuration:0.2
                                               delay:0.0
                                             options:UIViewAnimationCurveEaseOut
                                          animations:^{
                                              heartBackground.transform = CGAffineTransformMakeScale(1, 1);
                                              heartProgress.transform = CGAffineTransformMakeScale(1, 1);
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
}

-(IBAction)exitProcessView:(id)sender
{
    NSLog(@"viewcontrollers %@", self.navigationController.viewControllers);
    NSLog(@"exiting processView");
    [captureManager stopRecordingPulse];
    [captureManager setTorchMode:AVCaptureTorchModeOff];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
