//
//  BMLTAppDelegate.m
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

#import "BMLTAppDelegate.h"
#import "Reachability.h"
#import "BMLT_Prefs.h"
#import "BMLT_Meeting.h"
#import "BMLTDisplayListResultsViewController.h"
#import "BMLTMapResultsViewController.h"
#import "BMLTSimpleSearchViewController.h"
#import "BMLTAdvancedSearchViewController.h"
#import "BMLTMeetingDetailViewController.h"

static BMLTAppDelegate *g_AppDelegate = nil;    ///< This holds the SINGLETON instance of the application delegate.

/**************************************************************//**
 \class  BMLTAppDelegate -Private Interface
 \brief  This is the main application delegate class for the BMLT application
 *****************************************************************/
@interface BMLTAppDelegate ()
{
    BOOL                                    _findMeetings;              ///< If this is YES, then a meeting search will be done.
    BOOL                                    _amISick;                   ///< If true, it indicates that the alert for connectivity problems should not be shown.
    BOOL                                    _visitingRelatives;         ///< If true, then we will retain the app state, despite the flag that says we shouldn't.
    BMLT_Meeting_Search                     *mySearch;                  ///< The current meeting search in progress.
    UIViewController                        *searchNavController;       ///< This is the tab controller for all the searches.
    BMLTDisplayListResultsViewController    *listResultsViewController; ///< This will point to our list results main controller.
    BMLTMapResultsViewController            *mapResultsViewController;  ///< This will point to our map results main controller.
}
+ (NSDate *)getLocalDateAutoreleaseWithGracePeriod:(BOOL)useGracePeriod; ///< This is used to calculate the time for "later today" meetings.

- (void)transitionBetweenThisView:(UIView *)srcView andThisView:(UIView *)dstView direction:(int)dir;   ///< Do a nice transition between tab views.
- (void)callInSick;                                     ///< Display an alert, informing the user that network connectivity is unavailable.
- (void)sorryCharlie;                                   ///< Display an alert for no meetings found.
- (void)displaySearchResults;                           ///< Display the results of a search, according to the user preferences.
- (void)startAnimations;                                ///< Starts the animations in the two results screens.
- (void)stopAnimations;                                 ///< Stops the animations in the two results screens.
- (void)selectInitialSearchAndForce:(BOOL)force;        ///< Selects the initial search screen, depending on the user's choice.
- (void)simpleClearSearch;                              ///< Just clears the search results with no frou-frou.
NSInteger timeSort (id meeting1, id meeting2, void *context);       ///< Callback for the time sort.
NSInteger distanceSort (id meeting1, id meeting2, void *context);   ///< Callback for the distance sort.
@end

/**************************************************************//**
 \class  BMLTAppDelegate
 \brief  This is the main application delegate class for the BMLT application
 *****************************************************************/
@implementation BMLTAppDelegate

#pragma mark - Synthesize Class Properties -
@synthesize window      = _window;      ///< This will hold the window associated with this application instance.
@synthesize myLocation  = _myLocation;  ///< This will hold the location set by the last location lookup.
@synthesize locationManager;            ///< This holds the location manager instance.
@synthesize internetActive;             ///< Set to YES, if the network test says that the Internet is available.
@synthesize hostActive;                 ///< Set to YES, if the network test says that the root server is available.
@synthesize myPrefs;                    ///< This will have a reference to the global prefs object.
@synthesize searchResults;              ///< This will hold the latest search results.
@synthesize searchParams;               ///< This will hold the parameters to be used for the next search.
@synthesize lastSearchParams;           ///< This will hold the parameters that were used for the last search.

#pragma mark - Class Methods -
/**************************************************************//**
 \brief  This class method allows access to the application delegate object (SINGLETON)
 *****************************************************************/
+ (BMLTAppDelegate *)getBMLTAppDelegate
{
    return g_AppDelegate;
}

/**************************************************************//**
 \brief Check to make sure that Location Services are available
 \returns YES, if Location Services are available
 *****************************************************************/
+ (BOOL)locationServicesAvailable
{
    return [CLLocationManager locationServicesEnabled] != NO
            && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied;
}

/**************************************************************//**
 \brief Check to make sure that we can reach the root server.
 \returns YES, if the server is available.
 *****************************************************************/
