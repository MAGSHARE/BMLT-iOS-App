//
//  SpecifyNewSearchViewController.m
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

#import "SpecifyNewSearchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BMLTAppDelegate.h"

@implementation SpecifyNewSearchViewController

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (id)initWithSearchController:(A_SearchController *)inController
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
        {
        firstCall = YES;
        [inController retain];
        mySearchController = inController;
        
        UISwipeGestureRecognizer    *gestureRecognizer = nil;
        
        if ( [[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad )
            {    
            gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(advancedSwipe:)];
            [gestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
            [[self view] addGestureRecognizer:gestureRecognizer];
            [gestureRecognizer release];
            }
        
        gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backSwipe:)];
        [gestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
        [[self view] addGestureRecognizer:gestureRecognizer];
        [gestureRecognizer release];
        }
    return self;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)dealloc
{
    [quickSearchLabel release];
    [findMeetingsNearbyButton release];
    [findMeetingsNearbyLaterTodayButton release];
    [findMeetingsNearbyTomorrowButton release];
    [mySearchController release];
    [advancedOptions release];
    [advancedOptionsController release];
    [advancedOptionsLabel release];
    [shadowView release];
    [mySearchParams release];
    [disabledLabel release];
    [super dealloc];
}

#pragma mark - View lifecycle

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [quickSearchLabel setText:NSLocalizedString(@"SEARCH-SPEC-SECTION-1", nil)];

    [findMeetingsNearbyButton setTitle:NSLocalizedString(@"SEARCH-SPEC-NEARBY-TITLE", nil) forState:UIControlStateNormal];
    [findMeetingsNearbyLaterTodayButton setTitle:NSLocalizedString(@"SEARCH-SPEC-LATER-TODAY-TITLE", nil) forState:UIControlStateNormal];
    [findMeetingsNearbyTomorrowButton setTitle:NSLocalizedString(@"SEARCH-SPEC-TOMORROW-TITLE", nil) forState:UIControlStateNormal];
    
    [self setBlueBackground];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)viewDidLoad
{
    if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad )
        {    
        [advancedOptionsLabel setText:NSLocalizedString(@"SEARCH-SPEC-ADVANCED-OPTIONS", nil)];
        [advancedOptionsController release];
        advancedOptionsController = [[AdvancedSearchViewController alloc] initWithSearchSpecController:self];
        [[advancedOptionsController view] setFrame:[advancedOptions bounds]];
        [advancedOptions addSubview:[advancedOptionsController view]];
        }
    else
        {
        [shadowView setAlpha:0];
        [quickSearchLabel setAlpha:0];
        [advancedOptionsLabel setAlpha:0];
        [advancedOptions setAlpha:0];
        UIBarButtonItem     *advanced_search_button= [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"SEARCH-SPEC-ADVANCED-SHORT", nil)
                                                                                      style:UIBarButtonItemStylePlain
                                                                                     target:self
                                                                                     action:@selector(goToAdvanced)];
        
        if ( advanced_search_button )
            {
            [[self navigationItem] setRightBarButtonItem:advanced_search_button animated:YES];
            [advanced_search_button release];
            }
        }
    
    [super viewDidLoad];
    
    if ( ![[BMLTAppDelegate getBMLTAppDelegate] isLookupValid] )
        {
        [findMeetingsNearbyButton setEnabled:NO];
        [findMeetingsNearbyButton setAlpha:0];
        [findMeetingsNearbyLaterTodayButton setEnabled:NO];
        [findMeetingsNearbyLaterTodayButton setAlpha:0];
        [findMeetingsNearbyTomorrowButton setEnabled:NO];
        [findMeetingsNearbyTomorrowButton setAlpha:0];
        [disabledLabel setAlpha:1.0];
        [disabledLabel setText:NSLocalizedString(@"SEARCH-SPEC-DISABLED-TEXT", nil)];
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)viewDidUnload
{
    [quickSearchLabel release];
    quickSearchLabel = nil;
    [findMeetingsNearbyButton release];
    findMeetingsNearbyButton = nil;
    [findMeetingsNearbyLaterTodayButton release];
    findMeetingsNearbyLaterTodayButton = nil;
    [findMeetingsNearbyTomorrowButton release];
    findMeetingsNearbyTomorrowButton = nil;
    [advancedOptions release];
    advancedOptions = nil;
    [advancedOptionsController release];
    advancedOptionsController = nil;
    [advancedOptionsLabel release];
    advancedOptionsLabel = nil;
    [shadowView release];
    shadowView = nil;
    [mySearchParams release];
    mySearchParams = nil;
    [disabledLabel release];
    disabledLabel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    BOOL    ret = ((io == UIInterfaceOrientationPortrait) || (io == UIInterfaceOrientationLandscapeLeft) || (io == UIInterfaceOrientationLandscapeRight));
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
        ret = YES;
        }
    return ret;
}

#pragma mark - Quick Search Responses

/***************************************************************\**
 \brief 
 *****************************************************************/
