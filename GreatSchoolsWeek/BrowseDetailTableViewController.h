//
//  BrowseDetailTableViewController.h
//  GreatSchoolsWeek
//
//  Created by Michael Rizkalla on 9/20/12.
//  Copyright (c) 2012 Michael Rizkalla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowseDetailTableViewController : UITableViewController {
    NSArray *businessArray;
    NSMutableArray *filteredBusinessArray;
    NSDictionary* sortedDictionary;
    NSArray* catetories;
}

@property (nonatomic) NSInteger selectedSegment;
@property (strong, nonatomic) NSString* selectedValue;


@end
