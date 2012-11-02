//
//  IntroViewController.m
//  PulseTest
//
//  Created by Simon Tucker on 10/27/12.
//  Copyright (c) 2012 Simon Tucker. All rights reserved.
//

#import "IntroViewController.h"
#import "ProcessViewController.h"

#import "TableViewController.h"

@interface IntroViewController ()

@end

@implementation IntroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"PulseTest";
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
    processVC = [[ProcessViewController alloc] initWithNibName:@"ProcessViewController" bundle:nil];
    [self.navigationController pushViewController:processVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"History" style:UIBarButtonItemStyleBordered target:self action:@selector(showTableView:)];
    [self.navigationController setToolbarHidden:YES];
}

-(IBAction)showTableView:(id)sender{
    [self.navigationController pushViewController:[[TableViewController alloc] initWithStyle:UITableViewStylePlain] animated:YES];
}

@end
