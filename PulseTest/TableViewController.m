//
//  TableViewController.m
//  PulseTest
//
//  Created by Simon Tucker on 10/31/12.
//  Copyright (c) 2012 Simon Tucker. All rights reserved.
//

#import "TableViewController.h"
#import <Parse/Parse.h>
#import "User.h"

#import "DetailViewController.h"
#import "SearchViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"Pulse History";
        
        [[User sharedUser] queryPulses:^(NSArray *pulses, NSError *error){
            if(pulses)
            {
                pulseList = [[NSMutableArray alloc] initWithArray:pulses];
                
                // Show the map button only after stuff has loaded
                UIBarButtonItem *mapViewButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:self action:@selector(showMapView:)];
                [self setToolbarItems:[[NSArray alloc] initWithObjects:mapViewButton, nil] animated:YES] ;
                
                [self.tableView reloadData];
            }else
            {
                NSLog(@"%@",error);
            }
        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    if(pulseList)
        return 1;
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if(pulseList)
        return pulseList.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *IdentifierA = @"mainCellIndentifier";
    
    // This could be some custom table cell class if appropriate
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentifierA];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IdentifierA];
    }
    
    // A date formatter for the creation date.
    static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	}
    
    // Configure the cell...
    PFObject *pulse = [pulseList objectAtIndex:indexPath.row];

    cell.textLabel.text = [NSString stringWithFormat:@"%@",[pulse objectForKey:@"pulse"]];
    cell.detailTextLabel.text = [dateFormatter stringFromDate:[pulse createdAt]];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        PFObject *deletedObject = [pulseList objectAtIndex:indexPath.row];
        [deletedObject deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            if(succeeded)
            {
                [pulseList removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }else{
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Connection Issue"
                                          message:@"Please try again later"
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
            }
        }];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    DetailViewController *detailVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    [detailVC setClickedObject:[pulseList objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

-(IBAction)showMapView:(id)sender
{
    SearchViewController *searchVC = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    
    //Set the initial location to the most recent score
    NSLog(@"%@",[[pulseList objectAtIndex:0] objectForKey:@"location"]);
    PFGeoPoint *geo = [[pulseList objectAtIndex:0] objectForKey:@"location"];
    [searchVC setInitialLocation:[[pulseList objectAtIndex:0] objectForKey:@"location"]];
    [self.navigationController pushViewController:searchVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.toolbarHidden = NO;
}
@end
