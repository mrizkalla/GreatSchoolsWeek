//
//  BrowseDetailTableViewController.m
//  GreatSchoolsWeek
//
//  Created by Michael Rizkalla on 9/20/12.
//  Copyright (c) 2012 Michael Rizkalla. All rights reserved.
//

#import "BrowseDetailTableViewController.h"
#import "BusinessData.h"
#import "BusinessDetailController.h"

@interface BrowseDetailTableViewController ()

@end

@implementation BrowseDetailTableViewController
@synthesize selectedSegment;
@synthesize selectedValue;

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
    businessArray = gswBusinesses.businessArray;
    
    /* Now we have all the businesses, we need to filter it down to the category that we want.  In order to do this, we need to pass in the selected row as well as the seqment from the previous screen.  Assume those get set in this view controllers property
     pseudo code:
        if selectedSegment == 0 // category segment 
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category contains[c] %@ ", filterString];
        else if selectedSegment == 1  // day segment     
            if selectedRow == Monday the build predicate where any business has M: yes
               selectedRow == Tuesday then build predicate where any business has T: yes
               ets
        else if selectedSegment == 2   // percent segment
            build predicate where percent category = selected index row
     
     filteredBusinessArray = [NSMutableArray arrayWithArray:[businessArray filteredArrayUsingPredicate:predicate]];
     */
    NSPredicate *predicate = nil;
    if (self.selectedSegment == 0) {
        // Category filter
        predicate = [NSPredicate predicateWithFormat:@"SELF.Category contains[c] %@", self.selectedValue];
    } else if (self.selectedSegment == 1 ) {
        // Day filter
        predicate = [NSPredicate predicateWithFormat:@"SELF.%@ == '1'", self.selectedValue];  
    } else {
        predicate = [NSPredicate predicateWithFormat:@"SELF.PercentInt contains[c] %@", self.selectedValue];
    }
    
    filteredBusinessArray = [NSMutableArray arrayWithArray:[businessArray filteredArrayUsingPredicate:predicate]];
    // Now create a dictionary for sectioned headers
    if (self.selectedSegment > 0)
    {
        catetories = [NSArray arrayWithObjects:@"Restaurants", @"Services", @"Retailers", @"Drinks and Desserts", @"Grocers", @"Family Entertainment", @"Food Trucks", nil];
        NSMutableArray* sortedBusinessArray = [[NSMutableArray alloc]initWithCapacity:[catetories count]];
        for (NSString *iterator in catetories) {
            predicate = [NSPredicate predicateWithFormat:@"SELF.Category contains[c] %@", iterator];
            NSArray *tmpArray = [NSArray arrayWithArray:[filteredBusinessArray filteredArrayUsingPredicate:predicate]];
            [sortedBusinessArray addObject:tmpArray];
        }
        sortedDictionary = [NSDictionary dictionaryWithObjects:sortedBusinessArray forKeys:catetories];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.selectedSegment == 0) {
        return 1;
    } else {
        return [catetories count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.selectedSegment == 0) {
        return [filteredBusinessArray count];
    } else {
        return [[sortedDictionary objectForKey:[catetories objectAtIndex:section]] count];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor colorWithRed:195.0f/255.0f
                                     green:211.0f/255.0f
                                      blue:88.0f/255.0f
                                     alpha:1.0f];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(self.selectedSegment == 0)
        return @"";
    else {
        if (![[sortedDictionary objectForKey:[catetories objectAtIndex:section]] count]) {
            return @"";
        } else
            return [catetories objectAtIndex:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Filtered Business Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    
    // Configure the cell...
    // Create a new business dictionary
    NSDictionary* business;
    if (self.selectedSegment == 0) {
         business = [filteredBusinessArray objectAtIndex:indexPath.row];
    } else {
        NSArray *array = [sortedDictionary objectForKey:[catetories objectAtIndex:[indexPath section]]];
        business = [array objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = [business objectForKey:@"Name"];
    NSArray *split = [[business objectForKey:@"Address"] componentsSeparatedByString:@","];
    if ( [split count] > 1) {
        cell.detailTextLabel.text = [split objectAtIndex:([split count] - 2)];
    } else {
        cell.detailTextLabel.text = @"";
    }

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform segue to browse detail
    [self performSegueWithIdentifier:@"BusinessDetailFromBrowse" sender:tableView];
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"BusinessDetailFromBrowse"]) {
        
        // Get the view controller for the business detail
        BusinessDetailController *detailViewController = [segue destinationViewController];
        
        NSIndexPath *indexPath = nil;
        
        NSString *destinationTitle = nil;
        indexPath = [self.tableView indexPathForSelectedRow];
        
        if (self.selectedSegment == 0) {
            destinationTitle = [[filteredBusinessArray objectAtIndex:[indexPath row]] objectForKey:@"Name"];
            detailViewController.theBusiness = [filteredBusinessArray objectAtIndex:[indexPath row]];
            [detailViewController setTitle:destinationTitle];
        } else {
            NSArray *array = [sortedDictionary objectForKey:[catetories objectAtIndex:[indexPath section]]];
            NSDictionary *business = [array objectAtIndex:[indexPath row]];
            destinationTitle = [business objectForKey:@"Name"];
            detailViewController.theBusiness = business;
            [detailViewController setTitle:destinationTitle];
        }
        
        // Set some data on the view controller
    }
}

@end
