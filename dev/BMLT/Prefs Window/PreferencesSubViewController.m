//
//  PreferencesSubViewController.m
//  BMLT
//
//  Created by MAGSHARE on 8/13/11.
//  Copyright 2011 MAGSHARE. All rights reserved.
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

#import "PreferencesSubViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "BMLTAppDelegate.h"

@implementation PreferencesSubViewController

#pragma mark - View lifecycle

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setSwitches
{
    
    [findMyLocationLabel setTitle:NSLocalizedString(@"SETTINGS-UPDATE-LOCATION-ON-STARTUP", nil) forState:UIControlStateNormal];
    [startWithMapLabel setTitle:NSLocalizedString(@"SETTINGS-START-WITH-MAP", nil) forState:UIControlStateNormal];
    [preferDistanceSortLabel setTitle:NSLocalizedString(@"SETTINGS-PREFER-DISTANCE-SORT", nil) forState:UIControlStateNormal];
    [findLocationNowButton setTitle:NSLocalizedString(@"SETTINGS-UPDATE-LOCATION", nil) forState:UIControlStateNormal];
    [startWithSearchButton setTitle:NSLocalizedString(@"SETTINGS-START-WITH-SEARCH", nil) forState:UIControlStateNormal];
    
    BMLT_Prefs  *prefs = [BMLT_Prefs getBMLT_Prefs];
    
    if ( ([CLLocationManager locationServicesEnabled] != NO) && ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) )
        {
        [findLocationNowButton setAlpha:1];
        [findMyLocationLabel setAlpha:1];
        [findMyLocationSwitch setAlpha:1];
        [findMyLocationSwitch setOn:[prefs lookupMyLocation]];
        }
    else
        {
        [findLocationNowButton setAlpha:0];
        [findMyLocationLabel setAlpha:0];
        [findMyLocationSwitch setAlpha:0];
        }

    if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad )
        {
        [preferAdvancedButton setAlpha:0];
        [preferAdvancedSwitch setAlpha:0];
        }
    else
        {
        [preferAdvancedButton setTitle:NSLocalizedString(@"SETTINGS-PREFER-ADVANCED", nil) forState:UIControlStateNormal];
        [preferAdvancedSwitch setOn:[prefs preferAdvancedSearch]];
        }
    
    [startWithMapSwitch setOn:[prefs startWithMap]];
    [preferDistanceSortSwitch setOn:[prefs preferDistanceSort]];
    [startWithSearchSwitch setOn:[prefs startWithSearch]];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)viewDidUnload
{
    [basicPrefsView release];
    basicPrefsView = nil;
    [findMyLocationLabel release];
    findMyLocationLabel = nil;
    [startWithMapLabel release];
    startWithMapLabel = nil;
    [preferDistanceSortLabel release];
    preferDistanceSortLabel = nil;
    [findMyLocationSwitch release];
    findMyLocationSwitch = nil;
    [startWithMapSwitch release];
    startWithMapSwitch = nil;
    [preferDistanceSortSwitch release];
    preferDistanceSortSwitch = nil;
    [findLocationNowButton release];
    findLocationNowButton = nil;
    [startWithSearchSwitch release];
    startWithSearchSwitch = nil;
    [startWithSearchButton release];
    startWithSearchButton = nil;
    [preferAdvancedSwitch release];
    preferAdvancedSwitch = nil;
    [preferAdvancedButton release];
    preferAdvancedButton = nil;
    [super viewDidUnload];
}

/***************************************************************\**
 \brief We only want portrait for this one.
 \returns a BOOL. YES if the orientation is correct.
 *****************************************************************/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    BOOL    ret = io == UIInterfaceOrientationPortrait;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
        ret = YES;
        }
    
    return ret;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)dealloc
{
    [basicPrefsView release];
    [findMyLocationLabel release];
    [startWithMapLabel release];
    [preferDistanceSortLabel release];
    [findMyLocationSwitch release];
    [startWithMapSwitch release];
    [preferDistanceSortSwitch release];
    [findLocationNowButton release];
    [startWithSearchSwitch release];
    [startWithSearchButton release];
    [preferAdvancedSwitch release];
    [preferAdvancedButton release];
    [super dealloc];
}

#pragma mark - Callbacks

/***************************************************************\**
 \brief 
 *****************************************************************/
- (IBAction)findNewLocation:(id)sender
{
    [[BMLTAppDelegate getBMLTAppDelegate] findLocation];
}
/***************************************************************\**
 \brief 
 *****************************************************************/
- (IBAction)findLocationTouched:(id)sender
{
    BMLT_Prefs  *thePrefs = [BMLT_Prefs getBMLT_Prefs];
    [thePrefs setLookupMyLocation:[(UISwitch *)sender isOn]];
    [BMLT_Prefs saveChanges];
    [self setSwitches];
    if ( [findMyLocationSwitch isOn] )
        {
        [self findNewLocation:nil];
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (IBAction)findMyLocationToggle:(id)sender
{
    [findMyLocationSwitch setOn:![findMyLocationSwitch isOn]];
    [self findLocationTouched:findMyLocationSwitch];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (IBAction)startWithMapTouched:(id)sender
{
    BMLT_Prefs  *thePrefs = [BMLT_Prefs getBMLT_Prefs];
    [thePrefs setStartWithMap:[(UISwitch *)sender isOn]];
    [BMLT_Prefs saveChanges];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (IBAction)startWithMapToggle:(id)sender
{
    [startWithMapSwitch setOn:![startWithMapSwitch isOn]];
    [self startWithMapTouched:startWithMapSwitch];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (IBAction)preferDistanceSortTouched:(id)sender
{
    BMLT_Prefs  *thePrefs = [BMLT_Prefs getBMLT_Prefs];
    [thePrefs setPreferDistanceSort:[(UISwitch *)sender isOn]];
    [BMLT_Prefs saveChanges];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (IBAction)preferDistanceSortToggle:(id)sender
{
    [preferDistanceSortSwitch setOn:![preferDistanceSortSwitch isOn]];
    [self preferDistanceSortTouched:preferDistanceSortSwitch];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (IBAction)startWithSearchTouched:(id)sender
{
    BMLT_Prefs  *thePrefs = [BMLT_Prefs getBMLT_Prefs];
    [thePrefs setStartWithSearch:[(UISwitch *)sender isOn]];
    [BMLT_Prefs saveChanges];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (IBAction)startWithSearchToggle:(id)sender
{
    [startWithSearchSwitch setOn:![startWithSearchSwitch isOn]];
    [self startWithSearchTouched:startWithSearchSwitch];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (IBAction)preferAdvancedTouched:(id)sender
{
    BMLT_Prefs  *thePrefs = [BMLT_Prefs getBMLT_Prefs];
    [thePrefs setPreferAdvancedSearch:[(UISwitch *)sender isOn]];
    [BMLT_Prefs saveChanges];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (IBAction)preferAdvancedToggle:(id)sender
{
    [preferAdvancedSwitch setOn:![preferAdvancedSwitch isOn]];
    [self preferAdvancedTouched:preferAdvancedSwitch];
}

@end
