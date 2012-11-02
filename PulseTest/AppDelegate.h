//
//  AppDelegate.h
//  PulseTest
//
//  Created by Simon Tucker on 10/27/12.
//  Copyright (c) 2012 Simon Tucker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProcessViewController;
@class IntroViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) IntroViewController *viewController;

@end