- (IBAction)findMeetingsNearby:(id)sender
{
    [self setMySearchParams:nil];
    [self searchForMeetingsAroundHere];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (IBAction)findMeetingsNearbyLaterToday:(id)sender
{
    [self setMySearchParams:nil];
    [self findMeetingsLaterToday:YES];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)findMeetingsLaterToday:(BOOL)inLocal
{
        // We have a "grace period," so that you can be a bit late for meetings.
    NSMutableDictionary *myParams = [[NSMutableDictionary alloc] init];
    
    NSDate              *date = [BMLTAppDelegate getLocalDateAutoreleaseWithGracePeriod:YES];
    NSCalendar          *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents    *weekdayComponents = [gregorian components:(NSWeekdayCalendarUnit) fromDate:date];
    NSInteger           wd = [weekdayComponents weekday];
    weekdayComponents = [gregorian components:(NSHourCalendarUnit) fromDate:date];
    NSInteger           hr = [weekdayComponents hour];
    weekdayComponents = [gregorian components:(NSMinuteCalendarUnit) fromDate:date];
    NSInteger           mn = [weekdayComponents minute];
    [gregorian release];
    
    [myParams setObject:[NSString stringWithFormat:@"%d",wd] forKey:@"weekdays"];
    [myParams setObject:[NSString stringWithFormat:@"%d",hr] forKey:@"StartsAfterH"];
    [myParams setObject:[NSString stringWithFormat:@"%d",mn] forKey:@"StartsAfterM"];
    [myParams setObject:@"time" forKey:@"sort_key"]; // Sort by time for this search.
    
    [self setMySearchParams:myParams];
    [myParams release];

    if ( inLocal )
        {
        [self searchForMeetingsAroundHere];
        }
    else
        {
        [self searchForMeetings];
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (IBAction)findMeetingsNearbyTomorrow:(id)sender
{
    [self setMySearchParams:nil];
    [self findMeetingsNearbyTomorrow_exec];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)findMeetingsNearbyTomorrow_exec
{
    NSCalendar          *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents    *weekdayComponents = [gregorian components:(NSWeekdayCalendarUnit) fromDate:[BMLTAppDelegate getLocalDateAutoreleaseWithGracePeriod:NO]];
    NSInteger           wd = [weekdayComponents weekday] + 1;
    [gregorian release];
    
    if ( wd > 7 )
        {
        wd = 1;
        }
    
    NSMutableDictionary *myParams = [[NSMutableDictionary alloc] init];
    
    [myParams setObject:[NSString stringWithFormat:@"%d",wd] forKey:@"weekdays"];
    [myParams setObject:@"time" forKey:@"sort_key"]; // Sort by time for this search.
    
    [self setMySearchParams:myParams];
    [myParams release];
    [self searchForMeetingsAroundHere];
    
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)searchForMeetingsAroundHere
{
    NSMutableDictionary *myParams = [[NSMutableDictionary alloc] init];
    [myParams setObject:@"-10" forKey:@"geo_width"];
    [myParams setObject:@"time" forKey:@"sort_key"]; // Sort by time for this search.
    [self setMySearchParams:myParams];
    [myParams release];
    [mySearchController clearSearchResults];
    [mySearchController setMySearchQueueFindLocationFirst:YES];
    [mySearchController setMySearchQueueStartSearch:NO];
    [mySearchController setMySearchQueueParams:mySearchParams];
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)searchForMeetings
{
    [mySearchController clearSearchResults];
    [mySearchController setMySearchQueueFindLocationFirst:NO];
    [mySearchController setMySearchQueueStartSearch:YES];
    [mySearchController setMySearchQueueParams:mySearchParams];
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

#pragma mark - Custom Funtions

/***************************************************************\**
 \brief This applies the "Beanie Background" to the results view.
 *****************************************************************/
- (void)setBlueBackground
{
    [[[self view] layer] setContentsGravity:kCAGravityResizeAspectFill];
    [[[self view] layer] setBackgroundColor:[[UIColor colorWithWhite:0 alpha:0] CGColor]];
    [[[self view] layer] setContents:(id)[[UIImage imageNamed:@"BlueBeanie.png"] CGImage]];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setMySearchParams:(NSDictionary *)inParams
{
    if ( inParams )
        {
        if ( !mySearchParams )
            {
            mySearchParams = [[NSMutableDictionary alloc] initWithDictionary:inParams];
            }
        else
            {
            [mySearchParams addEntriesFromDictionary:inParams];
            }
        }
    else
        {
        [mySearchParams release];
        mySearchParams = nil;
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (IBAction)advancedSwipe:(id)sender
{
    [self goToAdvanced];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (IBAction)backSwipe:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)goToAdvanced
{
    [advancedOptionsController release];
    advancedOptionsController = [[AdvancedSearchViewController alloc] initWithSearchSpecController:self];
    [[advancedOptionsController navigationItem] setTitle:NSLocalizedString(@"SEARCH-SPEC-ADVANCED-OPTIONS", nil)];
    [[self navigationController] pushViewController:advancedOptionsController animated:YES];
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (A_SearchController *)mySearchController
{
    return mySearchController;
}

@end

