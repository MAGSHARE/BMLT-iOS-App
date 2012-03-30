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
#import "BMLT_Results_MapPointAnnotationView.h"
#import "BMLTAppDelegate.h"
#import "BMLT_Prefs.h"

/**************************************************************//**
 \class  BMLTSimpleSearchViewController  -Implementation
 \brief  This class will present the user with a simple "one-button" interface.
 *****************************************************************/
@implementation BMLTSimpleSearchViewController
@synthesize mapSearchView;

@synthesize findMeetingsNearMeButton;
@synthesize findMeetingsLaterTodayButton;
@synthesize findMeetingsTomorrowButton;

/**************************************************************//**
 \brief  Called after the controller's view object has loaded.
 *****************************************************************/
- (void)viewDidLoad
{
    [findMeetingsNearMeButton setTitle:NSLocalizedString([findMeetingsNearMeButton titleForState:UIControlStateNormal], nil) forState:UIControlStateNormal];
    [findMeetingsLaterTodayButton setTitle:NSLocalizedString([findMeetingsLaterTodayButton titleForState:UIControlStateNormal], nil) forState:UIControlStateNormal];
    [findMeetingsTomorrowButton setTitle:NSLocalizedString([findMeetingsTomorrowButton titleForState:UIControlStateNormal], nil) forState:UIControlStateNormal];
    [super viewDidLoad];
}

/**************************************************************//**
 \brief  Called after the controller's view object has unloaded.
 *****************************************************************/
- (void)viewDidUnload
{
    [self setFindMeetingsNearMeButton:nil];
    [self setFindMeetingsLaterTodayButton:nil];
    [self setMapSearchView:nil];
    [super viewDidUnload];
}

/**************************************************************//**
 \brief  Called just before the view will appear. We use it to set
         up the map (in an iPad).
 *****************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setUpMap];
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
        [myAppDelegate searchForMeetingsNearMe];
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
        [myAppDelegate searchForMeetingsNearMeLaterToday];
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
        [myAppDelegate searchForMeetingsNearMeTomorrow];
        }
}

/**************************************************************//**
 \brief  If this is an iPad, we'll set up the map.
 *****************************************************************/
- (void)setUpMap
{
    if ( mapSearchView )
        {
#ifdef DEBUG
        NSLog(@"BMLTSimpleSearchViewController setUpIpadMap called (We're an iPad, baby!).");
#endif
        BMLTAppDelegate *myAppDelegate = [BMLTAppDelegate getBMLTAppDelegate];  // Get the app delegate SINGLETON
        
        CLLocationCoordinate2D  center;
#ifdef DEBUG
        NSLog(@"BMLTSimpleSearchViewController setUpIpadMap We're using the canned coordinates.");
#endif
        center.latitude = [NSLocalizedString(@"INITIAL-MAP-LAT", nil) doubleValue];
        center.longitude = [NSLocalizedString(@"INITIAL-MAP-LONG", nil) doubleValue];
        
        if ( [myAppDelegate myLocation] )
            {
#ifdef DEBUG
            NSLog(@"BMLTSimpleSearchViewController setUpIpadMap We know where we are, so we'll set the map to that.");
#endif
            center = [myAppDelegate myLocation].coordinate;
            }
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, 25000, 25000);
    
        [mapSearchView setRegion:region animated:NO];
        BMLT_Results_MapPointAnnotation *myMarker = [[BMLT_Results_MapPointAnnotation alloc] initWithCoordinate:center andMeetings:nil];
        
        [mapSearchView addAnnotation:myMarker];
        
        if ( [[BMLT_Prefs getBMLT_Prefs] keepUpdatingLocation] )    // If the user wants us to keep track of them, then we'll do so.
            {
            [mapSearchView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
            }
        else
            {
            [mapSearchView setUserTrackingMode:MKUserTrackingModeNone animated:NO];
            }
        }
}
@end
