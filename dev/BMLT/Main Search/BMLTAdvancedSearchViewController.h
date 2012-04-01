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
#import "BrassCheckBox.h"

#define kBMLT_AdvancedItemsBottomPaddingInPixels    8

#define kWeekdaySelectAllDays       0
#define kWeekdaySelectWeekdays      1
#define kWeekdaySelectToday         2
#define kWeekdaySelectTomorrow      3

#define kWeekdaySelectValue_Sun     1
#define kWeekdaySelectValue_Mon     2
#define kWeekdaySelectValue_Tue     3
#define kWeekdaySelectValue_Wed     4
#define kWeekdaySelectValue_Thu     5
#define kWeekdaySelectValue_Fri     6
#define kWeekdaySelectValue_Sat     7


/**************************************************************//**
 \class  BMLTAdvancedSearchViewController
 \brief  This class will present the user with a powerful search specification interface.
 *****************************************************************/
@interface BMLTAdvancedSearchViewController : A_BMLT_SearchViewController <UITextFieldDelegate>
@property (atomic, weak, readonly)  IBOutlet UILabel            *weekdaysLabel;
@property (atomic, weak, readonly)  IBOutlet UISegmentedControl *weekdaysSelector;
@property (atomic, weak, readonly)  IBOutlet UILabel            *sunLabel;
@property (atomic, weak, readonly)  IBOutlet BrassCheckBox      *sunButton;
@property (atomic, weak, readonly)  IBOutlet UILabel            *monLabel;
@property (atomic, weak, readonly)  IBOutlet BrassCheckBox      *monButton;
@property (atomic, weak, readonly)  IBOutlet UILabel            *tueLabel;
@property (atomic, weak, readonly)  IBOutlet BrassCheckBox      *tueButton;
@property (atomic, weak, readonly)  IBOutlet UILabel            *wedLabel;
@property (atomic, weak, readonly)  IBOutlet BrassCheckBox      *wedButton;
@property (atomic, weak, readonly)  IBOutlet UILabel            *thuLabel;
@property (atomic, weak, readonly)  IBOutlet BrassCheckBox      *thuButton;
@property (atomic, weak, readonly)  IBOutlet UILabel            *friLabel;
@property (atomic, weak, readonly)  IBOutlet BrassCheckBox      *friButton;
@property (atomic, weak, readonly)  IBOutlet UILabel            *satLabel;
@property (atomic, weak, readonly)  IBOutlet BrassCheckBox      *satButton;

@property (atomic, weak, readonly)  IBOutlet UILabel            *searchLocationLabel;
@property (atomic, weak, readonly)  IBOutlet UISegmentedControl *searchSpecSegmentedControl;
@property (atomic, weak, readonly)  IBOutlet UITextField        *searchSpecAddressTextEntry;

@property (atomic, weak, readonly)  IBOutlet UIButton           *goButton;

@property (strong, atomic, readwrite)   NSMutableDictionary     *myParams;

- (IBAction)weekdaySelectionChanged:(id)sender;
- (IBAction)doSearchButtonPressed:(id)sender;
- (IBAction)backgroundClicked:(id)sender;
- (IBAction)weekdayChanged:(id)sender;
- (IBAction)searchSpecChanged:(id)sender;
- (IBAction)addressTextEntered:(id)sender;

- (void)setParamsForWeekdaySelection;

@end
