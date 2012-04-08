//
//  BMLTAnimationScreenViewController.m
//  BMLT
//
//  Created by MAGSHARE.
//  Copyright 2012 MAGSHARE. All rights reserved.
//
//  This is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//  
//  BMLT is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with this code.  If not, see <http://www.gnu.org/licenses/>.
//

#import "BMLTAnimationScreenViewController.h"
#import "BMLTAppDelegate.h"

@interface BMLTAnimationScreenViewController ()

@end

@implementation BMLTAnimationScreenViewController
@synthesize messageLabel;

- (void)viewWillAppear:(BOOL)animated
{
    [[self messageLabel] setText:@""];
    [[BMLTAppDelegate getBMLTAppDelegate] setCurrentAnimation:self];
    [[self navigationItem] setTitle:NSLocalizedString(@"SEARCH-ANIMATION-TITLE", nil)];
}

- (void)viewDidUnload
{
    [[BMLTAppDelegate getBMLTAppDelegate] setCurrentAnimation:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    BOOL    ret = (io == UIInterfaceOrientationPortrait);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
        ret = YES;
        }
    
    return ret;
}

@end
