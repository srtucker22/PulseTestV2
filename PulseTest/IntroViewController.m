//
//  IntroViewController.m
//  PulseTest
//
//  Created by Simon Tucker on 10/27/12.
//  Copyright (c) 2012 Simon Tucker. All rights reserved.
//

#import "IntroViewController.h"
#import "ProcessViewController.h"
@interface IntroViewController ()

@end

@implementation IntroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)openVC:(id)sender
{
    ProcessViewController *viewController = [[ProcessViewController alloc] initWithNibName:@"ProcessViewController" bundle:nil];
    [self presentViewController:viewController animated:YES completion:^(void)
    {
        
    }];
}
@end
