//
//  BMLTSecondViewController.m
//  BMLT
//
//  Created by Chris Marshall on 3/10/12.
//  Copyright (c) 2012 Nikon Inc. All rights reserved.
//

#import "BMLTSecondViewController.h"

@interface BMLTSecondViewController ()

@end

@implementation BMLTSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
