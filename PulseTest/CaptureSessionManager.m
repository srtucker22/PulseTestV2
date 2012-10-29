/*
    File: CaptureSessionManager.m
Abstract: Configuration and control of video capture.
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

#import "CaptureSessionManager.h"


#define BYTES_PER_PIXEL 4
#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 460


static const uint8_t orangeColor[] = {255, 127, 0};


@implementation CaptureSessionManager

@synthesize captureSession;
@synthesize previewLayer;

@synthesize brightnessArray;


#pragma mark Pixelbuffer Processing

- (void)processPixelBuffer: (CVImageBufferRef)pixelBuffer {
	
	CVPixelBufferLockBaseAddress( pixelBuffer, 0 );
	
	int bufferHeight = CVPixelBufferGetHeight(pixelBuffer);
	int bufferWidth = CVPixelBufferGetWidth(pixelBuffer);
	int bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer);
	unsigned char *rowBase = (unsigned char *)CVPixelBufferGetBaseAddress(pixelBuffer);

    float totalBrightness = 0;
	for( int row = 0; row < bufferHeight; row += 8 ) {
		for( int column = 0; column < bufferWidth; column += 8 ) {
			
			unsigned char *pixel = rowBase + (row * bytesPerRow) + (column * BYTES_PER_PIXEL);
			
            float Y = 0.2989 * pixel[0] + 0.5866 * pixel[1] + 0.1145 * pixel[2];
            totalBrightness+=Y;
            
            //referenceMap[bufferHeight][bufferWidth] = Y;
        }
	}
    [brightnessArray addObject:[NSNumber numberWithFloat:totalBrightness]];

	CVPixelBufferUnlockBaseAddress( pixelBuffer, 0 );
}


#pragma mark SampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {

	CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer( sampleBuffer );
	
    // process the pixels on the screen if it's time to record
    if(isRecording)
    {
        [self processPixelBuffer:pixelBuffer];
    }
}


#pragma mark Capture Session Configuration

- (void) addVideoPreviewLayer {
	self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
	self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
}


- (void) addVideoInput {
	
	videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];	
	if ( videoDevice ) {

        // Start session configuration
        [self setTorchMode:AVCaptureTorchModeOn];
        
		NSError *error;
		AVCaptureDeviceInput *videoIn = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
		if ( !error ) {
			if ([self.captureSession canAddInput:videoIn])
				[self.captureSession addInput:videoIn];
			else
				NSLog(@"Couldn't add video input");		
		}
		else
			NSLog(@"Couldn't create video input");
	}
	else
		NSLog(@"Couldn't create video capture device");
}


- (void) addVideoDataOutput {
	
	AVCaptureVideoDataOutput *videoOut = [[AVCaptureVideoDataOutput alloc] init];
	[videoOut setAlwaysDiscardsLateVideoFrames:YES];
	[videoOut setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]]; // BGRA is necessary for manual preview
    
	dispatch_queue_t my_queue = dispatch_queue_create("com.example.subsystem.taskXYZ", NULL);
	[videoOut setSampleBufferDelegate:self queue:my_queue];
//	[videoOut setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
	if ([self.captureSession canAddOutput:videoOut])
		[self.captureSession addOutput:videoOut];
	else
		NSLog(@"Couldn't add video output");
}


- (id) init {
	
	if (self = [super init]) {

		self.captureSession = [[AVCaptureSession alloc] init];
		//self.captureSession.sessionPreset = AVCaptureSessionPreset640x480;
        
        brightnessArray=[[NSMutableArray alloc] init];
        isRecording=NO;
	}
	
	return self;
}

-(void)startRecordingPulse{
    isRecording = YES;
}

-(void)stopRecordingPulse{
    isRecording = NO;
}

-(void)setTorchMode:(AVCaptureTorchMode)torchMode{
    // Start session configuration
    [captureSession beginConfiguration];
    [videoDevice lockForConfiguration:nil];
    
    // Set torch to on
    [videoDevice setTorchMode:torchMode];
    
    [videoDevice unlockForConfiguration];
    [captureSession commitConfiguration];
}
@end
