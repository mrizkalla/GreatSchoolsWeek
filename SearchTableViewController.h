//
//  SearchTableViewController.h
//  GreatSchoolsWeek
//
//  Created by Michael Rizkalla on 9/12/12.
//  Copyright (c) 2012 Michael Rizkalla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong,nonatomic) NSArray *businessArray;
@property (strong,nonatomic) NSMutableArray *filteredBusinessArray;
@property IBOutlet UISearchBar *businessSearchBar;

@end