+ (BOOL)canReachRootServer
{
    return [g_AppDelegate hostActive] && [g_AppDelegate internetActive];
}

/**************************************************************//**
 \brief Check to make sure that we have a valid location.
 \returns YES, if the location is valid.
 *****************************************************************/
+ (BOOL)validLocation
{
    return [g_AppDelegate isLookupValid];
}

/**************************************************************//**
 \brief returns the date/time of the "too late" meeting start time.
 \returns an NSDate, set to the time (either now, or with the grace period)
 *****************************************************************/
+ (NSDate *)getLocalDateAutoreleaseWithGracePeriod:(BOOL)useGracePeriod ///< YES, if the grace period is to be included.
{
    NSTimeInterval  interval = useGracePeriod ? [[BMLT_Prefs getBMLT_Prefs] gracePeriod] * 60 : 0;
    
    return [NSDate dateWithTimeIntervalSinceNow:-interval];
}

/**************************************************************//**
 \brief 
 *****************************************************************/
+ (void)viewMeetingDetails:(BMLT_Meeting *)inMeeting
            withController:(UIViewController *)theController
{
    BMLTMeetingDetailViewController *meetingDetails = [[BMLTMeetingDetailViewController alloc] init];
    [meetingDetails setMyMeeting:inMeeting];
    [meetingDetails setMyModalController:theController];
    [[meetingDetails navigationItem] setTitle:[inMeeting getBMLTName]];
    [[[meetingDetails navigationItem] titleView] sizeToFit];
    [[theController navigationController] pushViewController:meetingDetails animated:YES];
}

#pragma mark - Private methods -
/**************************************************************//**
 \brief Manages the transition from one view to another. Just like
        it says on the tin.
 *****************************************************************/
- (void)transitionBetweenThisView:(UIView *)srcView ///< The view object we're transitioning away from
                      andThisView:(UIView *)dstView ///< The view object we're going to
                        direction:(int)dir          /**< The direction. One of these:
                                                        - -2 Going out of the settings pages.
                                                        - -1 Going from right to left
                                                        - 1 Going from left to right
                                                        - 2 Going into the settings pages
                                                    */
{
    if ( dir && (srcView != dstView) )
        {
        UIViewAnimationOptions  option = 0;
        
        switch ( dir )
            {
                case -2:    // Going from the settings to another tab.
                option = UIViewAnimationOptionTransitionCurlDown;
                break;
                
                case -1:    // Going from a right tab to a left tab.
                option = UIViewAnimationOptionTransitionFlipFromLeft;
                break;
                
                case 1:     // Going from a left tab to a right tab.
                option = UIViewAnimationOptionTransitionFlipFromRight;
                break;
                
                case 2:     // Going into the settings pages.
                option = UIViewAnimationOptionTransitionCurlUp;
                break;
            }
        
        [UIView transitionFromView:srcView
                            toView:dstView
                          duration:0.25
                           options:option
                        completion:nil];
        }
}

/**************************************************************//**
 \brief Displays an alert, mentioning that there is no valid connection.
 *****************************************************************/
- (void)callInSick
{
#ifdef DEBUG
    NSLog(@"Calling in sick.");
#endif
    if ( !_amISick )    // This makes sure we only call it once.
        {
        _amISick = YES;
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"COMM-ERROR",nil) message:NSLocalizedString(@"ERROR-CANT-LOAD-DRIVER",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK-BUTTON",nil) otherButtonTitles:nil];
        [myAlert show];
        }
    
}

/**************************************************************//**
 \brief Displays an alert for no meetings found.
 *****************************************************************/
- (void)sorryCharlie
{
#ifdef DEBUG
    NSLog(@"No meetings found.");
#endif
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NO-SEARCH-RESULTS",nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK-BUTTON",nil) otherButtonTitles:nil];
    [myAlert show];    
}

/**************************************************************//**
 \brief This is called to tell the app to display the search results.
 *****************************************************************/
