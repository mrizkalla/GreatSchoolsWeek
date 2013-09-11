//
//  BusinessLocation.h
//  GreatSchoolsWeek
//
//  Created by Michael Rizkalla on 9/26/12.
//  Copyright (c) 2012 Michael Rizkalla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BusinessLocation : NSObject <MKAnnotation> {
    NSString *_name;
    NSString *_address;
    CLLocationCoordinate2D _coordinate;
    NSDictionary* _theBusiness;
}

@property (copy) NSString *name;
@property (copy) NSString *address;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSDictionary *theBusiness;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate theBusiness:(NSDictionary*)business;

@end