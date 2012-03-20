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

/***************************************************************\**
 \class  BMLTSettingsViewController  -Private Interface
 \brief  Allows the user to change the settings/preferences.
 *****************************************************************/
@interface BMLTSettingsViewController ()

@end

/***************************************************************\**
 \class  BMLTSettingsViewController  -Implementation
 \brief  Allows the user to change the settings/preferences.
 *****************************************************************/
@implementation BMLTSettingsViewController

/***************************************************************\**
 \brief  Initialize the objectfrom a xib/bundle (used by storyboard)
 \returns    self
 *****************************************************************/
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
@synthesize preferredSortTypeLabel;
@synthesize preferredSortTypeControl;
@synthesize numMeetingsLabel;
@synthesize numMeetingsSlider;
@synthesize minLabel;
@synthesize maxLabel;

/***************************************************************\**
 \brief     Initializer.
 \returns   self
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
    [self setPreferredSortTypeLabel:nil];
    [self setPreferredSortTypeControl:nil];
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
- (IBAction)distanceSortChanged:(id)sender
{
}

/***************************************************************\**
 \brief  
 *****************************************************************/
- (IBAction)preferredSortChanged:(id)sender
{
}

/***************************************************************\**
 \brief  
 *****************************************************************/
- (IBAction)numMeetingsChanged:(id)sender
{
}
@end