- (void)displaySearchResults
{
#ifdef DEBUG
    NSLog(@"BMLTAppDelegate::displaySearchResults called.");
#endif
    [self setUpTabBarItems];
    UITabBarController  *tabController = (UITabBarController *)self.window.rootViewController;
    
    [listResultsViewController setDataArrayFromData:[self searchResults]];
    [mapResultsViewController setDataArrayFromData:[self searchResults]];
    
    if ( [[self searchResults] count] )
        {
        [listResultsViewController setIncludeSortRow:YES];
        
        BOOL    mapSearch = [[BMLT_Prefs getBMLT_Prefs] preferSearchResultsAsMap];
        int selectedIndex = (mapSearch ? 2 : 1);
        
        [tabController setSelectedIndex:selectedIndex];
        }
    else
        {
        [self sorryCharlie];
        }
}

/**************************************************************//**
 \brief Selects the initial search screen, depending on the user's choice.
 *****************************************************************/
- (void)selectInitialSearchAndForce:(BOOL)force         ///< If YES, then the screen will be set to the default, even if we were already set to one.
{
#ifdef DEBUG
    NSLog(@"BMLTAppDelegate::selectInitialSearchAndForce called.");
#endif
    UITabBarController  *tabController = (UITabBarController *)self.window.rootViewController;
    
    [tabController setSelectedIndex:0]; // Set the tab bar to the search screens.
    
    if ( force )
        {
        UIStoryboard    *st = [tabController storyboard];
        
        [[searchNavController navigationController] popToRootViewControllerAnimated:NO];
        
        UIViewController    *newSearch = nil;
        
        switch ( [[BMLT_Prefs getBMLT_Prefs] searchTypePref] )
            {
            case _PREFER_ADVANCED_SEARCH:
            newSearch = [st instantiateViewControllerWithIdentifier:@"advanced-search"];
            [[searchNavController navigationController] pushViewController:newSearch animated:NO];
            UIViewController    *simpleViewController = [[[searchNavController navigationController] viewControllers] objectAtIndex:0];
            
            simpleViewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString([[simpleViewController navigationItem] title], nil)
                                                                                                     style:UIBarButtonItemStyleBordered
                                                                                                    target:nil
                                                                                                    action:nil];
            break;
            }
        }
}

/**************************************************************//**
 \brief This clears the search without resetting the view.
 *****************************************************************/
- (void)simpleClearSearch
{
    if (searchResults && [searchResults count])
        {
        [searchResults removeAllObjects];
        searchResults = nil;
        }
}

#pragma mark - Standard Instance Methods -
/**************************************************************//**
 \brief  Initialize the object
 \returns    self
 *****************************************************************/
- (id)init
{
    self = [super init];
    
    if ( self )
        {
        g_AppDelegate = self;
        myPrefs = [BMLT_Prefs getBMLT_Prefs];
        [self startNetworkMonitor];
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setPurpose:NSLocalizedString(@"LOCATION-PURPOSE", nil)];
        [locationManager setDistanceFilter:kCLDistanceFilterNone];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [locationManager setDelegate:self];
        searchParams = [[NSMutableDictionary alloc] init];
        }
    
    return self;
}

/**************************************************************//**
 \brief Just make sure that we stop the netmon service and the
        location lookup.
 *****************************************************************/
- (void)dealloc
{
    [mySearch clearSearch];
    [searchParams removeAllObjects];
    [self stopNetworkMonitor];
    [locationManager stopUpdatingLocation];
}

/**************************************************************//**
 \brief  Called when the app has finished its launch setup.
 \returns    a BOOL. The app is go for launch.
 *****************************************************************/
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef DEBUG
    NSLog(@"BMLTAppDelegate::didFinishLaunchingWithOptions called.");
#endif
    UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
    [tabController setSelectedIndex:0];
    [tabController setDelegate:self];
    // We're going to have a blue "leather" background for most screens.
    if ( [BMLTVariantDefs windowBackgroundColor] )
        {
        [_window setBackgroundColor:[BMLTVariantDefs windowBackgroundColor]];
        }
    for ( NSInteger i = 0; i < [[tabController viewControllers] count]; i++ )
        {
        UITabBarItem    *theItem = [[[tabController viewControllers] objectAtIndex:i] tabBarItem];
        [theItem setTitle:NSLocalizedString([theItem title], nil)];
        }
    
    // We keep track of these in private data members for convenience.
    searchNavController = (UINavigationController *)[(UINavigationController *)[[tabController viewControllers] objectAtIndex:0] topViewController];
    listResultsViewController = (BMLTDisplayListResultsViewController *)[(UINavigationController *)[[tabController viewControllers] objectAtIndex:1] topViewController];
    mapResultsViewController = (BMLTMapResultsViewController *)[(UINavigationController *)[[tabController viewControllers] objectAtIndex:2] topViewController];
    
    [self clearAllSearchResultsYes];
    if ( [myPrefs lookupMyLocation] )
        {
        [locationManager startUpdatingLocation];
        }
    
    [listResultsViewController addClearSearchButton];
    [mapResultsViewController addClearSearchButton];
    return YES;
}

