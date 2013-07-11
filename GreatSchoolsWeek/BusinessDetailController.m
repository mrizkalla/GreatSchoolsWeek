//
//  BusinessDetailController.m
//  GreatSchoolsWeek
//
//  Created by Michael Rizkalla on 9/22/12.
//  Copyright (c) 2012 Michael Rizkalla. All rights reserved.
//

#import "BusinessDetailController.h"
#import <MapKit/MapKit.h>
#import "BusinessLocation.h"
#import <QuartzCore/QuartzCore.h>

#define METERS_PER_MILE 1609.344

@interface BusinessDetailController ()

@end

@implementation BusinessDetailController
@synthesize theBusiness;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    scrollView.contentSize = CGSizeMake(320, 550);
    
    discountLabel.text = [theBusiness objectForKey:@"Percent String"];
    
    if ([[theBusiness objectForKey:@"All Sales"] isEqualToString:@"Yes"]) {
        allSalesLabel.hidden = NO;
    }
    
    addressLabel.text = [theBusiness objectForKey:@"Address"];
    [phoneNumberButton setTitle:[NSString stringWithFormat:@"Call: %@", [theBusiness objectForKey:@"Phone Number"]] forState:(UIControlStateNormal)] ;
    
    notesCell.text = [theBusiness objectForKey:@"Notes"];
    
    websiteTextView.text = [theBusiness objectForKey:@"Website"];
    
    // Handle the Days gadget 
    mondayLabel.layer.borderColor = [UIColor blackColor].CGColor;
    mondayLabel.layer.borderWidth = 1;
    if (![[theBusiness objectForKey:@"Monday"] integerValue]) {
        [mondayLabel setEnabled:NO];
    }
    
    tuesdayLabel.layer.borderColor = [UIColor blackColor].CGColor;
    tuesdayLabel.layer.borderWidth = 1;
    if (![[theBusiness objectForKey:@"Tuesday"] integerValue]) {
        [tuesdayLabel setEnabled:NO];
    }
    
    wednesdayLabel.layer.borderColor = [UIColor blackColor].CGColor;
    wednesdayLabel.layer.borderWidth = 1;
    if (![[theBusiness objectForKey:@"Wednesday"] integerValue]) {
        [wednesdayLabel setEnabled:NO];
    }
    
    thursdayLabel.layer.borderColor = [UIColor blackColor].CGColor;
    thursdayLabel.layer.borderWidth = 1;
    if (![[theBusiness objectForKey:@"Thursday"] integerValue]) {
        [thursdayLabel setEnabled:NO];
    }
    
    fridayLabel.layer.borderColor = [UIColor blackColor].CGColor;
    fridayLabel.layer.borderWidth = 1;
    if (![[theBusiness objectForKey:@"Friday"] integerValue]) {
        [fridayLabel setEnabled:NO];
    }
    
    
    // Map stuff
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString:addressLabel.text
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     CLPlacemark* aPlacemark =  [placemarks objectAtIndex:0];
                    
                         // Process the placemark.
                         businessPlacemark = aPlacemark;
                         //[mapView setCenterCoordinate:aPlacemark.location.coordinate animated:NO];
                         
                         MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(aPlacemark.location.coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
                         MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
                         [mapView setRegion:adjustedRegion animated:NO];
                         
                         CLLocationCoordinate2D coordinate = aPlacemark.location.coordinate;
                         BusinessLocation *annotation = [[BusinessLocation alloc] initWithName:[theBusiness objectForKey:@"Name"] address:addressLabel.text coordinate:coordinate theBusiness:nil] ;
                         [mapView addAnnotation:annotation];
                    
                 }];
        
}

- (IBAction)callButtonPressed:(UIButton *)sender {

    NSString *phoneNumber = [theBusiness objectForKey:@"Phone Number"];
    NSString *escapedPhoneNumber = [phoneNumber stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSString *urlString = [@"telprompt://" stringByAppendingString:escapedPhoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];

}

- (IBAction)directionsButtonPressed:(id)sender {
    
    Class itemClass = [MKMapItem class];
    if (itemClass && [itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
        MKPlacemark* place = [[MKPlacemark alloc] initWithCoordinate: businessPlacemark.location.coordinate addressDictionary: nil];
        MKMapItem* destination = [[MKMapItem alloc] initWithPlacemark: place];
        destination.name = [theBusiness objectForKey:@"Name"];
        NSArray* items = [[NSArray alloc] initWithObjects: destination, nil];
        NSDictionary* options = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 MKLaunchOptionsDirectionsModeDriving,
                                 MKLaunchOptionsDirectionsModeKey, nil];
        [MKMapItem openMapsWithItems: items launchOptions: options];
    } else {
        // use pre iOS 6 technique       
        NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?&daddr=%f,%f",
                         businessPlacemark.location.coordinate.latitude, businessPlacemark.location.coordinate.longitude];

        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    }
}


- (void)viewDidUnload {
    mapView = nil;
    mondayLabel = nil;
    tuesdayLabel = nil;
    mondayLabel = nil;
    wednesdayLabel = nil;
    thursdayLabel = nil;
    fridayLabel = nil;
    websiteTextView = nil;
    [super viewDidUnload];
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"BusinessLocation";
    if ([annotation isKindOfClass:[BusinessLocation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [map dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }
    
    return nil;    
}
@end
