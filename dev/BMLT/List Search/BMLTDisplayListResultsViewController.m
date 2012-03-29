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
#import "BMLTAppDelegate.h"
#import "BMLT_Prefs.h"
#import "BMLT_Meeting.h"

/**************************************************************//**
 \class  BMLTMeetingDisplaySortCellView
 \brief  This class handles display of the sort by header.
 *****************************************************************/
@implementation BMLTMeetingDisplaySortCellView

/**************************************************************//**
 \brief sets up the control with its various initial states.
 *****************************************************************/
- (void)setTheSortControl:(UISegmentedControl *)inControl   ///< The control to use as the sort header.
{
    [inControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    [inControl setFrame:[self bounds]];
    [inControl setSelectedSegmentIndex:[BMLT_Prefs getPreferDistanceSort] ? 0 : 1];
    [inControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self addSubview:inControl];
}

@end

/**************************************************************//**
 \class  BMLTDisplayListResultsViewController
 \brief  This class handles display of listed search results.
 *****************************************************************/
@implementation BMLTDisplayListResultsViewController

@synthesize includeSortRow;

/**************************************************************//**
 \brief Called after the view has loaded.
 *****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    [(UITableView *)[self view] reloadData];
}

/**************************************************************//**
 \brief Specialize the implicit call, because we trigger a redraw, and
 we want to be able to use a regular array, not a mutable one.
 *****************************************************************/
- (void)setDataArrayFromData:(NSArray *)dataArray   ///< The array of data to be used for this view.
{
    [super setDataArrayFromData:dataArray];
    [(UITableView *)[self view] reloadData];
}

#pragma mark - IBAction Functions -

/**************************************************************//**
 \brief Sorts the meeting search results.
 *****************************************************************/
- (IBAction)sortMeetings:(id)sender        ///< The Segmented Control
{
    if ( [(UISegmentedControl *)sender selectedSegmentIndex] )
        {
#ifdef DEBUG
        NSLog(@"BMLTDisplayListResultsViewController::sortMeetings Sorting Meetings By Weekday and Time.");
#endif
        [[BMLTAppDelegate getBMLTAppDelegate] sortMeetingsByWeekdayAndTime];
        }
    else
        {
#ifdef DEBUG
        NSLog(@"BMLTDisplayListResultsViewController::sortMeetings Sorting Meetings By Distance.");
#endif
        [[BMLTAppDelegate getBMLTAppDelegate] sortMeetingsByDistance];
        }
    
    [self setDataArrayFromData:[[BMLTAppDelegate getBMLTAppDelegate] searchResults]];
    [(UITableView *)[self view] reloadData];
}

#pragma mark - Table Data Source Functions -

/**************************************************************//**
 \brief We have two sections in this table. This returns 2.
 \returns 2
 *****************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ([[self dataArray] count] > 1) ? 2 : 1;
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
    
    // If we are populating the header, then we simply generate a new 
    if ( ([self numberOfSectionsInTableView:tableView] > 1) && ([indexPath section] == 0) )
        {
        ret = [tableView dequeueReusableCellWithIdentifier:@"LIST-SORT-HEADER"];
        if ( !ret )
            {
            BMLTMeetingDisplaySortCellView  *ret_cast = [[BMLTMeetingDisplaySortCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LIST-SORT-HEADER"];
            CGRect  bounds = [tableView bounds];
            bounds.size.height = kSortHeaderHeight;
            [ret_cast setFrame:bounds];
            [ret_cast setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            NSArray *sortChoices = [NSArray arrayWithObjects:NSLocalizedString(@"SEARCH-RESULTS-SORT-DISTANCE", nil), NSLocalizedString(@"SEARCH-RESULTS-SORT-TIME", nil), nil];
            if ( includeSortRow )
                {
#ifdef DEBUG
                NSLog(@"Sort Control");
#endif
                UISegmentedControl *theSortControl = [[UISegmentedControl alloc] initWithItems:sortChoices];
                [theSortControl addTarget:self action:@selector(sortMeetings:) forControlEvents:UIControlEventValueChanged];
                [ret_cast setTheSortControl:theSortControl];
                }
            else
                {
#ifdef DEBUG
                NSLog(@"Only A Header");
#endif
                UILabel *label = [[UILabel alloc] initWithFrame:bounds];
                [label setText:NSLocalizedString(@"MAP-LIST-HEADER", nil)];
                [label setTextAlignment:UITextAlignmentCenter];
                [ret_cast addSubview:label];
                }
            
            ret = ret_cast;
#ifdef DEBUG
            NSLog(@"Creating A Row For the sort header.");
#endif
            }
#ifdef DEBUG
        else
            {
            NSLog(@"Reusing the sort header row,");
            }
#endif
        }
    else
        {
        BMLT_Meeting    *theMeeting = (BMLT_Meeting *)[[self dataArray] objectAtIndex:[indexPath row]];
        
        if ( theMeeting )
            {
            // We deliberately don't reuse, because we need to update the "striping" of meeting cells when we re-sort.
            NSString    *reuseID = [NSString stringWithFormat: @"BMLT_Search_Results_Row_%d", [theMeeting getMeetingID]];
            if ( !ret )
                {
#ifdef DEBUG
                NSLog(@"Creating A Row For Meeting ID %d, named \"%@\"", [theMeeting getMeetingID], [theMeeting getBMLTName]);
#endif
                BMLTMeetingDisplayCellView *ret_cast = [[BMLTMeetingDisplayCellView alloc] initWithMeeting:theMeeting andFrame:[tableView bounds] andReuseID:reuseID andIndex:[indexPath row]];
                [ret_cast setMyModalController:self];
                
                ret = ret_cast;
                }
#ifdef DEBUG
            else
                {
                NSLog(@"Reusing A Row For Meeting ID %d, named \"%@\"", [theMeeting getMeetingID], [theMeeting getBMLTName]);
                }
#endif
            }
#ifdef DEBUG
        else
            {
            NSLog(@"ERROR: Cannot get a reliable meeting object for index %d!", [indexPath row]);
            }
#endif
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
    return ((section == 0) && ([[self dataArray] count] > 1)) ? 1 : [[self dataArray] count];
}

/**************************************************************//**
 \brief Get the proper height for the table cell.
 \returns a floating-point number that specifies how many pixels high to make the table row.
 *****************************************************************/
- (CGFloat)tableView:(UITableView *)tableView       ///< The table view
heightForRowAtIndexPath:(NSIndexPath *)indexPath    ///< The index.
{
    return (([self numberOfSectionsInTableView:tableView] > 1) && ([indexPath section] == 0)) ? kSortHeaderHeight : ([[self dataArray] count] > [indexPath row]) ? List_Meeting_Display_CellHeight : 0;
}

/**************************************************************//**
 \brief Called when the user selects a table row.
 *****************************************************************/
- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [indexPath section] > 0 )
        {
        [BMLTAppDelegate viewMeetingDetails:(BMLT_Meeting *)[[self dataArray] objectAtIndex:[indexPath row]] withController:self];
        }
    
    return nil;
}
@end
