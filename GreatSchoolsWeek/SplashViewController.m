//
//  SplashViewController.m
//  GreatSchoolsWeek
//
//  Created by Michael Rizkalla on 9/29/12.
//  Copyright (c) 2012 Michael Rizkalla. All rights reserved.
//

#import "SplashViewController.h"
#import "BusinessData.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//#define kLatestGSWBusinessesURL [NSURL URLWithString:@"https://dl.dropbox.com/s/76ygnv61yks7uls/gsw.json?dl=1"]
#define kLatestGSWBusinessesURL [NSURL URLWithString:@"https://dl.dropbox.com/s/fdgus4o4llyvl9r/gsw-2.json?dl=1"]

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)fetchedData:(NSData *)responseData {
    
    BusinessData *gswBusinesses = [BusinessData sharedInstance];
    
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    gswBusinesses.businessArray = [json objectForKey:@"business"];
    
    sleep(3);
    [self performSegueWithIdentifier:@"splash" sender:self];

    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Go get the data
    // Load up the data from the web
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:kLatestGSWBusinessesURL];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];

}
- (void) viewDidAppear:(BOOL)animated
{

    //sleep(3.0);


}
@end