/**************************************************************//**
 \brief Called when the app is about to go into the background.
        We suspend the location and network availability updates
        while the app is in the background.
*****************************************************************/
- (void)applicationWillResignActive:(UIApplication *)application
{
#ifdef DEBUG
    NSLog(@"BMLTAppDelegate::applicationWillResignActive called.");
#endif
    [mySearch clearSearch]; // No searches in the background.
    mySearch = nil;
    [self stopNetworkMonitor];
    [locationManager stopUpdatingLocation];
    _amISick = NO;  // Make sure the user is informed of network outages when they come back.
}

/**************************************************************//**
 \brief Called when the app is about to show up.
        We renew the updates (check if we have keep location up to
        date pref on before doing that one).
 *****************************************************************/
- (void)applicationWillEnterForeground:(UIApplication *)application
{
#ifdef DEBUG
    NSLog(@"BMLTAppDelegate::applicationWillEnterForeground called.");
#endif
    if ( ![myPrefs preserveAppStateOnSuspend] && !_visitingRelatives )
        {
#ifdef DEBUG
        NSLog(@"BMLTAppDelegate::applicationWillEnterForeground The app state will be reset to initial.");
#endif
        [self clearAllSearchResultsYes];
        }
    else if ( !_visitingRelatives )
        {
#ifdef DEBUG
        NSLog(@"BMLTAppDelegate::applicationWillEnterForeground The app state will be left alone, but we'll make sure the tab bar is enabled/disabled properly.");
#endif
        [self setUpTabBarItems];
        }
#ifdef DEBUG
    else
        {
        NSLog(@"BMLTAppDelegate::applicationWillEnterForeground The app state will be left completely alone.");
        }
#endif
    
    _visitingRelatives = NO;
    
    if ( [myPrefs keepUpdatingLocation] )
        {
#ifdef DEBUG
        NSLog(@"BMLTAppDelegate::applicationWillEnterForeground We will coninuously update our location.");
#endif
        [locationManager startUpdatingLocation];
        }
    
    [self startNetworkMonitor];
}

#pragma mark - Custom Instance Methods -
/**************************************************************//**
 \brief Begins a lookup search, in which a location is found first,
        then all meetings near there are returned.
 *****************************************************************/
- (void)searchForMeetingsNearMe
{
#ifdef DEBUG
    NSLog(@"BMLTAppDelegate searchForMeetingsNearMe called.");
#endif
    [self clearAllSearchResults:NO];
    [self startAnimations];
    // Remember that we have a pref for result count.
    [searchParams setObject:[NSString stringWithFormat:@"%d", -[myPrefs resultCount]] forKey:@"geo_width"];
    [searchParams setObject:@"time" forKey:@"sort_key"]; // Sort by time for this search.
    
    _findMeetings = YES;   // This is a semaphore, that tells the app to do a search, once it has settled on a location.
    [locationManager startUpdatingLocation];
}

/**************************************************************//**
 \brief Same as above, except we only look for meetings later today.
 *****************************************************************/
- (void)searchForMeetingsNearMeLaterToday
{
#ifdef DEBUG
    NSLog(@"BMLTAppDelegate searchForMeetingsNearMeLaterToday called.");
#endif
    NSDate              *date = [BMLTAppDelegate getLocalDateAutoreleaseWithGracePeriod:YES];
    NSCalendar          *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents    *weekdayComponents = [gregorian components:(NSWeekdayCalendarUnit) fromDate:date];
    NSInteger           wd = [weekdayComponents weekday];
    weekdayComponents = [gregorian components:(NSHourCalendarUnit) fromDate:date];
    NSInteger           hr = [weekdayComponents hour];
    weekdayComponents = [gregorian components:(NSMinuteCalendarUnit) fromDate:date];
    NSInteger           mn = [weekdayComponents minute];
    
    [searchParams setObject:[NSString stringWithFormat:@"%d",wd] forKey:@"weekdays"];
    [searchParams setObject:[NSString stringWithFormat:@"%d",hr] forKey:@"StartsAfterH"];
    [searchParams setObject:[NSString stringWithFormat:@"%d",mn] forKey:@"StartsAfterM"];
    
    [self searchForMeetingsNearMe];
}

