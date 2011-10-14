//
//  PreferencesSubViewController.h
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

#import <UIKit/UIKit.h>

@interface PreferencesSubViewController : UIViewController
{
    IBOutlet UIView     *basicPrefsView;
    IBOutlet UIButton   *findMyLocationLabel;
    IBOutlet UIButton   *startWithMapLabel;
    IBOutlet UIButton   *preferDistanceSortLabel;
    IBOutlet UISwitch   *findMyLocationSwitch;
    IBOutlet UISwitch   *startWithMapSwitch;
    IBOutlet UISwitch   *preferDistanceSortSwitch;
    IBOutlet UIButton   *findLocationNowButton;
}
- (void)setSwitches;
- (IBAction)findNewLocation:(id)sender;
- (IBAction)findLocationTouched:(id)sender;
- (IBAction)findMyLocationToggle:(id)sender;
- (IBAction)startWithMapTouched:(id)sender;
- (IBAction)startWithMapToggle:(id)sender;
- (IBAction)preferDistanceSortToggle:(id)sender;
- (IBAction)preferDistanceSortTouched:(id)sender;

@end
