//
//  BusinessLocation.m
//  GreatSchoolsWeek
//
//  Created by Michael Rizkalla on 9/26/12.
//  Copyright (c) 2012 Michael Rizkalla. All rights reserved.
//

#import "BusinessLocation.h"

@implementation BusinessLocation
@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;
@synthesize theBusiness = _theBusiness;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate theBusiness:(NSDictionary*)business {
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
        _theBusiness = business;
    }
    return self;
}

- (NSString *)title {
    if ([_name isKindOfClass:[NSNull class]])
        return @"Unknown business";
    else
        return _name;
}

- (NSString *)subtitle {
    return _address;
}

- (CLLocationCoordinate2D)coordinate;
{

    return _coordinate;
}
@end
