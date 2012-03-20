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

#define _LOG_MIN    5       /**< The number of meetings in a search test for the Min level of the slider. */
#define _LOG_MAX    20      /**< The number of meetings for the Max level of the slider. */

/***************************************************************\**
 \class  BMLTSnappySlider
 \brief  This is a very simple overload of UISlider to make "detents."
 *****************************************************************/
@implementation BMLTSnappySlider

/***************************************************************\**
 \brief  Initialize the objectfrom a xib/bundle (used by storyboard)
 \returns    self
 *****************************************************************/
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        {
        // The slider is a logarithmic scale between 5 and 20. Nominal is 10.
        float   min_val = log10f(_LOG_MIN);
        float   max_val = log10f(_LOG_MAX);
        
        [self setMinimumValue:min_val];
        [self setMaximumValue:max_val];
        }
    return self;
}

/***************************************************************\**
 \brief This looks for the nearest integer value (after the log),
        and "snaps" the slider to it.
 \returns    self
 *****************************************************************/
- (void)setValue:(float)value animated:(BOOL)animated
{
    float   powVal = powf(10, value);
    float   distance_up = ceilf ( powVal ) - powVal;
    float   distance_down = powVal - floorf(powVal);
    
    [super setValue:log10f ( distance_up < distance_down ? ceilf (powVal) : floorf(powVal) ) animated:animated];
}
@end

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
    
    [numMeetingsSlider setValue:log10f([[NSNumber numberWithInt:[myPrefs resultCount]] floatValue])];
    
    // We make sure that the displayed strings reflect the localized values.
    [lookupLocationLabel setText:NSLocalizedString([lookupLocationLabel text], nil)];
    [keepUpdatingLabel setText:NSLocalizedString([keepUpdatingLabel text], nil)];
    [retainStateLabel setText:NSLocalizedString([retainStateLabel text], nil)];
    [mapResultsLabel setText:NSLocalizedString([mapResultsLabel text], nil)];
    [distanceSortLabel setText:NSLocalizedString([distanceSortLabel text], nil)];
    [preferredSearchTypeLabel setText:NSLocalizedString([preferredSearchTypeLabel text], nil)];
    [numMeetingsLabel setText:NSLocalizedString([numMeetingsLabel text], nil)];
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
 \brief  Called when the user flicks the lookup on startup switch.
 *****************************************************************/
- (IBAction)lookupLocationChanged:(id)sender    ///< The switch in question
{
    UISwitch  *myControl = (UISwitch *)sender;  // Get the sender as a switch
    [[BMLT_Prefs getBMLT_Prefs] setLookupMyLocation:[myControl isOn]];
}

/***************************************************************\**
 \brief  Called when the user flicks the keep updating location switch.
 *****************************************************************/
- (IBAction)keepUpdatingChanged:(id)sender  ///< The switch in question
{
    UISwitch  *myControl = (UISwitch *)sender;  // Get the sender as a switch
    [[BMLT_Prefs getBMLT_Prefs] setKeepUpdatingLocation:[myControl isOn]];
}

/***************************************************************\**
 \brief  Called when the user flicks the saved state switch.
 *****************************************************************/
- (IBAction)retainStateChanged:(id)sender   ///< The switch in question
{
    UISwitch  *myControl = (UISwitch *)sender;  // Get the sender as a switch
    [[BMLT_Prefs getBMLT_Prefs] setPreserveAppStateOnSuspend:[myControl isOn]];
}

/***************************************************************\**
 \brief  Called when the user flicks the return results as a map switch.
 *****************************************************************/
- (IBAction)mapResultsChanged:(id)sender    ///< The switch in question
{
    UISwitch  *myControl = (UISwitch *)sender;  // Get the sender as a switch
    [[BMLT_Prefs getBMLT_Prefs] setPreferSearchResultsAsMap:[myControl isOn]];
}

/***************************************************************\**
 \brief  Called when the user flicks the prefer distance sort switch.
 *****************************************************************/
- (IBAction)distanceSearchChanged:(id)sender    ///< The switch in question
{
    UISwitch  *myControl = (UISwitch *)sender;  // Get the sender as a switch
    [[BMLT_Prefs getBMLT_Prefs] setPreferDistanceSort:[myControl isOn]];
}

/***************************************************************\**
 \brief  Called when the user selects a preffered search type.
 *****************************************************************/
- (IBAction)preferredSearchChanged:(id)sender   ///< The search type segmented control
{
    UISegmentedControl  *myControl = (UISegmentedControl *)sender;  // Get the sender as a segmented control
    [[BMLT_Prefs getBMLT_Prefs] setSearchTypePref:[myControl selectedSegmentIndex]];
}

/***************************************************************\**
 \brief  Called when the user selects a new meeting count.
 *****************************************************************/
- (IBAction)numMeetingsChanged:(id)sender   ///< The meeting count slider
{
    UISlider  *myControl = (UISlider *)sender;  // Get the sender as a slider control
    [[BMLT_Prefs getBMLT_Prefs] setResultCount:floorf(powf(10, [myControl value]))];
}
@end
