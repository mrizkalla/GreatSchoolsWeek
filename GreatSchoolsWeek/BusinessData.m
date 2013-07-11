//
//  BusinessData.m
//  GreatSchoolsWeek
//
//  Created by Michael Rizkalla on 9/18/12.
//  Copyright (c) 2012 Michael Rizkalla. All rights reserved.
//

#import "BusinessData.h"

@implementation BusinessData

@synthesize businessArray;

static BusinessData *_sharedInstance;

- (id) init
{
	if (self = [super init])
	{
		// custom initialization
		self.businessArray = [[NSArray alloc] initWithObjects:@"a", @"b", @"c", nil];
    }
	return self;
}

+ (BusinessData *) sharedInstance
{
	if (!_sharedInstance)
	{
		_sharedInstance = [[BusinessData alloc] init];
	}
    
	return _sharedInstance;
}

@end