/**************************************************************//**
 \brief Same as above, except we only look for meetings tomorrow.
 *****************************************************************/
- (void)searchForMeetingsNearMeTomorrow
{
#ifdef DEBUG
    NSLog(@"BMLTAppDelegate searchForMeetingsNearMeTomorrow called.");
#endif
    NSCalendar          *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents    *weekdayComponents = [gregorian components:(NSWeekdayCalendarUnit) fromDate:[BMLTAppDelegate getLocalDateAutoreleaseWithGracePeriod:NO]];
    NSInteger           wd = [weekdayComponents weekday] + 1;
    
    if ( wd > 7 )
        {
        wd = 1;
        }
    
    [searchParams setObject:[NSString stringWithFormat:@"%d",wd] forKey:@"weekdays"];
    [searchParams setObject:@"time" forKey:@"sort_key"]; // Sort by time for this search.
    
    [self searchForMeetingsNearMe];
}

/**************************************************************//**
 \brief     Lets you know if we have a valid location lookup.
 \returns   YES, if the last lookup is valid.
 *****************************************************************/
- (BOOL)isLookupValid
{
    BOOL    ret = YES;
    CLLocationCoordinate2D  lLookup = [self myLocation].coordinate;
    
    if ( lLookup.longitude == 0 && lLookup.latitude == 0 )
        {
        ret = NO;
        }
    
#ifdef DEBUG
    NSLog(@"BMLTAppDelegate::isLookupValid called. The last lookup is %@.", (ret ? @"valid" : @"invalid"));
#endif
    return ret;
}

/**************************************************************//**
 \brief Enables and Disables the UITabBar items in accordance with the current state.
 *****************************************************************/
- (void)setUpTabBarItems
{
    UITabBarController  *tabController = (UITabBarController *)self.window.rootViewController;
    UITabBarItem        *listResultsItem = [[[tabController viewControllers] objectAtIndex:1] tabBarItem];
    UITabBarItem        *mapResultsItem = [[[tabController viewControllers] objectAtIndex:2] tabBarItem];
    
    // If we have valid search results, or there's a search under way, we enable both results tabs.
    if ((searchResults && [searchResults count]) || (mySearch && [mySearch searchInProgress]))
        {
#ifdef DEBUG
        NSLog(@"BMLTAppDelegate setUpTabBarItems called. We are enabling the search results tabs.");
#endif
        [listResultsItem setEnabled:YES];
        [mapResultsItem setEnabled:YES];
        }
    else
        {
#ifdef DEBUG
        NSLog(@"BMLTAppDelegate setUpTabBarItems called. We are disabling the search results tabs, and selecting the search tab.");
#endif
        [listResultsItem setEnabled:NO];
        [mapResultsItem setEnabled:NO];
        [tabController setSelectedIndex:0];
        }
}

/**************************************************************//**
 \brief Clears all the search results, and the results views.
 *****************************************************************/
- (void)clearAllSearchResults:(BOOL)inForce ///< YES, if we will force the search to switch.
{
    [self simpleClearSearch];
    [self stopAnimations];
    [self performSelectorOnMainThread:@selector(setUpTabBarItems) withObject:nil waitUntilDone:NO];
    [mapResultsViewController closeModal];      ///< Make sure we close any open modals or popovers, first.
    [listResultsViewController closeModal];
    [mapResultsViewController clearMapCompletely];
    [[mapResultsViewController navigationController] popToRootViewControllerAnimated:NO];
    [[listResultsViewController navigationController] popToRootViewControllerAnimated:NO];
    [listResultsViewController setDataArrayFromData:nil];
    [self selectInitialSearchAndForce:inForce];
}

