//
//  BMLTAdvancedSearchViewController.h
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
#import "BMLT_Checkbox.h"

/// These are the states for the weekday selection mode segmented control.
enum
{
    kWeekdaySelectAllDays = 0,  ///< Select all days (disables all the checkboxes)
    kWeekdaySelectWeekdays,     ///< Select any weekday[s]. This enables all of the checkboxes.
    kWeekdaySelectToday,        ///< Select Today. This disables all of the checkboxes, but marks "today" as selected (even though it is disabled).
    kWeekdaySelectTomorrow      ///< Select Tomorrow. Same as above, except "Tomorrow" is selected.
};

/// These are the indexes for the weekdays. These are used for calculation of the parameters.
enum
{
    kWeekdaySelectValue_Sun = 1,
    kWeekdaySelectValue_Mon,
    kWeekdaySelectValue_Tue,
    kWeekdaySelectValue_Wed,
    kWeekdaySelectValue_Thu,
    kWeekdaySelectValue_Fri,
    kWeekdaySelectValue_Sat
};

/**************************************************************//**
 \class  BMLTAdvancedSearchViewController
 \brief  This class will present the user with a powerful search specification interface.
 *****************************************************************/
@interface BMLTAdvancedSearchViewController : A_BMLT_SearchViewController <UITextFieldDelegate>
@property (atomic, weak, readonly)  IBOutlet UILabel                *weekdaysLabel;     ///< The label item for the weekdays.
@property (atomic, weak, readonly)  IBOutlet UISegmentedControl     *weekdaysSelector;  ///< The mode selector for the weekday selection.

/// These are for the weekday checkboxes.
@property (weak, nonatomic) IBOutlet UILabel        *sunLabel;
@property (weak, nonatomic) IBOutlet BMLT_Checkbox  *sunButton;
@property (weak, nonatomic) IBOutlet UILabel        *monLabel;
@property (weak, nonatomic) IBOutlet BMLT_Checkbox  *monButton;
@property (weak, nonatomic) IBOutlet UILabel        *tueLabel;
@property (weak, nonatomic) IBOutlet BMLT_Checkbox  *tueButton;
@property (weak, nonatomic) IBOutlet UILabel        *wedLabel;
@property (weak, nonatomic) IBOutlet BMLT_Checkbox  *wedButton;
@property (weak, nonatomic) IBOutlet UILabel        *thuLabel;
@property (weak, nonatomic) IBOutlet BMLT_Checkbox  *thuButton;
@property (weak, nonatomic) IBOutlet UILabel        *friLabel;
@property (weak, nonatomic) IBOutlet BMLT_Checkbox  *friButton;
@property (weak, nonatomic) IBOutlet UILabel        *satLabel;
@property (weak, nonatomic) IBOutlet BMLT_Checkbox  *satButton;

@property (atomic, weak, readonly)  IBOutlet UILabel                *searchLocationLabel;           ///< The label for the location specification items.
@property (atomic, weak, readonly)  IBOutlet UISegmentedControl     *searchSpecSegmentedControl;    ///< The segmented control that specifies the location mode.
@property (atomic, weak, readonly)  IBOutlet UITextField            *searchSpecAddressTextEntry;    ///< The address entry text item.

@property (atomic, weak, readonly)  IBOutlet UIButton               *goButton;          ///< This is the button that starts the search.

@property (strong, atomic, readwrite)   NSMutableDictionary         *myParams;          ///< This dictionary will be used to build up the parameters we'll be giving the app delegate for our search.

@property (strong, atomic, readwrite)   NSString                    *currentElement;    ///< This will be used during our XML parsing adventure.

- (IBAction)weekdaySelectionChanged:(id)sender;
- (IBAction)doSearchButtonPressed:(id)sender;
- (IBAction)backgroundClicked:(id)sender;
- (IBAction)weekdayChanged:(id)sender;
- (IBAction)searchSpecChanged:(id)sender;
- (IBAction)addressTextEntered:(id)sender;

- (void)setParamsForWeekdaySelection;
- (void)geocodeLocationFromAddressString:(NSString *)inLocationString;

@end
