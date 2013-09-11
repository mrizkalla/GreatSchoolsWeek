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
@synthesize imageView;

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
    
    // Set the splash screen image
    UIImage *image = [SplashViewController imageNamedForDevice:@"SplashScreen.png"];
    [imageView setImage:image];
    
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

+ (UIImage*)imageNamedForDevice:(NSString*)name {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (([UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale) >= 1136.0f)
        {
            //Check if is there a path extension or not
            if (name.pathExtension.length) {
                name = [name stringByReplacingOccurrencesOfString: [NSString stringWithFormat:@".%@", name.pathExtension]
                                                       withString: [NSString stringWithFormat:@"-568h@2x.%@", name.pathExtension ] ];
                
            } else {
                name = [name stringByAppendingString:@"-568h@2x"];
            }
            
            //load the image e.g from disk or cache
            UIImage *image = [UIImage imageNamed: name ];
            if (image) {
                //strange Bug in iOS, the image name have a "@2x" but the scale isn't 2.0f
                return [UIImage imageWithCGImage: image.CGImage scale:2.0f orientation:image.imageOrientation];
            }
            
        }
    }
    
    return [UIImage imageNamed: name ];
    
}
@end