/**************************************************************//**
 \brief Clears all the search results, and the results views.
        This version assumes YES, and is a shorthand for the button.
 *****************************************************************/
- (void)clearAllSearchResultsYes
{
    [self clearAllSearchResults:YES];
}

/**************************************************************//**
 \brief    Starts the animations in the two results screens.
 *****************************************************************/
- (void)startAnimations
{
    
}

/**************************************************************//**
 \brief    Stops the animations in the two results screens.
 *****************************************************************/
- (void)stopAnimations
{
    
}

/**************************************************************//**
 \brief This is called by other instances to prevent the app from
        having its state changed between calls.
        It is a "One-shot" operation that loses persistency between calls.
 *****************************************************************/
- (void)imVisitingRelatives
{
    _visitingRelatives = YES;
}

#pragma mark - Core Location Delegate Methods -
/**************************************************************//**
 \brief Called when the location manager has a failure.
 *****************************************************************/
- (void)locationManager:(CLLocationManager *)manager    ///< The location manager in troubkle.
       didFailWithError:(NSError *)error                ///< Oh, Lord, the trouble I'm in...
{
#ifdef DEBUG
    NSLog(@"BMLTAppDelegate didFailWithError: %@", [error localizedDescription]);
#endif
}

/**************************************************************//**
 \brief Called when the location manager updates. Makes sure that
        the update is fresh.
 *****************************************************************/
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [locationManager stopUpdatingLocation]; // Stop updating for now.
    
#ifdef DEBUG
    NSLog(@"BMLTAppDelegate didUpdateToLocation Location Found: (%@)", newLocation);
#endif
    
    NSInteger  t = abs((NSInteger)[[newLocation timestamp] timeIntervalSinceNow]);
    if ( t < -10 )  // Ten seconds old is too old.
        {
#ifdef DEBUG
        NSLog(@"BMLTAppDelegate didUpdateToLocation ignoring old GPS info :%d", t);
#endif
        return;
        }    
    
#ifdef DEBUG
    NSLog(@"BMLTAppDelegate didUpdateToLocation I'm at (%f, %f), the horizontal accuracy is %f, and the time interval is %d.", newLocation.coordinate.longitude, newLocation.coordinate.latitude, newLocation.horizontalAccuracy, t);
#endif
    
    // Make sure that we have a setup that encourages a location-based meeting search (no current search, and a geo_width that will constrain the search).
    if ( _findMeetings && [searchParams objectForKey:@"geo_width"] )
        {
        // We give the new search our location.
        [searchParams setObject:[NSString stringWithFormat:@"%f", newLocation.coordinate.longitude] forKey:@"long_val"];
        [searchParams setObject:[NSString stringWithFormat:@"%f", newLocation.coordinate.latitude] forKey:@"lat_val"];
#ifdef DEBUG
        NSLog(@"BMLTAppDelegate didUpdateToLocation: Starting a new location-based search.");
#endif
        [self executeSearchWithParams:searchParams];    // Start the search.
        
        _findMeetings = NO; // Clear the semaphore.
        [self performSelectorOnMainThread:@selector(setUpTabBarItems) withObject:nil waitUntilDone:NO];
        }
    else
        {
        [self stopAnimations];
        }
    
    [self setMyLocation:newLocation];

    if ( [myPrefs keepUpdatingLocation] )   // If they want us to keep updating, we will.
        {
        [locationManager startUpdatingLocation];
        }
}

#pragma mark - UITabBarControllerDelegate code -
/**************************************************************//**
 \brief This animates the view transitions, and also sets up anything
        that needs doing between views. It stops the tab bar controller
        from managing the transition, and does it manually.
 \returns a BOOL. Always NO.
 *****************************************************************/
