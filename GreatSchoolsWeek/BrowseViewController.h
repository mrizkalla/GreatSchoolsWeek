//
//  BrowseViewController.h
//  GreatSchoolsWeek
//
//  Created by Michael Rizkalla on 9/13/12.
//  Copyright (c) 2012 Michael Rizkalla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowseViewController : UITableViewController {
    NSArray *businessArray;
    NSMutableArray *browseItemsArray;

}

@property IBOutlet UISegmentedControl *segmentedControl;

@end
