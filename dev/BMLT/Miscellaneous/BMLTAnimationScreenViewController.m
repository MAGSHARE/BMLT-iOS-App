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
#import "BMLT_AnimationView.h"

/**************************************************************//**
 \class BMLTAnimationScreenViewController
 \brief This implements a view with the animated globe and, if necessary,
        a failure message. It is pushed onto the search stack.
 *****************************************************************/
@implementation BMLTAnimationScreenViewController
@synthesize messageLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[BMLTVariantDefs windowBackgroundColor]];
}

/**************************************************************//**
 \brief Called just before the screen appears. We use it to set a
        "tracker" variable in the app delegate, and to set the title.
 *****************************************************************/
- (void)viewDidAppear:(BOOL)animated   ///< YES, if the appearance is animated.
{
    [[self messageLabel] setText:@""];
    [[BMLTAppDelegate getBMLTAppDelegate] setCurrentAnimation:self];
    [[self animationView] startAnimating];
    [[BMLTAppDelegate getBMLTAppDelegate] executeDeferredSearch];
}

/**************************************************************//**
 \brief We take this opportunity to remove ourselves from the "tracker."
 *****************************************************************/
- (void)viewDidDisappear:(BOOL)animated
{
    [[self animationView] stopAnimating];
    [[BMLTAppDelegate getBMLTAppDelegate] setCurrentAnimation:nil];
    [super viewDidDisappear:animated];
    // Release any retained subviews of the main view.
}

/**************************************************************//**
 \brief We follow the same rules as all the other views.
 \returns YES, if the autorotation is approved.
 *****************************************************************/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io   ///< The desired rotation
{
    BOOL    ret = (io == UIInterfaceOrientationPortrait);   // iPhone is portrait-only.
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)   // iPad is any which way.
        {
        ret = YES;
        }
    
    return ret;
}

- (void)viewDidUnload {
    [self setAnimationView:nil];
    [super viewDidUnload];
}
@end
