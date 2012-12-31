//
//  BMLTSimpleSearchViewController.h
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
#import "A_BMLT_SearchViewController.h"

/*****************************************************************/
/**
 \class  BMLTSimpleSearchViewController
 \brief  This class will present the user with a simple "one-button" interface.
 *****************************************************************/
@interface BMLTSimpleSearchViewController : A_BMLT_SearchViewController
    @property (weak, nonatomic) IBOutlet UIButton   *findMeetingsNearMeButton;      ///< This is the "find meetings near me" button.
    @property (weak, nonatomic) IBOutlet UIButton   *findMeetingsLaterTodayButton;  ///< This is the "find meetings near me later today" button.
    @property (weak, nonatomic) IBOutlet UIButton   *findMeetingsTomorrowButton;    ///< This is the "find meetings near me tomorrow" button.
    @property (weak, nonatomic) IBOutlet UILabel    *disabledTextLabel;             ///< Displayed if the buttons are disabled.
    @property (weak, nonatomic) IBOutlet UIButton   *updateLocationButton;          ///< The update my location button.

    - (IBAction)findAllMeetingsNearMe:(id)sender;                                   ///< Do a simple meeting lookup.
    - (IBAction)findAllMeetingsNearMeLaterToday:(id)sender;                         ///< Do a simple meeting lookup, for meetings later today.
    - (IBAction)findAllMeetingsNearMeTomorrow:(id)sender;                           ///< Do a simple meeting lookup, for meetings tomorrow.
@end
