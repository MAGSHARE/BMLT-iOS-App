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

#import "ListViewController.h"
#import "BMLT_Meeting_Search.h"
#import "MeetingDisplayCellView.h"
#import "BMLTAppDelegate.h"

@implementation ListViewController

/***************************************************************\**
 \brief 
 *****************************************************************/
- (id)init
{
    self = [super init];
    
    if ( self )
        {
        UISwipeGestureRecognizer    *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:[BMLTAppDelegate getBMLTAppDelegate] action:@selector(swipeFromList:)];
        [gestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
        [[self view] addGestureRecognizer:gestureRecognizer];
        [gestureRecognizer release];
        }
    
    return self;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [self setVisualElementsForSearch];
    [super viewWillAppear:animated];
    if ( [[BMLTAppDelegate getBMLTAppDelegate] listNeedsRefresh] )
        {
        if ( [self getSearchResults] )
            {
            [self displaySearchResults:[self getSearchResults]];
            }
        else
            {
            [self clearSearch];
            }
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)executeSearch
{
    [myTableView setDataSource:nil];
    [myTableView setDelegate:nil];
    [myTableView removeFromSuperview];
    myTableView = nil;
    [super executeSearch];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)displaySearchResults:(NSArray *)inResults
{
    [super displaySearchResults:inResults];
    [self stopAnimation];
    [[BMLTAppDelegate getBMLTAppDelegate] clearListNeedsRefresh];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)displaySearchError:(NSError *)inError
{
    [super displaySearchError:inError];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)newSearch
{
    [[BMLTAppDelegate getBMLTAppDelegate] engageNewSearch:NO];
}
@end
