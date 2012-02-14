//
//  BMLTAppDelegate.m
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

#import "BMLTAppDelegate.h"
#import "BMLT_Driver.h"
#import "BMLT_Server.h"
#import "BMLT_Meeting_Search.h"
#import "BMLT_Meeting.h"

#pragma mark - Overload of the UITabBar to allow rotation -
@implementation UITabBarController (MyOverload)

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    BOOL    ret = ((io == UIInterfaceOrientationPortrait) || (io == UIInterfaceOrientationLandscapeLeft) || (io == UIInterfaceOrientationLandscapeRight));
    
    if ( 2 == [[[BMLTAppDelegate getBMLTAppDelegate] tabBarController] selectedIndex] )
        {
        ret = io == UIInterfaceOrientationPortrait;
        }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
        ret = YES;
        }

    return ret;
}
@end

#pragma mark - Overload of the UINavBar to allow rotation -
@implementation UINavigationController (MyOverload)

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    BOOL    ret = ((io == UIInterfaceOrientationPortrait) || (io == UIInterfaceOrientationLandscapeLeft) || (io == UIInterfaceOrientationLandscapeRight));
    
    if ( 2 == [[[BMLTAppDelegate getBMLTAppDelegate] tabBarController] selectedIndex] )
        {
        ret = io == UIInterfaceOrientationPortrait;
        }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
        ret = YES;
        }
    
    return ret;
}
@end

#pragma mark - SINGLETON Static Member -
static  BMLTAppDelegate *bmlt_app_delegate = nil;

#pragma mark - Main App Delegate -
@implementation BMLTAppDelegate

@synthesize window = _window;

