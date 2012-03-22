//
//  BMLTDisplayListResultsViewController.m
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

#import "BMLTDisplayListResultsViewController.h"
#import "BMLTMeetingDisplayCellView.h"

#define kSortOptionsRowHeight        32

/**************************************************************//**
 \class  BMLTDisplayListResultsViewController
 \brief  This class handles display of listed search results.
 *****************************************************************/
@implementation BMLTDisplayListResultsViewController

@synthesize dataArray = _dataArray;

/**************************************************************//**
 \brief G'night...
 *****************************************************************/
- (void)dealloc
{
    [_dataArray removeAllObjects];
    _dataArray = nil;
}

/**************************************************************//**
 \brief Called after the view has loaded.
 *****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    [(UITableView *)[self view] reloadData];
}

/**************************************************************//**
 \brief Overload the implicit call, because we trigger a redraw, and
        we want to be able to use a regular array, not a mutable one.
 *****************************************************************/
- (void)setDataArrayFromData:(NSArray *)dataArray   ///< The array of data to be used for this view.
{
    if ( !_dataArray )
        {
        _dataArray = [[NSMutableArray alloc] init];
        }
    
    [_dataArray removeAllObjects];
    [_dataArray setArray:dataArray];
    [(UITableView *)[self view] reloadData];
}

#pragma mark - UITableViewDataSource Delegate Required Methods -
/**************************************************************//**
 \brief Called to provide a single cell contents.
 \returns a table cell view, with all the data and primed for action.
 *****************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView ///< The table view in question.
         cellForRowAtIndexPath:(NSIndexPath *)indexPath ///< The index path for the cell.
{
    UITableViewCell *ret = nil;
    BMLT_Meeting    *theMeeting = (BMLT_Meeting *)[_dataArray objectAtIndex:[indexPath row]];
    
    if ( theMeeting )
        {
        NSString    *reuseID = [NSString stringWithFormat: @"BMLT_Search_Results_Row_%d", [theMeeting getMeetingID]];
#ifdef DEBUG
        NSLog(@"Creating A Row For Meeting ID %d, named \"%@\"", [theMeeting getMeetingID], [theMeeting getBMLTName]);
#endif
        ret = [[BMLTMeetingDisplayCellView alloc] initWithMeeting:theMeeting andFrame:[tableView bounds] andReuseID:reuseID andIndex:[indexPath row]];
        [(BMLTMeetingDisplayCellView *)ret setMyModalController:self];
        }
    
    return ret;
}

/**************************************************************//**
 \brief Called to indicate the number of active rows in the display.
 \returns an integer. The number of active rows.
 *****************************************************************/
- (NSInteger)tableView:(UITableView *)tableView ///< The table view in question.
 numberOfRowsInSection:(NSInteger)section       ///< The section index.
{
    return [[self dataArray] count];
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat ret = List_Meeting_Display_CellHeight;
    
    return ret;
}

@end
