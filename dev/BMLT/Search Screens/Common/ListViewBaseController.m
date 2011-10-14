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
    [sortByDateAndTime release];
    [sortByDistance release];
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
    [sortByDistance setIsOn:NO];
    [sortByDateAndTime setIsOn:YES];
    [[BMLTAppDelegate getBMLTAppDelegate] sortMeetingsByWeekdayAndTime];
    [myTableView setDisplayedSearchResults:[[BMLTAppDelegate getBMLTAppDelegate] getSearchResults]];
    [myTableView reloadData];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)sortByDistance
{
    [sortByDistance setIsOn:YES];
    [sortByDateAndTime setIsOn:NO];
    [[BMLTAppDelegate getBMLTAppDelegate] sortMeetingsByDistance];
    [myTableView setDisplayedSearchResults:[[BMLTAppDelegate getBMLTAppDelegate] getSearchResults]];
    [myTableView reloadData];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)toggleSort
{
    if ( [sortByDistance isOn] )
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
    BOOL    ret = YES;
    NSArray *results = [[BMLTAppDelegate getBMLTAppDelegate] getSearchResults];
    
    for ( BMLT_Meeting *meeting in results )
        {
        if ( ![meeting getValueFromField:@"distance_in_km"] )
            {
            ret = NO;
            break;
            }
        }
    
    return [self isKindOfClass:[ListViewController class]] && ret;
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
    NSString    *ret = ([self displayDistanceSort] && (section == 0)) ? NSLocalizedString(@"SEARCH-RESULTS-SORT-HEADER", nil) : [NSString stringWithFormat:@"%@ %d %@", NSLocalizedString(@"SEARCH-RESULTS-PREFIX", nil), [[(BMLTTableView *)tableView getDisplayedSearchResults] count], NSLocalizedString(@"SEARCH-RESULTS-SUFFIX", nil)];

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
        
        int rowHeight = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? kSortOptionsRowHeight_iPad : kSortOptionsRowHeight;
        int buttonHeight = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? kSortButtonHeight_iPad : kSortButtonHeight;
        int buttonWidth = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? kSortButtonWidth_iPad : kSortButtonWidth;
        int padding = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? kSortButtonPadding_iPad : kSortButtonPadding;
        
        boundsRect.origin = CGPointZero;
        boundsRect.size.height = rowHeight;
        
        UIView      *wrapper1 = [[UIView alloc] initWithFrame:boundsRect];
        
        if ( wrapper1 )
            {
            [wrapper1 setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
            
            UIView      *wrapper = [[UIView alloc] initWithFrame:boundsRect];
            
            if ( wrapper )
                {
                [wrapper setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
                CGRect  button1Rect = boundsRect;
                CGRect  button2Rect = boundsRect;
                
                button1Rect.size.width /= 2;
                button2Rect.size.width /= 2;
                button2Rect.origin.x = button1Rect.origin.x + button1Rect.size.width;
                
                sortByDateAndTime = [[BrassCheckBox alloc] init];
                
                if ( sortByDateAndTime )
                    {
                    CGRect frame = [sortByDateAndTime bounds];
                    frame.size.height = buttonHeight;
                    frame.size.width = buttonWidth;
                    frame.origin.x = (button1Rect.origin.x + button1Rect.size.width) - (frame.size.width + padding);
                    frame.origin.y = (button1Rect.size.height - frame.size.height) / 2;
                    [sortByDateAndTime setFrame:frame];
                    [sortByDateAndTime setIsOn:![[BMLT_Prefs getBMLT_Prefs] preferDistanceSort]];
                    [sortByDateAndTime setUserInteractionEnabled:NO];
                    [wrapper addSubview:sortByDateAndTime];
                    }
                
                button1Rect.size.width -= (buttonWidth + (padding * 2));
                
                UILabel    *label = [[UILabel alloc] initWithFrame:button1Rect];
                
                if ( label )
                    {
                    [label setFont:[UIFont  boldSystemFontOfSize:14]];
                    [label setTextAlignment:UITextAlignmentRight];
                    [label setAdjustsFontSizeToFitWidth:YES];
                    [label setBackgroundColor:[UIColor clearColor]];
                    NSArray *sr = [(BMLTTableView *)tableView getDisplayedSearchResults];
                    
                    if ( [(BMLT_Meeting *)[sr objectAtIndex:0] getWeekdayOrdinal] == [(BMLT_Meeting *)[sr objectAtIndex:[sr count] - 1] getWeekdayOrdinal] )
                        {
                        [label setText:NSLocalizedString(@"SEARCH-RESULTS-SORT-TIME", nil)];
                        }
                    else
                        {
                        [label setText:NSLocalizedString(@"SEARCH-RESULTS-SORT-DAY", nil)];
                        }
                    [wrapper addSubview:label];
                    [label release];
                    }
                
                sortByDistance = [[BrassCheckBox alloc] init];
                if ( sortByDistance )
                    {
                    CGRect frame = [sortByDistance bounds];
                    frame.size.height = buttonHeight;
                    frame.size.width = buttonWidth;
                    frame.origin.x = button2Rect.origin.x + padding;
                    frame.origin.y = (button2Rect.size.height - frame.size.height) / 2;
                    [sortByDistance setFrame:frame];
                    [sortByDistance setIsOn:[[BMLT_Prefs getBMLT_Prefs] preferDistanceSort]];
                    [sortByDistance setUserInteractionEnabled:NO];
                    [wrapper addSubview:sortByDistance];
                    }
                
                button2Rect.size.width -= (buttonWidth + (padding * 2));
                button2Rect.origin.x += (buttonWidth + padding);
                
                label = [[UILabel alloc] initWithFrame:button2Rect];
                
                if ( label )
                    {
                    [label setFont:[UIFont  boldSystemFontOfSize:14]];
                    [label setAdjustsFontSizeToFitWidth:YES];
                    [label setBackgroundColor:[UIColor clearColor]];
                    [label setText:NSLocalizedString(@"SEARCH-RESULTS-SORT-DISTANCE", nil)];
                    [wrapper addSubview:label];
                    [label release];
                    }
                
                [wrapper1 addSubview:wrapper];
                [wrapper release];
                }
            
            [ret addSubview:wrapper1];
            [wrapper1 release];
            }
        
        if ( [[BMLT_Prefs getBMLT_Prefs] preferDistanceSort] )
            {
            [self sortByDistance];
            }
        }
    
    return ret;
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
        ret = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? kSortOptionsRowHeight_iPad : kSortOptionsRowHeight;
        }
    
    return ret;
}
@end
