//
//  WebViewController.m
//  GreatSchoolsWeek
//
//  Created by Michael Rizkalla on 9/24/12.
//  Copyright (c) 2012 Michael Rizkalla. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSString *urlAddress = @"http://ceefcares.org/get-involved/events/2012gswevents/"; 
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    
    //Load the request in the UIWebView.
    [webView loadRequest:requestObj];
}


@end
