//
//  BMLTSettingsViewController.h
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

#import <UIKit/UIKit.h>
#import "A_BMLTNavBarViewController.h"

/**************************************************************//**
 \class  BMLTSnappyLogSlider
 \brief  This is a very simple overload of UISlider to make "detents."
         It also assumes the slider is base-10 logarithmic.
 *****************************************************************/
@interface BMLTSnappyLogSlider : UISlider

@end

/**************************************************************//**
 \class  BMLTSettingsViewController
 \brief  Allows the user to change the settings/preferences.
 *****************************************************************/
@interface BMLTSettingsViewController : A_BMLTNavBarViewController
@property (weak, nonatomic) IBOutlet UILabel *lookupLocationLabel;
@property (weak, nonatomic) IBOutlet UISwitch *lookUpLocationSwitch;
@property (weak, nonatomic) IBOutlet UILabel *keepUpdatingLabel;
@property (weak, nonatomic) IBOutlet UISwitch *keepUpdatingSwitch;
@property (weak, nonatomic) IBOutlet UILabel *retainStateLabel;
@property (weak, nonatomic) IBOutlet UISwitch *retainStateSwitch;
@property (weak, nonatomic) IBOutlet UILabel *mapResultsLabel;
@property (weak, nonatomic) IBOutlet UISwitch *mapResultsSwitch;
@property (weak, nonatomic) IBOutlet UILabel *distanceSortLabel;
@property (weak, nonatomic) IBOutlet UISwitch *distanceSortSwitch;
@property (weak, nonatomic) IBOutlet UILabel *preferredSearchTypeLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *preferredSearchTypeControl;
@property (weak, nonatomic) IBOutlet UILabel *numMeetingsLabel;
@property (weak, nonatomic) IBOutlet UISlider *numMeetingsSlider;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UIButton *updateLocationButton;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
- (IBAction)updateUserLocationNow:(id)sender;
- (IBAction)lookupLocationChanged:(id)sender;
- (IBAction)keepUpdatingChanged:(id)sender;
- (IBAction)retainStateChanged:(id)sender;
- (IBAction)mapResultsChanged:(id)sender;
- (IBAction)distanceSortChanged:(id)sender;
- (IBAction)preferredSearchChanged:(id)sender;
- (IBAction)numMeetingsChanged:(id)sender;
@end
