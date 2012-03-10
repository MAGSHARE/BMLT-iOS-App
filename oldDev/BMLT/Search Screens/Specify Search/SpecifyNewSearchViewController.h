//
//  SpecifyNewSearchViewController.h
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
#import <CoreLocation/CoreLocation.h>
#import "A_SearchController.h"
#import "BrassCheckBox.h"
#import "AdvancedSearchViewController.h"

@interface SpecifyNewSearchViewController : UIViewController
{
    IBOutlet UILabel                        *quickSearchLabel;
    IBOutlet UIButton                       *findMeetingsNearbyButton;
    IBOutlet UIButton                       *findMeetingsNearbyLaterTodayButton;
    IBOutlet UIButton                       *findMeetingsNearbyTomorrowButton;
    IBOutlet UIView                         *advancedOptions;
    IBOutlet UILabel                        *advancedOptionsLabel;
    IBOutlet UIImageView                    *shadowView;
    IBOutlet UILabel                        *disabledLabel;
    
    AdvancedSearchViewController            *advancedOptionsController;
    A_SearchController                      *mySearchController;
    NSMutableDictionary                     *mySearchParams;
    BOOL                                    firstCall;
}
- (id)initWithSearchController:(A_SearchController *)inController;
- (IBAction)findMeetingsNearby:(id)sender;
- (IBAction)findMeetingsNearbyLaterToday:(id)sender;
- (IBAction)advancedSwipe:(id)sender;
- (IBAction)backSwipe:(id)sender;
- (void)findMeetingsLaterToday:(BOOL)inLocal;
- (IBAction)findMeetingsNearbyTomorrow:(id)sender;
- (void)findMeetingsNearbyTomorrow_exec;
- (void)searchForMeetingsAroundHere;
- (void)searchForMeetings;
- (void)setBlueBackground;
- (void)setMySearchParams:(NSDictionary *)inParams;
- (void)goToAdvanced;
- (A_SearchController *)mySearchController;
@end

