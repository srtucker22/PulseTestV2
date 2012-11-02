//
//  ResultsViewController.m
//  StressBuster
//
//  Created by Simon Tucker on 10/27/12.
//  Copyright (c) 2012 Simon Tucker. All rights reserved.
//

#import "ResultsViewController.h"

#import "User.h"

#import "PulseCalculator.h"

#import "IntroViewController.h"
#import "DetailViewController.h"
#import "TableViewController.h"

@interface ResultsViewController ()

@end

@implementation ResultsViewController
@synthesize score;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        score = [[User sharedUser] currentPulse];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set title
    self.title = @"Results";
    [self.navigationController setNavigationBarHidden:NO];
    
    // Hide the back button and replace with home and table view button
    [self.navigationItem setHidesBackButton:YES animated:YES];
    UIBarButtonItem *tableViewButton = [[UIBarButtonItem alloc] initWithTitle:@"History" style:UIBarButtonItemStylePlain target:self action:@selector(showTableView:)];
    self.navigationItem.rightBarButtonItem = tableViewButton;
    
    UIBarButtonItem *homeViewButton = [[UIBarButtonItem alloc] initWithTitle:@"Test Again" style:UIBarButtonItemStylePlain target:self action:@selector(showHomeView:)];
    self.navigationItem.leftBarButtonItem = homeViewButton;
    
    // Do any additional setup after loading the view from its nib.
    [scoreLabel setText:[NSString stringWithFormat: @"%i", score]];
    [scoreLabel setFont:[UIFont fontWithName:@"helvetica" size:60]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showMap:(id)sender
{
    DetailViewController *mapVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    [self.navigationController pushViewController:mapVC animated:YES];
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

-(IBAction)showHomeView:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)showTableView:(id)sender{
    [self.navigationController pushViewController:[[TableViewController alloc] initWithStyle:UITableViewStylePlain] animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setToolbarHidden:YES];
}
@end
