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

#define kSortOptionsRowHeight        26

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
    BOOL            noDistance;
    BOOL            sortByDist;
    UILabel         *sortByTimeLabel;
    UILabel         *sortByDistanceLabel;
}
- (UITableViewCell *)setUpSortTableCell:(UITableView *)tableView;
- (void)setSortLabelStates;
- (void)displayListOfMeetings:(NSArray *)inResults;
- (void)sortByDayAndTime;
- (void)sortByDistance;
- (void)toggleSort;
- (BOOL)displayDistanceSort;
@end
