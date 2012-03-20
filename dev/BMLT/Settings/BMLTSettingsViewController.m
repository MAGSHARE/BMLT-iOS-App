//
//  BMLTSettingsViewController.m
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

#import "BMLTSettingsViewController.h"
#import "BMLT_Prefs.h"

/***************************************************************\**
 \class  BMLTSettingsViewController  -Implementation
 \brief  Allows the user to change the settings/preferences.
 *****************************************************************/
@implementation BMLTSettingsViewController

@synthesize lookupLocationLabel;
@synthesize lookUpLocationSwitch;
@synthesize keepUpdatingLabel;
@synthesize keepUpdatingSwitch;
@synthesize retainStateLabel;
@synthesize retainStateSwitch;
@synthesize mapResultsLabel;
@synthesize mapResultsSwitch;
@synthesize distanceSortLabel;
@synthesize distanceSortSwitch;
@synthesize preferredSearchTypeLabel;
@synthesize preferredSearchTypeControl;
@synthesize numMeetingsLabel;
@synthesize numMeetingsSlider;
@synthesize minLabel;
@synthesize maxLabel;

/***************************************************************\**
 \brief  Initialize the objectfrom a xib/bundle (used by storyboard)
 \returns    self
 *****************************************************************/
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
        {
        }
    return self;
}

/***************************************************************\**
 \brief  Called after the controller's view object has loaded.
 *****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // We set the values of the various controls to reflect the current settings.
    BMLT_Prefs  *myPrefs = [BMLT_Prefs getBMLT_Prefs];
    [lookUpLocationSwitch setOn:[myPrefs lookupMyLocation]];
    [keepUpdatingSwitch setOn:[myPrefs keepUpdatingLocation]];
    [retainStateSwitch setOn:[myPrefs preserveAppStateOnSuspend]];
    [mapResultsSwitch setOn:[myPrefs preferSearchResultsAsMap]];
    [distanceSortSwitch setOn:[myPrefs preferDistanceSort]];
    
    switch ( [myPrefs searchTypePref] )
    {
        default:
        case _PREFER_SIMPLE_SEARCH:
        [preferredSearchTypeControl setSelectedSegmentIndex:_PREFER_SIMPLE_SEARCH];
        break;
        
        case _PREFER_MAP_SEARCH:
        [preferredSearchTypeControl setSelectedSegmentIndex:_PREFER_MAP_SEARCH];
        break;
        
        case _PREFER_ADVANCED_SEARCH:
        [preferredSearchTypeControl setSelectedSegmentIndex:_PREFER_ADVANCED_SEARCH];
        break;
    }
    
    // We make sure that the displayed strings reflect the localized values.
    [numMeetingsSlider setValue:[[NSNumber numberWithInt:[myPrefs resultCount]] floatValue]];

    [lookupLocationLabel setText:NSLocalizedString([lookupLocationLabel text], nil)];
    [keepUpdatingLabel setText:NSLocalizedString([keepUpdatingLabel text], nil)];
    [retainStateLabel setText:NSLocalizedString([retainStateLabel text], nil)];
    [mapResultsLabel setText:NSLocalizedString([mapResultsLabel text], nil)];
    [distanceSortLabel setText:NSLocalizedString([distanceSortLabel text], nil)];
    [preferredSearchTypeLabel setText:NSLocalizedString([preferredSearchTypeLabel text], nil)];
    [minLabel setText:NSLocalizedString([minLabel text], nil)];
    [maxLabel setText:NSLocalizedString([maxLabel text], nil)];
    
    for ( NSUInteger i = 0; i < [preferredSearchTypeControl numberOfSegments]; i++ )
        {
        [preferredSearchTypeControl setTitle:NSLocalizedString([preferredSearchTypeControl titleForSegmentAtIndex:i], nil) forSegmentAtIndex:i];
        }
}

/***************************************************************\**
 \brief  Called after the controller's view object has unloaded.
 *****************************************************************/
- (void)viewDidUnload
{
    [self setLookupLocationLabel:nil];
    [self setLookUpLocationSwitch:nil];
    [self setKeepUpdatingLabel:nil];
    [self setKeepUpdatingSwitch:nil];
    [self setRetainStateLabel:nil];
    [self setRetainStateSwitch:nil];
    [self setMapResultsLabel:nil];
    [self setMapResultsSwitch:nil];
    [self setDistanceSortLabel:nil];
    [self setDistanceSortSwitch:nil];
    [self setPreferredSearchTypeLabel:nil];
    [self setPreferredSearchTypeControl:nil];
    [self setNumMeetingsLabel:nil];
    [self setNumMeetingsSlider:nil];
    [self setMinLabel:nil];
    [self setMaxLabel:nil];
    [super viewDidUnload];
}

/***************************************************************\**
 \brief  
 *****************************************************************/
- (IBAction)lookupLocationChanged:(id)sender
{
}

/***************************************************************\**
 \brief  
 *****************************************************************/
- (IBAction)keepUpdatingChanged:(id)sender
{
}

/***************************************************************\**
 \brief  
 *****************************************************************/
- (IBAction)retainStateChanged:(id)sender
{
}

/***************************************************************\**
 \brief  
 *****************************************************************/
- (IBAction)mapResultsChanged:(id)sender
{
}

/***************************************************************\**
 \brief  
 *****************************************************************/
- (IBAction)distanceSearchChanged:(id)sender
{
}

/***************************************************************\**
 \brief  
 *****************************************************************/
- (IBAction)preferredSearchChanged:(id)sender
{
}

/***************************************************************\**
 \brief  
 *****************************************************************/
- (IBAction)numMeetingsChanged:(id)sender
{
}
@end
