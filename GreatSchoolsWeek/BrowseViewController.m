//
//  BrowseViewController.m
//  GreatSchoolsWeek
//
//  Created by Michael Rizkalla on 9/13/12.
//  Copyright (c) 2012 Michael Rizkalla. All rights reserved.
//

#import "BrowseViewController.h"
#import "BrowseDetailTableViewController.h"

@interface BrowseViewController ()

@end

@implementation BrowseViewController
@synthesize segmentedControl;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Initialze the data sources for each view of the table
    browseItemsArray = [[NSMutableArray alloc] init];
    
    // Build the various browsable arrays.  Hard code for now but could get this from a json URL as well
    NSArray* catetories = [NSArray arrayWithObjects:@"Restaurants", @"Services", @"Retailers", @"Drinks and Desserts", @"Grocers", @"Family Entertainment", @"Food Trucks", nil];
    NSArray* days = [NSArray arrayWithObjects:@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", nil];
    NSArray* percentValues = [NSArray arrayWithObjects:@"All Sales", @"10% or under", @"15%", @"20%", @"25%", @"30%", @"40% or over", @"Fixed Amount", nil];
    
    [browseItemsArray addObject:catetories];
    [browseItemsArray addObject:days];
    [browseItemsArray addObject:percentValues];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger value = [browseItemsArray[segmentedControl.selectedSegmentIndex] count];
    return value; //[browseItemsArray[segmentedControl.selectedSegmentIndex] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSArray* listOfItems = browseItemsArray[segmentedControl.selectedSegmentIndex];
    cell.textLabel.text = listOfItems[indexPath.row];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

    return cell;
}

-(IBAction) segmentedControlChanged {
    [self.tableView reloadData];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform segue to browse detail
    [self performSegueWithIdentifier:@"browseDetail" sender:tableView];
}


#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"browseDetail"]) {
        BrowseDetailTableViewController *browseDetailViewController = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *destinationTitle = [browseItemsArray[segmentedControl.selectedSegmentIndex] objectAtIndex:[indexPath row]];
        [browseDetailViewController setTitle:destinationTitle];
        browseDetailViewController.selectedSegment = segmentedControl.selectedSegmentIndex;
        if (segmentedControl.selectedSegmentIndex < 2) {
            browseDetailViewController.selectedValue = destinationTitle;
        } else {
            browseDetailViewController.selectedValue = [NSString stringWithFormat:@"%d", [indexPath row]];
        }
    }
}
 



@end
