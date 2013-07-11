//
//  BusinessDetailController.h
//  GreatSchoolsWeek
//
//  Created by Michael Rizkalla on 9/22/12.
//  Copyright (c) 2012 Michael Rizkalla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface BusinessDetailController : UIViewController <MKMapViewDelegate> {
//    IBOutlet UILabel* businessName;
    IBOutlet UILabel* discountLabel;
    IBOutlet UILabel* allSalesLabel;
    IBOutlet UILabel* addressLabel;
    IBOutlet UIButton* phoneNumberButton;
    IBOutlet UITextView* notesCell;
    IBOutlet UIScrollView *scrollView;
    __weak IBOutlet MKMapView *mapView;

    __weak IBOutlet UILabel *mondayLabel;
    __weak IBOutlet UILabel *tuesdayLabel;
    __weak IBOutlet UILabel *wednesdayLabel;
    __weak IBOutlet UILabel *thursdayLabel;
    __weak IBOutlet UILabel *fridayLabel;
    __weak IBOutlet UITextView *websiteTextView;
    
    CLPlacemark *businessPlacemark;
}

@property (strong, nonatomic) NSDictionary* theBusiness;


@end
