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
#import "BMLTBrassCheckBoxButton.h"

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
@interface BMLTAdvancedSearchViewController : A_BMLT_SearchViewController <UITextFieldDelegate, NSXMLParserDelegate>

@property (atomic, weak, readonly)  IBOutlet UILabel            *weekdaysLabel;     ///< The label item for the weekdays.
@property (atomic, weak, readonly)  IBOutlet UISegmentedControl *weekdaysSelector;  ///< The mode selector for the weekday selection.
@property (atomic, weak, readonly)  IBOutlet UILabel            *sunLabel;          ///< The label for the "Sunday" checkbox.
@property (atomic, weak, readonly)  IBOutlet BMLTBrassCheckBoxButton      *sunButton;         ///< The "Sunday" checkbox.
@property (atomic, weak, readonly)  IBOutlet UILabel            *monLabel;          ///< The label for the "Monday" checkbox.
@property (atomic, weak, readonly)  IBOutlet BMLTBrassCheckBoxButton      *monButton;         ///< The "Monday" checkbox.
@property (atomic, weak, readonly)  IBOutlet UILabel            *tueLabel;          ///< The label for the "Tuesday" checkbox.
@property (atomic, weak, readonly)  IBOutlet BMLTBrassCheckBoxButton      *tueButton;         ///< The "Tuesday" checkbox.
@property (atomic, weak, readonly)  IBOutlet UILabel            *wedLabel;          ///< The label for the "Wednesday" checkbox.
@property (atomic, weak, readonly)  IBOutlet BMLTBrassCheckBoxButton      *wedButton;         ///< The "Wednesday" checkbox.
@property (atomic, weak, readonly)  IBOutlet UILabel            *thuLabel;          ///< The label for the "Thursday" checkbox.
@property (atomic, weak, readonly)  IBOutlet BMLTBrassCheckBoxButton      *thuButton;         ///< The "Thursday" checkbox.
@property (atomic, weak, readonly)  IBOutlet UILabel            *friLabel;          ///< The label for the "Friday" checkbox.
@property (atomic, weak, readonly)  IBOutlet BMLTBrassCheckBoxButton      *friButton;         ///< The "Friday" checkbox.
@property (atomic, weak, readonly)  IBOutlet UILabel            *satLabel;          ///< The label for the "Saturday" checkbox.
@property (atomic, weak, readonly)  IBOutlet BMLTBrassCheckBoxButton      *satButton;         ///< The "Saturday" checkbox.

@property (atomic, weak, readonly)  IBOutlet UILabel            *searchLocationLabel;           ///< The label for the location specification items.
@property (atomic, weak, readonly)  IBOutlet UISegmentedControl *searchSpecSegmentedControl;    ///< The segmented control that specifies the location mode.
@property (atomic, weak, readonly)  IBOutlet UITextField        *searchSpecAddressTextEntry;    ///< The address entry text item.

@property (atomic, weak, readonly)  IBOutlet UIButton           *goButton;          ///< This is the button that starts the search.

@property (strong, atomic, readwrite)   NSMutableDictionary     *myParams;          ///< This dictionary will be used to build up the parameters we'll be giving the app delegate for our search.

@property (strong, atomic, readwrite)   NSString                *currentElement;    ///< This will be used during our XML parsing adventure.

- (IBAction)weekdaySelectionChanged:(id)sender;
- (IBAction)doSearchButtonPressed:(id)sender;
- (IBAction)backgroundClicked:(id)sender;
- (IBAction)weekdayChanged:(id)sender;
- (IBAction)searchSpecChanged:(id)sender;
- (IBAction)addressTextEntered:(id)sender;

- (void)setParamsForWeekdaySelection;
- (void)lookupLocationFromAddressString:(NSString *)inLocationString;
- (void)cantGeocode;

@end
