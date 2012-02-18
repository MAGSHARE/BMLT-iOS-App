//
//  SecondViewController.m
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

#import "ListViewBaseController.h"
#import "BMLT_Meeting_Search.h"
#import "MeetingDisplayCellView.h"
#import "BMLTAppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@implementation BMLTTableView

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)dealloc
{
    [displayedSearchResults release];
    [super dealloc];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setDisplayedSearchResults:(NSArray *)inSearchResults
{
    [inSearchResults retain];
    [displayedSearchResults release];
    displayedSearchResults = inSearchResults;
}

/***************************************************************\**
 \brief 
 \return 
 *****************************************************************/
- (NSArray *)getDisplayedSearchResults
{
    return displayedSearchResults;
}

@end

@implementation ListViewBaseController

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)dealloc
{
    [myTableView release];
    [sortByTimeLabel release];
    [sortByDistanceLabel release];
    [super dealloc];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [myTableView reloadData];
    [super viewWillAppear:animated];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)viewDidLayoutSubviews
{
    [self setSortLabelStates];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)displaySearchResults:(NSArray *)inResults
{
#ifdef DEBUG
    NSLog(@"ListViewController displaySearchResults -Displaying Search Results of %d Meetings", [inResults count]);
#endif
    [self displayListOfMeetings:inResults];
    [super displaySearchResults:inResults];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)executeSearch
{
    sortByDist = [[BMLT_Prefs getBMLT_Prefs] preferDistanceSort];
    [super executeSearch];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)displayListOfMeetings:(NSArray *)inResults
{
    [myTableView setDataSource:nil];
    [myTableView setDelegate:nil];
    [myTableView removeFromSuperview];
    myTableView = nil;
    
    if ( [inResults count] )
        {
#ifdef DEBUG
        NSLog(@"ListViewController displayListOfMeetings -Creating a new list of %d Meetings", [inResults count]);
#endif
        CGRect  myBounds = [[self view] bounds];
            
        myTableView = [[BMLTTableView alloc] initWithFrame:myBounds style:UITableViewStylePlain];
        
        if ( myTableView )
            {
            [myTableView setDisplayedSearchResults:inResults];
            [myTableView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
            [myTableView setAutoresizesSubviews:YES];
            [myTableView setDataSource:self];
            [myTableView setDelegate:self];
            [myTableView setRowHeight:List_Meeting_Display_CellHeight];
            [[self view] addSubview:myTableView];
            [myTableView release];
            }
        }
}

/***************************************************************\**
 \brief Clears the previous search results.
 *****************************************************************/
- (void)clearSearchResults
{
    [myTableView setDataSource:nil];
    [myTableView setDelegate:nil];
    [myTableView removeFromSuperview];
    myTableView = nil;
    [super clearSearchResults];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)sortByDayAndTime
{
    [[BMLTAppDelegate getBMLTAppDelegate] sortMeetingsByWeekdayAndTime];
    [myTableView setDisplayedSearchResults:[[BMLTAppDelegate getBMLTAppDelegate] getSearchResults]];
    [myTableView reloadData];
    sortByDist = NO;
    [self setSortLabelStates];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)sortByDistance
{
    [[BMLTAppDelegate getBMLTAppDelegate] sortMeetingsByDistance];
    [myTableView setDisplayedSearchResults:[[BMLTAppDelegate getBMLTAppDelegate] getSearchResults]];
    [myTableView reloadData];
    sortByDist = YES;
    [self setSortLabelStates];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)toggleSort
{
    if ( sortByDist )
        {
        [self sortByDayAndTime];
        }
    else
        {
        [self sortByDistance];
        }
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (BOOL)displayDistanceSort
{
    BOOL    ret = NO;
    NSArray *results = [[BMLTAppDelegate getBMLTAppDelegate] getSearchResults];
    
    if ( [results count] > 1 )
        {
        ret = YES;
        
        for ( BMLT_Meeting *meeting in results )
            {
            if ( ![meeting getValueFromField:@"distance_in_km"] )
                {
                ret = NO;
                break;
                }
            }
        
        ret = [self isKindOfClass:[ListViewController class]] && ret;
        }
    
    return ret;
}

#pragma mark - Table Data Source Functions -

/***************************************************************\**
 \brief We have two sections in this table. This returns 2.
 \returns 2
 *****************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self displayDistanceSort] ? 2 : 1;
}

/***************************************************************\**
 \brief Returns the appropriate title for each section header.
 \returns a string, with the appropriate title.
 *****************************************************************/
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    NSString    *ret = ([self displayDistanceSort] && (section == 0)) ? nil : [NSString stringWithFormat:@"%@ %d %@", NSLocalizedString(@"SEARCH-RESULTS-PREFIX", nil), [[(BMLTTableView *)tableView getDisplayedSearchResults] count], NSLocalizedString(@"SEARCH-RESULTS-SUFFIX", nil)];

    return ret;
}

#pragma mark - Table Delegate Functions -

/***************************************************************\**
 \brief This is how many rows are in the given section.
 \returns an integer, with the number of rows.
 *****************************************************************/
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSInteger   ret = ([self displayDistanceSort] && section == 0) ? 1 : [[(BMLTTableView *)tableView getDisplayedSearchResults] count];
    return ret;
}

