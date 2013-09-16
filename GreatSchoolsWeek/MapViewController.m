//
//  MapViewController.m
//  GreatSchoolsWeek
//
//  Created by Michael Rizkalla on 9/28/12.
//  Copyright (c) 2012 Michael Rizkalla. All rights reserved.
//

#import "MapViewController.h"
#import "BusinessData.h"
#import <MapKit/MapKit.h>
#import "BusinessLocation.h"
#import "BusinessDetailController.h"

#define METERS_PER_MILE 1609.344

@interface MapViewController () 

@end

@implementation MapViewController
@synthesize businessArray, filteredBusinessArray;
@synthesize mapView;

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation {
    
    // handle our two custom annotations
    //
    if ([annotation isKindOfClass:[BusinessLocation class]]) // for Golden Gate Bridge
    {
        // try to dequeue an existing pin view first
        static NSString* BusinessAnnotationIdentifier = @"businessAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:BusinessAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:BusinessAnnotationIdentifier];
            customPinView.pinColor = MKPinAnnotationColorPurple;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            // add a detail disclosure button to the callout which will open a new view controller page
            //
            // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
            //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
            //
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self
                            action:@selector(showDetails:)
                  forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;
            
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    
    return nil;
}

- (void) dropFilteredPinsOnMap:(NSArray*)businessPinsArray
{
    // Drop a pin for all the businesses
    for (id<MKAnnotation> annotation in mapView.annotations) {
        [mapView removeAnnotation:annotation];
    }
    
    for (NSDictionary *business in businessPinsArray) {
        // Map stuff
        
        //[mapView setCenterCoordinate:aPlacemark.location.coordinate animated:NO];
        /*
         MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(aPlacemark.location.coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
         MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
         [mapView setRegion:adjustedRegion animated:NO];
         */
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [[business objectForKey:@"Latitude"] doubleValue];
        coordinate.longitude = [[business objectForKey:@"Longitude"] doubleValue];
        BusinessLocation *annotation = [[BusinessLocation alloc] initWithName:[business objectForKey:@"Name"] address:[business objectForKey:@"Address"] coordinate:coordinate theBusiness:business];
        [self.mapView addAnnotation:annotation];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Hide the stupid nav bar
    [self.navigationController setNavigationBarHidden:YES];
    
    // Get the business array
    BusinessData *gswBusinesses = [BusinessData sharedInstance];
    businessArray = gswBusinesses.businessArray;
    
    // Zoom and Center the map on Cupertino
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 37.325;
    zoomLocation.longitude= -122.03;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 10*METERS_PER_MILE, 10*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustedRegion animated:NO];
    
    [self dropFilteredPinsOnMap:businessArray];

}



- (void)showDetails:(id)sender
{
    // the detail view     
    [self performSegueWithIdentifier:@"MapToBusinessDetail" sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"MapToBusinessDetail"]) {
        
        // Get the view controller for the business detail
        BusinessDetailController *detailViewController = [segue destinationViewController];
                
        NSString *destinationTitle = nil;
        BusinessLocation *theSelectedBusiness = [mapView.selectedAnnotations objectAtIndex:0];
       
        destinationTitle = [theSelectedBusiness.theBusiness objectForKey:@"Name"];        
        [detailViewController setTitle:destinationTitle];
        
        // Set some data on the view controller
        detailViewController.theBusiness = theSelectedBusiness.theBusiness;
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

-(void) viewWillDisappear:(BOOL)animated {
    // Put the nav bar back
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [self setMapView:nil];
    [super viewDidUnload];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array    
    [self.filteredBusinessArray removeAllObjects];
    
    // Filter the array using NSPredicate
    // Removed address search: OR SELF.Address contains [c] %@
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.Name contains[c] %@ OR SELF.Category contains [c] %@",searchBar.text, searchBar.text];
    
    filteredBusinessArray = [NSMutableArray arrayWithArray:[businessArray filteredArrayUsingPredicate:predicate]];
    
    [self dropFilteredPinsOnMap:[NSArray arrayWithArray:filteredBusinessArray]];

}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    [self dropFilteredPinsOnMap:businessArray];
}

@end