- (BOOL)tabBarController:(UITabBarController *)inTabBarController
shouldSelectViewController:(UIViewController *)inViewController
{
    int newIndex = [[inTabBarController viewControllers] indexOfObject:inViewController];
    int oldIndex = [inTabBarController selectedIndex];
    
    // This is how we tell the transition routine what effect to use when switching between views.
    // An ascending index means that we are going left to right, and vice-versa.
    // However, we use a different transition when going into the and away from the settings (the last item), so we indicate that.
    int dir = (newIndex == ([[inTabBarController viewControllers] count] - 1)) ? 2 : ((oldIndex == ([[inTabBarController viewControllers] count] - 1)) ? -2 : ((newIndex < oldIndex) ? -1 : ((newIndex == oldIndex) ? 0 : 1)));
    
    if ( dir )  // Don't bother if there's no change.
        {
        [self transitionBetweenThisView:[[inTabBarController selectedViewController] view] andThisView:[inViewController view] direction:dir];
        [inTabBarController setSelectedIndex:newIndex];
        }
    
    return NO;  // Let the controller know that we handled it.
}

#pragma mark - Network Monitor Methods -
/**************************************************************//**
 \brief This method starts an asynchronous test of the network,
        ensuring that we can reach the root server. This is running
        continuously, so we will get callbacks to keep us apprised
        of our connectivity status.
 *****************************************************************/
- (void)startNetworkMonitor
{
    [self stopNetworkMonitor];  // We stop first, in order to establish a "clean slate."
    
#ifdef DEBUG
    NSLog(@"Starting the network status check.");
#endif
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusCallback:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to our root server exists
    NSURL       *test_uri = [BMLTVariantDefs rootServerURI];
    NSString    *root_uri = [test_uri host];
    hostReachable = [Reachability reachabilityWithHostName:root_uri];
    [hostReachable startNotifier];
}

/**************************************************************//**
 \brief This stops the network monitoring service.
 *****************************************************************/
