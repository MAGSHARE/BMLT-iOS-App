//
//  SecondViewController.h
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
#import "A_SearchController.h"
#import "FormatDetailView.h"
#import "BrassCheckBox.h"

#define kSortOptionsRowHeight        40
#define kSortButtonHeight            32
#define kSortButtonWidth             32
#define kSortButtonPadding            2

#define kSortOptionsRowHeight_iPad   52
#define kSortButtonHeight_iPad       48
#define kSortButtonWidth_iPad        48
#define kSortButtonPadding_iPad       4

@interface BMLTTableView : UITableView
{
    NSArray *displayedSearchResults;
}

- (void)setDisplayedSearchResults:(NSArray *)inSearchResults;
- (NSArray *)getDisplayedSearchResults;

@end

@interface ListViewBaseController : A_SearchController <UITableViewDelegate, UITableViewDataSource>
{
    BMLTTableView   *myTableView;
    BrassCheckBox   *sortByDateAndTime;
    BrassCheckBox   *sortByDistance;
    BOOL            noDistance;
}
- (UITableViewCell *)setUpSortTableCell:(UITableView *)tableView;
- (void)displayListOfMeetings:(NSArray *)inResults;
- (void)sortByDayAndTime;
- (void)sortByDistance;
- (void)toggleSort;
- (BOOL)displayDistanceSort;
@end
