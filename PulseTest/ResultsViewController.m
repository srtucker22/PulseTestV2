//
//  ResultsViewController.m
//  StressBuster
//
//  Created by Simon Tucker on 10/27/12.
//  Copyright (c) 2012 Simon Tucker. All rights reserved.
//

#import "ResultsViewController.h"
#import "User.h"
#import "IntroViewController.h"
#import "GraphViewController.h"
#import "DetailViewController.h"
#import "IntroViewController.h"
@interface ResultsViewController ()

@end

@implementation ResultsViewController
@synthesize score;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        score = [[User sharedUser] getPulseScore];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [scoreLabel setText:[NSString stringWithFormat: @"%i", score]];
    [scoreLabel setFont:[UIFont fontWithName:@"helvetica" size:60]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(id)sender
{
    [self removeFromParentViewController];
}

-(IBAction)viewGraph:(id)sender
{
    GraphViewController *graphVC = [[GraphViewController alloc] initWithNibName:@"GraphViewController" bundle:nil];
    [graphVC setBrightnessValues:[[User sharedUser] brightnessValues]];
    [self presentViewController:graphVC animated:YES completion:^(void)
     {
         NSTimer *countdownTimer = [NSTimer scheduledTimerWithTimeInterval: 5.0 target: self selector: @selector(handleTimerTick) userInfo: nil repeats: NO];
     }];
}

-(IBAction)showMap:(id)sender
{
    DetailViewController *intro = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    [self presentViewController:intro animated:YES completion:^(void)
     {
         NSTimer *countdownTimer = [NSTimer scheduledTimerWithTimeInterval: 5.0 target: self selector: @selector(handleTimerTick) userInfo: nil repeats: NO];
     }];
}

-(void)handleTimerTick
{
    NSLog(@"here");
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)facebookLogin:(id)sender
{
    if([PFUser currentUser])
    {
        if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
            // The permissions requested from the user
            NSArray *permissionsArray = [NSArray arrayWithObjects: @"publish_stream",@"user_about_me",
                                         @"user_relationships",@"user_birthday",@"user_location",
                                         @"offline_access", nil];
            [PFFacebookUtils linkUser:[PFUser currentUser] permissions:permissionsArray block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [self postToFacebook];
                }else{
                    [[[UIAlertView alloc] initWithTitle:@"Can't Login to Facebook"
                                                message:nil
                                               delegate:nil
                                      cancelButtonTitle:@"ok"
                                      otherButtonTitles:nil] show];
                }
            }];
        }else{
            [self postToFacebook];
        }
    }else{
        
    }
}

-(void)postToFacebook{
    NSLog(@"sending facebook post");
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"I just measured my pulse with PulseTest and got %i", score ] forKey:@"message"];
    [PF_FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"me/feed"] parameters:params HTTPMethod:@"POST" completionHandler:^(PF_FBRequestConnection *connection, id result, NSError *error){
        NSLog(@"%@", result);
        NSLog(@"%@", error);
        if(error)
        {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Can't Post to Facebook"
                                      message:@"Check your connection and try again."
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Posted!"
                                      message:nil
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
    }];
}
@end