- (void)stopNetworkMonitor
{
#ifdef DEBUG
    NSLog(@"Stopping the network status check.");
#endif
    internetActive = NO;
    hostActive = NO;
    
    [internetReachable stopNotifier];
    internetReachable = nil;
    [hostReachable stopNotifier];
    hostReachable = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

/**************************************************************//**
 \brief This is the connectivity test callback.
        The BMLT servers will only be instantiated if the network is OK.
        If the network becomes disconnected, the servers will be uninstantiated.
 *****************************************************************/
- (void)networkStatusCallback:(NSNotification *)notice
{
#ifdef DEBUG
    NSLog(@"Network status check callback.");
#endif

    // called after network status changes
    switch ([internetReachable currentReachabilityStatus])
        {
        default:
#ifdef DEBUG
            NSLog(@"The internet connection is in an unknown state.");
#endif
        case NotReachable:
            {
#ifdef DEBUG
            NSLog(@"The internet is down.");
#endif
            internetActive = NO;
        
            break;
            }
        
        case ReachableViaWiFi:
            {
#ifdef DEBUG
            NSLog(@"The internet is working via WIFI.");
#endif
            internetActive = YES;
        
            break;
            }
        
        case ReachableViaWWAN:
            {
#ifdef DEBUG
            NSLog(@"The internet is working via WWAN.");
#endif
            internetActive = YES;
            
            break;
            }
        }
    
    switch ([hostReachable currentReachabilityStatus])
        {
        default:
#ifdef DEBUG
            NSLog(@"The gateway to the root server is in an unknown state.");
#endif
        case NotReachable:
            {
#ifdef DEBUG
            NSLog(@"The gateway to the root server is down.");
#endif
            hostActive = NO;
            
            break;
            }
        
        case ReachableViaWiFi:
            {
#ifdef DEBUG
            NSLog(@"A gateway to the root server is working via WIFI.");
#endif
            hostActive = YES;
            
            break;
            }
        
        case ReachableViaWWAN:
            {
#ifdef DEBUG
            NSLog(@"A gateway to the root server is working via WWAN.");
#endif
            hostActive = YES;
            
            break;
            }
        }
    
    // The driver sets up the servers when we have a connection, and takes them down, when we don't.
    
    NSArray *validServers = [BMLT_Driver getValidServers];
    
    if ( (!validServers || (0 == [validServers count])) && hostActive && internetActive )
        {
#ifdef DEBUG
        NSLog(@"The network connection is fine, and we don't have valid servers, so we'll set up the server.");
#endif
        [BMLT_Driver setUpServers];
        }
    else if (!hostActive || !internetActive)
        {
#ifdef DEBUG
        NSLog(@"The network connection is not usable, so we'll make sure we delete our servers.");
#endif
        if ( validServers && [validServers count] )
            {
            NSInteger num_servers = [validServers count];
            
            for ( NSInteger c = num_servers; 0 < c; c-- )
                {
                BMLT_Server *server = (BMLT_Server*)[validServers objectAtIndex:c - 1];
                
                if ( server )
                    {
                    [[BMLT_Driver getBMLT_Driver] removeServerObject:server];
                    }
                }
            }
        
        [self callInSick];  // Put up an alert, if one has not already been shown.
        }
    else
        {
#ifdef DEBUG
        NSLog(@"The network connection is fine, and we already have valid servers.");
#endif
        }
}

#pragma mark - SearchDelegate Functions -
/**************************************************************//**
 \brief If there is an extrenal search abort, it is sent here.
 *****************************************************************/
- (void)abortSearch
{
#ifdef DEBUG
    NSLog(@"BMLTAppDelegate abortSearch called.");
#endif
}

/**************************************************************//**
 \brief This starts the search going, which is an XML parser
        transaction with the root server. We are the search delegate,
        and will be called upon completion or error.
 *****************************************************************/
- (void)executeSearchWithParams:(NSDictionary *)inSearchParams  ///< These are the search criteria to be sent to the server.
{
#ifdef DEBUG
    NSLog(@"BMLTAppDelegate executeSearchWithParams called.");
#endif
    [self startAnimations];
    [locationManager stopUpdatingLocation];
    [self simpleClearSearch];
    [mySearch clearSearch];
    mySearch = nil;
    mySearch = [[BMLT_Meeting_Search alloc] initWithCriteria:inSearchParams andName:nil andDescription:nil];
    [mySearch setDelegate:self];
    [mySearch doSearch];
}

/**************************************************************//**
 \brief When the XML parse is complete, we get this call, with the
        complete search results.
        We transfer the search results to our internal property, then
        delete the search, and call the routine that displays the
        search results. On the off chance that we are in another
        thread, we use the main thread call.
 *****************************************************************/
- (void)searchCompleteWithError:(NSError *)inError  ///< If there was an error, it is indicated in this parameter.
{
#ifdef DEBUG
    NSLog(@"BMLTAppDelegate searchCompleteWithError Search Complete With %@", (inError ? [inError description] : @"No Errors"));
#endif
    if ( inError )
        {
        [self clearAllSearchResultsYes];
        }
    else
        {
        [searchResults removeAllObjects];
        searchResults = [NSMutableArray arrayWithArray:[mySearch getSearchResults]];
        [mySearch clearSearch];
        mySearch = nil;
        // We copy the parameters that were used for the last search, so they can be accessed later, then clear the search parameters.
        lastSearchParams = nil;
        lastSearchParams = [[NSDictionary alloc] initWithDictionary:searchParams];
        [searchParams removeAllObjects];
        // Since it is possible we are in another thread, make sure that we call the UI routine in the main thread.
        [self performSelectorOnMainThread:@selector(displaySearchResults) withObject:nil waitUntilDone:NO];
        }
}

/**************************************************************//**
 \brief Simply return the search results.
 \returns a A_BMLT_Search reference, with our internal search results.
 *****************************************************************/
- (A_BMLT_Search *)getSearch
{
    return mySearch;
}

#pragma mark - Special Meeting Sort Sauce -

/**************************************************************//**
 \brief Sort the search results by weekday first, then start time.
 *****************************************************************/
- (void)sortMeetingsByWeekdayAndTime
{
    NSArray *sortedArray = [searchResults sortedArrayUsingFunction:timeSort context:NULL];
    
    searchResults = [[NSMutableArray alloc] initWithArray:sortedArray];
}

/**************************************************************//**
 \brief Sort the meetings by distance first, then weekday, then start time.
 *****************************************************************/
- (void)sortMeetingsByDistance
{
    NSArray *sortedArray = [searchResults sortedArrayUsingFunction:distanceSort context:NULL];
    
    searchResults = [[NSMutableArray alloc] initWithArray:sortedArray];
}

/**************************************************************//**
 \brief C function that is a sort callback for sorting by start time/day
 \returns the result of a comparison between the two meetings.
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

/**************************************************************//**
 \brief C function that is a sort callback for sorting by distance
 \returns the result of a comparison between the two meetings.
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


@end
