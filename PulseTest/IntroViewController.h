//
//  IntroViewController.h
//  PulseTest
//
//  Created by Simon Tucker on 10/27/12.
//  Copyright (c) 2012 Simon Tucker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProcessViewController.h"
@interface IntroViewController : UIViewController
{
    IBOutlet UIImageView *instructionsImage;
    IBOutlet UILabel *instructionsLabel;
    IBOutlet UIButton *instructionsButton;
    
    // For some reason this needed more retaining
    ProcessViewController *processVC;
}
@end
