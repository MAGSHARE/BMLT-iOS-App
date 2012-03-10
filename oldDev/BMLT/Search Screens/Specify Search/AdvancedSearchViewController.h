//
//  AdvancedSearchViewController.h
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

@class SpecifyNewSearchViewController;

@interface AdvancedSearchViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UILabel                            *weekdaysLabel;
    IBOutlet UISegmentedControl                 *weekdaysSelector;
    IBOutlet UILabel                            *sunLabel;
    IBOutlet BrassCheckBox                      *sunButton;
    IBOutlet UILabel                            *monLabel;
    IBOutlet BrassCheckBox                      *monButton;
    IBOutlet UILabel                            *tueLabel;
    IBOutlet BrassCheckBox                      *tueButton;
    IBOutlet UILabel                            *wedLabel;
    IBOutlet BrassCheckBox                      *wedButton;
    IBOutlet UILabel                            *thuLabel;
    IBOutlet BrassCheckBox                      *thuButton;
    IBOutlet UILabel                            *friLabel;
    IBOutlet BrassCheckBox                      *friButton;
    IBOutlet UILabel                            *satLabel;
    IBOutlet BrassCheckBox                      *satButton;
    IBOutlet UIButton                           *doSearchButton;
    IBOutlet UIButton                           *findNearMeLabel;
    IBOutlet BrassCheckBox                      *findNearMeCheckbox;
    IBOutlet UIView                             *containerView;
    IBOutlet UITextField                        *addressEntryText;
    CGPoint                                     oldOrigin;
    SpecifyNewSearchViewController              *mySpecController;
}
- (id)initWithSearchSpecController:(SpecifyNewSearchViewController *)inController;
- (void)setMyController:(SpecifyNewSearchViewController *)inController;
- (void)setBeanieBackground;
- (void)setParamsForWeekdaySelection;

- (IBAction)weekdaySelectionChanged:(id)sender;
- (IBAction)doSearchButtonPressed:(id)sender;
- (IBAction)backgroundClicked:(id)sender;
- (IBAction)findMeLabelClicked:(id)sender;
- (IBAction)findNearMeChanged:(id)sender;
- (IBAction)backSwipe:(id)sender;
@end
