//
//  BMLTDisplayListResultsViewController.h
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
#import "A_BMLTSearchResultsViewController.h"

#define kSortHeaderHeight           30  ///< The height of the "Sort By" header for lists of more than one result.

/**************************************************************//**
 \class  BMLTMeetingDisplaySortCellView
 \brief  This class handles display of the sort by header.
 *****************************************************************/
@interface BMLTMeetingDisplaySortCellView : UITableViewCell
- (void)setTheSortControl:(UISegmentedControl *)inControl;
@end

/**************************************************************//**
 \class  BMLTDisplayListResultsViewController
 \brief  This class handles display of listed search results.
 *****************************************************************/
@interface BMLTDisplayListResultsViewController : A_BMLTSearchResultsViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) BOOL includeSortRow;

- (IBAction)sortMeetings:(id)sender;                        ///< Sorts the meeting search results.
@end
