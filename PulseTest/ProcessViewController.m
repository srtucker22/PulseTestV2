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

- (void)viewDidLoad {
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
    
    UIButton *startPulseCheckerButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 100, 200, 200)];
    [startPulseCheckerButton setBackgroundImage:[UIImage imageNamed:@"pulse_icon.png"] forState:UIControlStateNormal];
    [startPulseCheckerButton addTarget:self action:@selector(startPulseChecker:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startPulseCheckerButton];
    
    progressBackground = [[UIButton alloc] initWithFrame:CGRectMake(60, 300, 202, 50)];
    [progressBackground setBackgroundColor:[UIColor blackColor]];
    [progressBackground setHidden:YES];
    [self.view addSubview:progressBackground];
    
    progressButton = [[UIButton alloc] initWithFrame:CGRectMake(62, 302, 0, 46)];
    [progressButton setBackgroundColor:[UIColor redColor]];
    [progressButton setHidden:YES];
    [self.view addSubview:progressButton];
    
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
    [sender removeFromSuperview];
    [timeRemainingLabel setHidden:NO];
    [progressBackground setHidden:NO];
    [progressButton setHidden:NO];
    [self.view setNeedsDisplay];
    
    if (countdownTimer)
        return;
    
    remainingTicks = 20;
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
    [[User sharedUser] setBrightnessValues: [captureManager brightnessArray]];
    ResultsViewController *resultsView = [[ResultsViewController alloc] initWithNibName:@"ResultsViewController" bundle:nil];
    [self presentViewController:resultsView animated:YES completion:^(void)
     {
         
     }];
//    GraphViewController *graphVC = [[GraphViewController alloc] initWithNibName:@"GraphViewController" bundle:nil];
//    [graphVC setBrightnessValues:[captureManager brightnessArray]];
//    [self presentViewController:graphVC animated:YES completion:^(void)
//     {
//         
//     }];
}

- (void) updateTimeRemainingLabel
{
    [timeRemainingLabel setText:[NSString stringWithFormat:@"Time remaining: %i seconds", remainingTicks]];
    [progressButton setFrame:CGRectMake(62, 302, 10*(20-remainingTicks), 46)];
}

- (NSNumber *)meanOf:(NSArray *)array
{
    double runningTotal = 0.0;
    
    for(NSNumber *number in array)
    {
        runningTotal += [number doubleValue];
    }
    
    return [NSNumber numberWithDouble:(runningTotal / [array count])];
}

- (NSNumber *)standardDeviationOf:(NSArray *)array
{
    if(![array count]) return nil;
    
    double mean = [[self meanOf:array] doubleValue];
    double sumOfSquaredDifferences = 0.0;
    
    for(NSNumber *number in array)
    {
        double valueOfNumber = [number doubleValue];
        double difference = valueOfNumber - mean;
        sumOfSquaredDifferences += difference * difference;
    }
    
    return [NSNumber numberWithDouble:sqrt(sumOfSquaredDifferences / [array count])];
}
@end
