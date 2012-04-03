//
//  BMLTSimpleSearchViewController.m
//  BMLT
//
//  Created by MAGSHARE.
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

#import "BMLTSimpleSearchViewController.h"
#import "BMLTAppDelegate.h"
#import "BMLT_Prefs.h"

/**************************************************************//**
 \class  BMLTSimpleSearchViewController  -Implementation
 \brief  This class will present the user with a simple "one-button" interface.
 *****************************************************************/
@implementation BMLTSimpleSearchViewController
@synthesize disabledTextLabel;

@synthesize findMeetingsNearMeButton;
@synthesize findMeetingsLaterTodayButton;
@synthesize findMeetingsTomorrowButton;

/**************************************************************//**
 \brief  Called after the controller's view object has loaded.
 *****************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [findMeetingsNearMeButton setTitle:NSLocalizedString([findMeetingsNearMeButton titleForState:UIControlStateNormal], nil) forState:UIControlStateNormal];
    [findMeetingsLaterTodayButton setTitle:NSLocalizedString([findMeetingsLaterTodayButton titleForState:UIControlStateNormal], nil) forState:UIControlStateNormal];
    [findMeetingsTomorrowButton setTitle:NSLocalizedString([findMeetingsTomorrowButton titleForState:UIControlStateNormal], nil) forState:UIControlStateNormal];
    [disabledTextLabel setText:NSLocalizedString([disabledTextLabel text], nil)];
    [disabledTextLabel setAlpha:0.0];
    
    // If there's no way for us to search (We're on an iPhone or iPod Touch with no location services, and we have no map on those devices), then we can't use these buttons.
    if ( ![BMLTAppDelegate locationServicesAvailable] && ![self mapSearchView] )
        {
        [findMeetingsNearMeButton setEnabled:NO];
        [findMeetingsLaterTodayButton setEnabled:NO];
        [findMeetingsTomorrowButton setEnabled:NO];
        [disabledTextLabel setAlpha:1.0];
        }
    
    if ( [[[BMLTAppDelegate getBMLTAppDelegate] searchResults] count] )
        {
        [self addClearSearchButton];
        }
    [super viewWillAppear:animated];
}

/**************************************************************//**
 \brief  Called after the controller's view object has unloaded.
 *****************************************************************/
- (void)viewDidUnload
{
    [self setFindMeetingsNearMeButton:nil];
    [self setFindMeetingsLaterTodayButton:nil];
    [self setMapSearchView:nil];
    [self setDisabledTextLabel:nil];
    [super viewDidUnload];
}

#pragma mark IB Actions
/**************************************************************//**
 \brief  Do a simple meeting lookup.
 *****************************************************************/
- (IBAction)findAllMeetingsNearMe:(id)sender    ///< The object that called this.
{
    BMLTAppDelegate *myAppDelegate = [BMLTAppDelegate getBMLTAppDelegate];  // Get the app delegate SINGLETON
    
    if ( myAppDelegate && [BMLTAppDelegate locationServicesAvailable] )
        {
#ifdef DEBUG
        NSLog(@"BMLTSimpleSearchViewController findAllMeetingsNearMe.");
#endif
        [myAppDelegate searchForMeetingsNearMe:[self getSearchCoordinatesAndForceReNew:YES]];
        }
}

/**************************************************************//**
 \brief  Do a simple meeting lookup, for meetings later today.
 *****************************************************************/
- (IBAction)findAllMeetingsNearMeLaterToday:(id)sender    ///< The object that called this.
{
    BMLTAppDelegate *myAppDelegate = [BMLTAppDelegate getBMLTAppDelegate];  // Get the app delegate SINGLETON
    
    if ( myAppDelegate && [BMLTAppDelegate locationServicesAvailable] )
        {
#ifdef DEBUG
        NSLog(@"BMLTSimpleSearchViewController findAllMeetingsNearMeLaterToday.");
#endif
        [myAppDelegate searchForMeetingsNearMeLaterToday:[self getSearchCoordinatesAndForceReNew:YES]];
        }
}

/**************************************************************//**
 \brief  Do a simple meeting lookup, for meetings tomorrow.
 *****************************************************************/
- (IBAction)findAllMeetingsNearMeTomorrow:(id)sender    ///< The object that called this.
{
    BMLTAppDelegate *myAppDelegate = [BMLTAppDelegate getBMLTAppDelegate];  // Get the app delegate SINGLETON
    
    if ( myAppDelegate && [BMLTAppDelegate locationServicesAvailable] )
        {
#ifdef DEBUG
        NSLog(@"BMLTSimpleSearchViewController findAllMeetingsNearMeTomorrow.");
#endif
        [myAppDelegate searchForMeetingsNearMeTomorrow:[self getSearchCoordinatesAndForceReNew:YES]];
        }
}
@end
