//
//  BusinessData.h
//  GreatSchoolsWeek
//
//  Created by Michael Rizkalla on 9/18/12.
//  Copyright (c) 2012 Michael Rizkalla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessData : NSObject

@property (strong,nonatomic) NSArray *businessArray;

+ (BusinessData *) sharedInstance;

@end
