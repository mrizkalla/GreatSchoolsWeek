//
//  SearchTableViewController.m
//  GreatSchoolsWeek
//
//  Created by Michael Rizkalla on 9/12/12.
//  Copyright (c) 2012 Michael Rizkalla. All rights reserved.
//



#import "SearchTableViewController.h"
#import "BusinessData.h"
#import "BusinessDetailController.h"

@interface SearchTableViewController ()

@end

@implementation SearchTableViewController
@synthesize businessArray;
@synthesize filteredBusinessArray;
@synthesize businessSearchBar;


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

    // Get the business array
    BusinessData *gswBusinesses = [BusinessData sharedInstance];
    self.businessArray = gswBusinesses.businessArray;
    
    // Initialize the filteredCandyArray with a capacity equal to the candyArray's capacity
    self.filteredBusinessArray = [NSMutableArray arrayWithCapacity:[gswBusinesses.businessArray count]];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [filteredBusinessArray count];
    } else {
        return [businessArray count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Business Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Create a new business dictionary
    NSDictionary* business = nil; //[businessArray objectAtIndex:indexPath.row];
    // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        business = [filteredBusinessArray objectAtIndex:indexPath.row];
    } else {
        business = [businessArray objectAtIndex:indexPath.row];
    }

    // Configure the cell
    cell.textLabel.text = [business objectForKey:@"Name"];
    NSArray *split = [[business objectForKey:@"Address"] componentsSeparatedByString:@","];
    if ( [split count] > 1) {
        cell.detailTextLabel.text = [split objectAtIndex:([split count]-2)];
    } else {
        cell.detailTextLabel.text = @"";
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredBusinessArray removeAllObjects];
    
    // Filter the array using NSPredicate
    // Removed address search: OR SELF.Address contains [c] %@
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.Name contains[c] %@ OR SELF.Category contains [c] %@",searchText, searchText];
    
    filteredBusinessArray = [NSMutableArray arrayWithArray:[businessArray filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform segue to browse detail
    [self performSegueWithIdentifier:@"BusinessDetailFromSearch" sender:tableView];
}


#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"BusinessDetailFromSearch"]) {
        
        // Get the view controller for the business detail
        BusinessDetailController *detailViewController = [segue destinationViewController];
        
        NSIndexPath *indexPath = nil; 

        NSString *destinationTitle = nil;
        if (sender == self.searchDisplayController.searchResultsTableView) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            destinationTitle = [[filteredBusinessArray objectAtIndex:[indexPath row]] objectForKey:@"Name"];
            detailViewController.theBusiness = [filteredBusinessArray objectAtIndex:[indexPath row]];
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            destinationTitle = [[businessArray objectAtIndex:[indexPath row]] objectForKey:@"Name"];
            detailViewController.theBusiness = [businessArray objectAtIndex:[indexPath row]];
        }
        
        [detailViewController setTitle:destinationTitle];

        // Set some data on the view controller
    }
}
@end