/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
+ (BMLTAppDelegate *)getBMLTAppDelegate
{
    return bmlt_app_delegate;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
+ (void)lookupLocationFromAddressString:(NSString *)inLocationString
{
    [bmlt_app_delegate clearLastLookup];

    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    
    inLocationString = [inLocationString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    inLocationString = [inLocationString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSData *xml = [NSData 
                   dataWithContentsOfURL: [NSURL 
                                           URLWithString:[NSString stringWithFormat:kGoogleReverseLooupURI_Format, inLocationString]]];
    BMLT_Parser *myParser = [[BMLT_Parser alloc] initWithData:xml];
    
    [myParser setDelegate:bmlt_app_delegate];
    
    [myParser parseAsync:NO
             WithTimeout:kAddressLookupTimeoutPeriod_in_seconds];
    [myParser release];
}

/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
+ (CLLocationCoordinate2D)getLastLookup
{
    return [bmlt_app_delegate getWhereImAt].coordinate;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
+ (void)imVisitingMAGSHARE
{
    [bmlt_app_delegate setVisitingMAGSHARE];
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
+ (NSDate *)getLocalDateAutoreleaseWithGracePeriod:(BOOL)useGracePeriod
{
    NSTimeInterval  interval = useGracePeriod ? [[BMLT_Prefs getBMLT_Prefs] gracePeriod] * 60 : 0;
    
    return [NSDate dateWithTimeIntervalSinceNow:-interval];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setVisitingMAGSHARE
{
    visitingMAGSHARE = YES;
}

/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
- (CLLocationCoordinate2D)lastLookup
{
    return lastLookup;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setLastLookup:(CLLocationCoordinate2D)inCoords
{
    lastLookup = inCoords;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)clearLastLookup
{
    lastLookup.longitude = lastLookup.latitude = 0.0;
}

/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
- (BOOL)listNeedsRefresh
{
    return listNeedsRefresh;
}

/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
- (BOOL)mapNeedsRefresh
{
    return mapNeedsRefresh;
}

/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
- (BOOL)isLookupValid
{
    BOOL    ret = YES;
    CLLocationCoordinate2D  lLookup = [self getWhereImAt].coordinate;
    
    if ( lLookup.longitude == 0 && lLookup.latitude == 0 )
        {
        ret = NO;
        }
    
    return ret;
}

/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
- (BOOL)getOpenAdvanced
{
    BOOL    ret = openAdvanced;
    
    openAdvanced = NO;
    
    return ret;
}

/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
- (BOOL)amISick
{
    return imSick;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)clearListNeedsRefresh
{
    listNeedsRefresh = NO;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)clearMapNeedsRefresh
{
    mapNeedsRefresh = NO;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)clearSearch
{
    [myListViewController clearSearchResults];
    [myMapViewController clearSearchResults];
    [self clearLastLookup];
    [self setSearchResults:nil];
    [self resetNavigationControllers];
}

/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    bmlt_app_delegate = self;
    bmlt_driver = [BMLT_Driver getBMLT_Driver]; // Same for the BMLT "driver," which manages the connections to the server[s].
#ifdef DEBUG
    if ( bmlt_driver )
        {
        NSLog(@"BMLT Driver Created Successfully!");
        }
    else
        {
        NSLog(@"ERROR: BMLT Driver Not Created!");
        }
#endif
    
    [bmlt_driver setDelegate:self];
    tabBarController = [[UITabBarController alloc] init];
    
    if ( tabBarController )
        {
        [tabBarController setDelegate:self];
        
        myListViewController = [[ListViewController alloc] init];
        
        if ( myListViewController )
            {
            myListViewController.navigationItem.title = NSLocalizedString(@"TAB-BAR-2", nil);
            listSearchController = [[UINavigationController alloc] initWithRootViewController:myListViewController];
            
            if ( listSearchController )
                {
                [[listSearchController tabBarItem] setTitle:NSLocalizedString(@"TAB-BAR-2", nil)];
                [[listSearchController tabBarItem] setImage:[UIImage imageNamed:@"List.png"]];
                }
            }
        
        myMapViewController = [[MapViewController alloc] init];
        
        if ( myMapViewController )
            {
            myMapViewController.navigationItem.title = NSLocalizedString(@"TAB-BAR-1", nil);
            mapSearchController = [[UINavigationController alloc] initWithRootViewController:myMapViewController];
            
            if ( mapSearchController )
                {
                [[mapSearchController tabBarItem] setTitle:NSLocalizedString(@"TAB-BAR-1", nil)];
                [[mapSearchController tabBarItem] setImage:[UIImage imageNamed:@"Globe.png"]];
                }
            }
        
                
        prefsController = [[PrefsViewController alloc] init];
        
        if ( prefsController )
            {
            [[prefsController tabBarItem] setTitle:NSLocalizedString(@"TAB-BAR-3", nil)];
            [[prefsController tabBarItem] setImage:[UIImage imageNamed:@"Prefs.png"]];
            }
        
        [tabBarController setViewControllers:[NSArray arrayWithObjects:listSearchController, mapSearchController, prefsController, nil] animated:YES]; 
        
        [[self window] setRootViewController:tabBarController];
        newSearchButton_map = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"NEW-SEARCH", nil)
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:myMapViewController
                                                                           action:@selector(newSearch)];
        
        if ( newSearchButton_map )
            {
            [newSearchButton_map setEnabled:NO];
            [mapSearchController.navigationBar.topItem setRightBarButtonItem:newSearchButton_map animated:YES];
            }
        
        newSearchButton_list = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"NEW-SEARCH", nil)
                                                           style:UIBarButtonItemStylePlain
                                                          target:myListViewController
                                                          action:@selector(newSearch)];
        
        if ( newSearchButton_list )
            {
            [newSearchButton_list setEnabled:NO];
            [listSearchController.navigationBar.topItem setRightBarButtonItem:newSearchButton_list animated:YES];
            }
        }
    
    mySearch = nil;
    [self clearLastLookup];
    [BMLT_Driver setUpServers];
    [self validateSearches];
    [[self window] makeKeyAndVisible];
    [self applicationWillEnterForeground:nil];
    return YES;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)dealloc
{
    [newSearchButton_map release];
    [newSearchButton_list release];
    [bmlt_driver release];
    [_window release];
    [tabBarController release];
    [mapSearchController release];
    [listSearchController release];
    [myListViewController release];
    [myMapViewController release];
    [locationManager release];
    [mySearch release];
    [whereImAt release];
    [searchResults release];
    [[BMLT_Prefs getBMLT_Prefs] release];
    [super dealloc];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setSearchResults:(NSArray *)inResults
{
    if ( inResults != searchResults )
        {
        mapNeedsRefresh = YES;
        listNeedsRefresh = YES;
        }

    [inResults retain];
    [searchResults release];
    searchResults = inResults;
}

/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
- (NSArray *)getSearchResults
{
    return searchResults;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if ( !visitingMAGSHARE )
        {
        BMLT_Prefs *myPrefs = [BMLT_Prefs getBMLT_Prefs];
        
        if ( [myPrefs lookupMyLocation] )
            {
            openSearch = [myPrefs startWithSearch];
            [self findLocation];
            }
        
        [self clearSearch];
        
        [tabBarController setSelectedIndex: [myPrefs startWithMap] ? 1 : 0];
        
        [BMLT_Prefs saveChanges];
        
        if ( ![myPrefs lookupMyLocation] && [myPrefs startWithSearch] )
            {
            openAdvanced = YES;
            [self engageNewSearch:[myPrefs startWithMap]];
            }
        }
    
    visitingMAGSHARE = NO;
}

/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
- (BMLT_Meeting_Search *)getMeetingSearch:(BOOL)createIfNotAlreadyThere
                               withParams:(NSDictionary *)inSearchParams
{
    if ( !mySearch && createIfNotAlreadyThere )
        {
        mySearch = [[BMLT_Meeting_Search alloc] initWithCriteria:inSearchParams andName:nil andDescription:nil];
        }
    
    return mySearch;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)deleteMeetingSearch
{
    [mySearch release];
    mySearch = nil;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)resetNavigationControllers
{
    [mapSearchController popToRootViewControllerAnimated:NO];
    [listSearchController popToRootViewControllerAnimated:NO];
}

/***************************************************************\**
 \brief Gesture Callback -Swipes from the List View to the Map View
 *****************************************************************/
- (IBAction)swipeFromList:(UIGestureRecognizer *)sender
{
    if ( ![self getSearchResults] )
        {
        [[listSearchController view] retain];
        [self transitionBetweenThisView:[listSearchController view] andThisView:[mapSearchController view]];
        [tabBarController setSelectedIndex:1];
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (IBAction)swipeFromMapToList:(UIGestureRecognizer *)sender
{
    if ( ![self getSearchResults] )
        {
        [[mapSearchController view] retain];
        [self transitionBetweenThisView:[mapSearchController view] andThisView:[listSearchController view]];
        [tabBarController setSelectedIndex:0];
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (IBAction)swipeFromMapToPrefs:(UIGestureRecognizer *)sender
{
    if ( ![self getSearchResults] )
        {
        [[mapSearchController view] retain];
        [self transitionBetweenThisView:[mapSearchController view] andThisView:[prefsController view]];
        [tabBarController setSelectedIndex:2];
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (IBAction)swipeFromPrefs:(UIGestureRecognizer *)sender
{
    [[prefsController view] retain];
    [self transitionBetweenThisView:[prefsController view] andThisView:[mapSearchController view]];
    [tabBarController setSelectedIndex:1];
}

/***************************************************************\**
 \brief Manages the transition from one view to another. Just like
 it says on the tin.
 *****************************************************************/
- (void)transitionBetweenThisView:(UIView *)srcView
                      andThisView:(UIView *)dstView
{
    if ( srcView != dstView )
        {
        if ( srcView == [listSearchController view] )
            {
            [listSearchController popToRootViewControllerAnimated:NO];
            }
        else if ( srcView == [mapSearchController view] )
            {
            [mapSearchController popToRootViewControllerAnimated:NO];
            }
        
        if ( srcView == [prefsController view] )
            {
            [UIView transitionFromView:srcView
                                toView:dstView
                              duration:0.25
                               options:UIViewAnimationOptionTransitionCurlDown
                            completion:nil];
            }
        else if ( dstView == [prefsController view] )
            {
            [UIView transitionFromView:srcView
                                toView:dstView
                              duration:0.25
                               options:UIViewAnimationOptionTransitionCurlUp
                            completion:nil];
            }
        else if ( srcView == [listSearchController view] && dstView == [mapSearchController view] )
            {
            [UIView transitionFromView:srcView
                                toView:dstView
                              duration:0.25
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            completion:nil];
            }
        else if ( dstView == [listSearchController view] && srcView == [mapSearchController view] )
            {
            [UIView transitionFromView:srcView
                                toView:dstView
                              duration:0.25
                               options:UIViewAnimationOptionTransitionFlipFromRight
                            completion:nil];
            }
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)engageNewSearch:(BOOL)isMap
{
    UINavigationController  *navController = isMap ? mapSearchController : listSearchController;
    
    SpecifyNewSearchViewController  *theController = [[SpecifyNewSearchViewController alloc] initWithSearchController:(A_SearchController *)[navController topViewController]];
    
    if ( ![self isLookupValid] )
        {
        openAdvanced = YES;
        }
    else
        {
        openAdvanced = [[BMLT_Prefs getBMLT_Prefs] preferAdvancedSearch];
        }
    
    if ( theController )
        {
        if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad )
            {
            [[theController navigationItem] setTitle:NSLocalizedString(isMap ? @"NEW-MAP-SEARCH" : @"NEW-LIST-SEARCH", nil)];
            }
        else
            {    
            [[theController navigationItem] setTitle:NSLocalizedString(@"SEARCH-SPEC-SECTION-1", nil)];
            }
        
        if ( isMap )
            {
            [myMapViewController setMySearchSetup:theController];
            }
        else
            {
            [myListViewController setMySearchSetup:theController];
            }
        
        [navController pushViewController:theController animated:YES];
        [theController release];
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)disableListNewSearch
{
    [newSearchButton_list setEnabled:NO];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)disableMapNewSearch
{
    [newSearchButton_map setEnabled:NO];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)validateSearches
{
    NSArray *validServers = [BMLT_Driver getValidServers];
    
    if ( validServers && [validServers count] )
        {
        [newSearchButton_map setEnabled:YES];
        [newSearchButton_list setEnabled:YES];
        [myMapViewController enableCenterButton:YES];
        [myListViewController enableCenterButton:YES];
        }
    else
        {
        [newSearchButton_map setEnabled:NO];
        [newSearchButton_list setEnabled:NO];
        [myMapViewController enableCenterButton:NO];
        [myListViewController enableCenterButton:NO];
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
#ifdef DEBUG
    NSLog(@"BMLTAppDelegate applicationDidReceiveMemoryWarning -My brain is full");
#endif
    [myListViewController abortSearch];
    [myListViewController release];
    myListViewController = nil;
    
    [myMapViewController abortSearch];
    [myMapViewController release];
    myMapViewController = nil;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)findLocation
{
#ifdef DEBUG
    NSLog(@"BMLTAppDelegate findLocation Where the hell am I?");
#endif
    if ( ![self amISick] )
        {
        if ( !locationManager )
            {
            locationManager = [[CLLocationManager alloc] init];
            }
        
        if ( locationManager )
            {
            [locationManager setDelegate:nil];
            [locationManager setDistanceFilter:kCLDistanceFilterNone];
            [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            }
        
        [locationManager setDelegate:self];
        [locationManager startUpdatingLocation];
        }
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (CLLocation *)getWhereImAt
{
    return whereImAt;
}

#pragma mark - Core Location Delegate Functions -

/***************************************************************\**
 \brief Called when the location manager updates. Makes sure that
 the update is fresh.
 *****************************************************************/
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
#ifdef DEBUG
    NSLog(@"Location Found: (%@)", newLocation);
#endif
    
    NSTimeInterval  t = [[newLocation timestamp] timeIntervalSinceNow];
    
    if ( t < -180 )
        {
        return;
        }
    
    [locationManager stopUpdatingLocation];
    
#ifdef DEBUG
    NSLog(@"BMLTAppDelegate didUpdateToLocation I'm at (%f, %f).", newLocation.coordinate.longitude, newLocation.coordinate.latitude);
#endif
    [newLocation retain];
    [whereImAt release];
    whereImAt = newLocation;
    if ( openSearch && ![self amISick] )
        {
        openSearch = NO;
        [self engageNewSearch:[[BMLT_Prefs getBMLT_Prefs] startWithMap]];
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)sortMeetingsByWeekdayAndTime
{
    NSArray *sortedArray = [searchResults sortedArrayUsingFunction:timeSort context:NULL];
    
    [searchResults release];
    
    searchResults = [[NSMutableArray alloc] initWithArray:sortedArray];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)sortMeetingsByDistance
{
    NSArray *sortedArray = [searchResults sortedArrayUsingFunction:distanceSort context:NULL];
    
    [searchResults release];
    
    searchResults = [[NSMutableArray alloc] initWithArray:sortedArray];
}

/***************************************************************\**
 \brief 
 \returns
 *****************************************************************/
NSInteger timeSort (id meeting1, id meeting2, void *context)
{
    BMLT_Meeting    *meeting_A = (BMLT_Meeting *)meeting1;
    BMLT_Meeting    *meeting_B = (BMLT_Meeting *)meeting2;
    
    if ( [meeting_A getWeekdayOrdinal] < [meeting_B getWeekdayOrdinal] )
        return NSOrderedAscending;
    else if ([meeting_A getWeekdayOrdinal] > [meeting_B getWeekdayOrdinal])
        return NSOrderedDescending;
    else if ( [meeting_A getStartTimeOrdinal] < [meeting_B getStartTimeOrdinal] )
        return NSOrderedAscending;
    else if ( [meeting_A getStartTimeOrdinal] > [meeting_B getStartTimeOrdinal] )
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}

/***************************************************************\**
 \brief 
 \returns
 *****************************************************************/
NSInteger distanceSort (id meeting1, id meeting2, void *context)
{
    BMLT_Meeting    *meeting_A = (BMLT_Meeting *)meeting1;
    BMLT_Meeting    *meeting_B = (BMLT_Meeting *)meeting2;
    
    double   distance1 = [(NSString *)[meeting_A getValueFromField:@"distance_in_km"] doubleValue];
    double   distance2 = [(NSString *)[meeting_B getValueFromField:@"distance_in_km"] doubleValue];
    
    if (distance1 < distance2)
        return NSOrderedAscending;
    else if (distance1 > distance2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}

#pragma mark - NSXMLParserDelegate
/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    currentElement = elementName;
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"BMLTAppDelegate Parser Start %@ element", elementName );
#endif
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string
{
    NSAutoreleasePool   *pool = [[NSAutoreleasePool alloc] init];
    
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"BMLTAppDelegate Parser foundCharacters: \"%@\"", string );
#endif
    if ( [currentElement isEqualToString:@"coordinates"] )
        {
        NSArray *coords = [string componentsSeparatedByString:@","];
        if ( coords && ([coords count] > 1) )
            {
            lastLookup.longitude = [(NSString *)[coords objectAtIndex:0] doubleValue];
            lastLookup.latitude = [(NSString *)[coords objectAtIndex:1] doubleValue];
#ifdef _CONNECTION_PARSE_TRACE_
            NSLog(@"BMLTAppDelegate Parser set lastLookup to: %f, %f", lastLookup.longitude, lastLookup.latitude );
#endif
            }
        }
    
    [pool release];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"BMLTAppDelegate Parser Stop %@ element", elementName );
#endif
    currentElement = nil;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser
parseErrorOccurred:(NSError *)parseError
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"BMLTAppDelegate Parser Error: %@", [parseError localizedDescription] );
#endif
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)parserDidStartDocument:(NSXMLParser *)parser  ///< The parser in question
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"BMLTAppDelegate Parser Starting" );
#endif
    currentElement = nil;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)parserDidEndDocument:(NSXMLParser *)parser  ///< The parser in question
{
    [(BMLT_Parser *)parser cancelTimeout];
    currentElement = nil;
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"BMLTAppDelegate Parser Complete" );
#endif
}

#pragma mark - UITabBarControllerDelegate code
/***************************************************************\**
 \brief This animates the view transitions, and also sets up anything
 that needs doing between views. It stops the tab bar controller
 from managing the transition, and does it manually.
 \returns a BOOL. Always NO.
 *****************************************************************/
- (BOOL)tabBarController:(UITabBarController *)inTabBarController
 shouldSelectViewController:(UIViewController *)inViewController
{
    [self transitionBetweenThisView:[[inTabBarController selectedViewController] view] andThisView:[inViewController view]];
    int index = [[inTabBarController viewControllers] indexOfObject:inViewController];
    [inTabBarController setSelectedIndex:index];
    return NO;
}

/***************************************************************\**
 \brief Accessor
 \returns the UITabBarController Object
 *****************************************************************/
- (UITabBarController *)tabBarController
{
    return tabBarController;
}

#pragma mark - BMLT_DriverDelegate code
/***************************************************************\**
 \brief Calledwhen the driver load experiences a failure.
 *****************************************************************/
- (void)driverFAIL:(BMLT_Driver *)inDriver  ///< The driver that is having a cow.
{
#ifdef DEBUG
    NSLog(@"BMLTAppDelegate driverFAIL Called");
#endif
    if ( ![self amISick] )
        {
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"COMM-ERROR",nil) message:NSLocalizedString(@"ERROR-CANT-LOAD-DRIVER",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK-BUTTON",nil) otherButtonTitles:nil];
        
        [myAlert show];
        [myAlert release];
        }
    
    imSick = YES;
}
@end
