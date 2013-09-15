//
//  MapViewController.h
//  GreatSchoolsWeek
//
//  Created by Michael Rizkalla on 9/28/12.
//  Copyright (c) 2012 Michael Rizkalla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface MapViewController : UIViewController <MKMapViewDelegate, UISearchBarDelegate> 


@property (strong,nonatomic) NSArray *businessArray;
@property (strong,nonatomic) NSMutableArray *filteredBusinessArray;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end