/***************************************************************\**
 \brief Allocates and returns an initialized cell view for a table
 section and index.
 \returns an autoreleased cell view object.
 *****************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *ret = nil;
    
    if ( [self displayDistanceSort] && [indexPath section] == 0 )
        {
        ret = [tableView dequeueReusableCellWithIdentifier:@"SortOptions"];
        if ( !ret )
            {
            ret = [self setUpSortTableCell:tableView];
            }
        }
    else
        {
        int             meeting_index = [indexPath row];
        NSArray         *meetings = [(BMLTTableView *)tableView getDisplayedSearchResults];
        BMLT_Meeting    *theMeeting = (BMLT_Meeting *)[meetings objectAtIndex:meeting_index];
        
        if ( theMeeting )
            {
            NSString    *reuseID = [NSString stringWithFormat: @"BMLT_Search_Results_Row_%d", [theMeeting getMeetingID]];
    #ifdef DEBUG
            NSLog(@"Creating A Row For Meeting ID %d, named \"%@\"", [theMeeting getMeetingID], [theMeeting getBMLTName]);
    #endif
            ret = [[[MeetingDisplayCellView alloc] initWithMeeting:theMeeting andFrame:[tableView bounds] andReuseID:reuseID andIndex:[indexPath row]] autorelease];
            [(MeetingDisplayCellView *)ret setMyModalController:self];
            }
        }
    return ret;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (UITableViewCell *)setUpSortTableCell:(UITableView *)tableView
{
    UITableViewCell *ret = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SortOptions"] autorelease];
    
    if ( ret )
        {
        CGRect  boundsRect = [tableView bounds];
        
        boundsRect.origin = CGPointZero;
        boundsRect.size.height = kSortOptionsRowHeight;
        boundsRect.size.width /= 2.0;
        
        UIView      *wrapper1 = [[UIView alloc] initWithFrame:boundsRect];
        
        if ( wrapper1 )
            {
            [wrapper1 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            sortByTimeLabel = [[UILabel alloc] initWithFrame:boundsRect];
            
            if ( sortByTimeLabel )
                {
                [sortByTimeLabel setFont:[UIFont  boldSystemFontOfSize:14]];
                [sortByTimeLabel setTextAlignment:UITextAlignmentCenter];
                [sortByTimeLabel setAdjustsFontSizeToFitWidth:YES];
                NSArray *sr = [(BMLTTableView *)tableView getDisplayedSearchResults];
                
                if ( [(BMLT_Meeting *)[sr objectAtIndex:0] getWeekdayOrdinal] == [(BMLT_Meeting *)[sr objectAtIndex:[sr count] - 1] getWeekdayOrdinal] )
                    {
                    [sortByTimeLabel setText:NSLocalizedString(@"SEARCH-RESULTS-SORT-TIME", nil)];
                    }
                else
                    {
                    [sortByTimeLabel setText:NSLocalizedString(@"SEARCH-RESULTS-SORT-DAY", nil)];
                    }
                [wrapper1 addSubview:sortByTimeLabel];
                
                boundsRect.origin.x = boundsRect.size.width;
                sortByDistanceLabel = [[UILabel alloc] initWithFrame:boundsRect];
                if ( sortByDistanceLabel )
                    {
                    [sortByDistanceLabel setFont:[UIFont  boldSystemFontOfSize:14]];
                    [sortByDistanceLabel setTextAlignment:UITextAlignmentCenter];
                    [sortByDistanceLabel setAdjustsFontSizeToFitWidth:YES];
                    [sortByDistanceLabel setText:NSLocalizedString(@"SEARCH-RESULTS-SORT-DISTANCE", nil)];

                    [wrapper1 addSubview:sortByDistanceLabel];
                    }
                }
            
            [ret addSubview:wrapper1];
            [wrapper1 release];
            }
        
        if ( [[BMLT_Prefs getBMLT_Prefs] preferDistanceSort] )
            {
            [self sortByDistance];
            }
        
        [self setSortLabelStates];
        }
    
    return ret;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setSortLabelStates
{
    CGRect  boundsRect = [myTableView bounds];
    
    boundsRect.origin = CGPointZero;
    boundsRect.size.height = kSortOptionsRowHeight;
    boundsRect.size.width /= 2.0;
    
    [sortByTimeLabel setFrame:boundsRect];
    
    boundsRect.origin.x = boundsRect.size.width;
    [sortByDistanceLabel setFrame:boundsRect];
    
    UIColor *selectedColor = [UIColor colorWithRed:0 green:.5 blue:1 alpha:1];
    [sortByDistanceLabel setBackgroundColor:(sortByDist ? selectedColor : [UIColor clearColor])];
    [sortByDistanceLabel setTextColor:(sortByDist ? [UIColor whiteColor] : selectedColor)];
    [sortByTimeLabel setBackgroundColor:(sortByDist ? [UIColor clearColor] : selectedColor)];
    [sortByTimeLabel setTextColor:(sortByDist ? selectedColor : [UIColor whiteColor])];
}

/***************************************************************\**
 \brief Determines the appropriate action to take when a row is selected.
 \returns the indexPath if the row is to be displayed as selected.
 *****************************************************************/
- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *ret = nil;
    
    if ( [self displayDistanceSort] && [indexPath section] == 0 )
        {
        [self toggleSort];
        }
    else
        {
        MeetingDisplayCellView  *theCell = (MeetingDisplayCellView *)[tableView cellForRowAtIndexPath:indexPath];
        
        if ( theCell )
            {
            [self viewMeetingDetails:[theCell getMyMeeting]];
            ret = indexPath;
            }
        }
    
    return ret;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat ret = List_Meeting_Display_CellHeight;
    if ( [self displayDistanceSort] && [indexPath section] == 0 )
        {
        ret = kSortOptionsRowHeight;
        }
    
    return ret;
}
@end
