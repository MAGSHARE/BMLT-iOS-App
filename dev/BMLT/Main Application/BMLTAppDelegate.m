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

//

#import "BMLTAppDelegate.h"
#import "Reachability.h"
#import "BMLT_Prefs.h"

static BMLTAppDelegate *g_AppDelegate = nil;    ///< This holds the SINGLETON instance of the application delegate.

/***************************************************************\**
 \class  BMLTAppDelegate -Private Interface
 \brief  This is the main application delegate class for the BMLT application
 *****************************************************************/
@interface BMLTAppDelegate ()
{
    BOOL    _findMeetings;  ///< If this is YES, then a meeting search will be done.
    BOOL    _amISick;       ///< If true, it indicates that the alert for connectivity problems should not be shown.
}
@end

/***************************************************************\**
 \class  BMLTAppDelegate
 \brief  This is the main application delegate class for the BMLT application
 *****************************************************************/
@implementation BMLTAppDelegate

#pragma mark - Synthesize Class Properties
@synthesize window      = _window;      ///< This will hold the window associated with this application instance.
@synthesize myLocation  = _myLocation;  ///< This will hold the location set by the last location lookup.
@synthesize locationManager;            ///< This holds the location manager instance.
@synthesize internetActive;             ///< Set to YES, if the network test says that the Internet is available.
@synthesize hostActive;                 ///< Set to YES, if the network test says that the root server is available.
@synthesize myPrefs;                    ///< This will have a reference to the global prefs object.

#pragma mark - Class Methods
/***************************************************************\**
 \brief  This class method allows access to the application delegate object (SINGLETON)
 *****************************************************************/
+ (BMLTAppDelegate *)getBMLTAppDelegate
{
    return g_AppDelegate;
}

/***************************************************************\**
 \brief Check to make sure that Location Services are available
 \returns YES, if Location Services are available
 *****************************************************************/
+ (BOOL)locationServicesAvailable
{
    return [CLLocationManager locationServicesEnabled] != NO
            && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied;
}

/***************************************************************\**
 \brief Check to make sure that we can reach the root server.
 \returns YES, if the server is available.
 *****************************************************************/
+ (BOOL)canReachRootServer
{
    return [g_AppDelegate hostActive] && [g_AppDelegate internetActive];
}

/***************************************************************\**
 \brief Check to make sure that we have a valid location.
 \returns YES, if the location is valid.
 *****************************************************************/
+ (BOOL)validLocation
{
    return [g_AppDelegate isLookupValid];
}

#pragma mark - Standard Instance Methods -
/***************************************************************\**
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
        }
    
    return self;
}

/***************************************************************\**
 \brief Just make sure that we stop the netmon service and the
        location lookup.
 *****************************************************************/
- (void)dealloc
{
    [self stopNetworkMonitor];
    [locationManager stopUpdatingLocation];
}

/***************************************************************\**
 \brief  Called when the app has finished its launch setup.
 \returns    a BOOL. The app is go for launch.
 *****************************************************************/
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
    [tabController setSelectedIndex:0];
    tabController.delegate = self;
    return YES;
}

/***************************************************************\**
 \brief  Called when the app is about to go into the background.
        We suspend the location and network availability updates
        while the app is in the background.
*****************************************************************/
- (void)applicationWillResignActive:(UIApplication *)application
{
    [self stopNetworkMonitor];
    [locationManager stopUpdatingLocation];
}

/***************************************************************\**
 \brief  Called when the app is about to show up.
        We renew the updates (check if we have keep location up to
        date pref on before doing that one).
 *****************************************************************/
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self startNetworkMonitor];
    if ( [myPrefs keepUpdatingLocation] )
        {
        [locationManager startUpdatingLocation];
        }
}

#pragma mark - Custom Instance Methods -
/***************************************************************\**
 \brief Begins a lookup search, in which a location is found first,
        then all meetings near there are returned.
 *****************************************************************/
- (void)searchForMeetingsNearMeAllWeek
{
    [self findLocationAndMeetings:YES];
}

/***************************************************************\**
 \brief Starts an asynchronous Location Manager update process.
        If the findMeetings flag is YES, then a locale-based meeting
        search will take place after the location lookup.
 \returns   a BOOL. YES, if the call resulted in a new location lookup.
 *****************************************************************/
- (BOOL)findLocationAndMeetings:(BOOL)findMeetings
{
    BOOL    ret = NO;
#ifdef DEBUG
    NSLog(@"BMLTAppDelegate findLocationAndMeetings.%@", findMeetings ? @" Set to search for meetings after the location is found." : @" Just update the location." );
#endif
    [self setMyLocation:nil];
    
    // If we are already looking for a location, then we just let it keep going, and we ignore the call. If not, we start a new lookup.
    if ( !locationManager )
        {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:nil];
        [locationManager setDistanceFilter:kCLDistanceFilterNone];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [locationManager setDelegate:self];
        [locationManager setPurpose:NSLocalizedString(@"LOCATION-PURPOSE", nil)];
        ret = YES;
        }
    
    _findMeetings = findMeetings;
    [locationManager startUpdatingLocation];
    
    return ret;
}

/***************************************************************\**
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
    
    return ret;
}

#pragma mark - Core Location Delegate Methods -
/***************************************************************\**
 \brief Called when the location manager updates. Makes sure that
        the update is fresh.
 *****************************************************************/
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
#ifdef DEBUG
    NSLog(@"BMLTAppDelegate didUpdateToLocation Location Found: (%@)", newLocation);
#endif
    
    // This makes sure that we spend at least 15 seconds looking up the location, and that we have good horizontal accuracy (reduces the incidence of cached location data).
    if( newLocation.horizontalAccuracy > 100 )
        {
#ifdef DEBUG
        NSLog(@"BMLTAppDelegate didUpdateToLocation ignoring GPS location more than 100 meters inaccurate :%f", newLocation.horizontalAccuracy);
#endif
        return;
        }
    
    NSInteger  t = abs((NSInteger)[[newLocation timestamp] timeIntervalSinceNow]);
    if ( t > 15.0 )
        {
#ifdef DEBUG
        NSLog(@"BMLTAppDelegate didUpdateToLocation ignoring GPS location more than 15 seconds old (cached) :%d", t);
#endif
        return;
        }    
    
    if ( ![myPrefs keepUpdatingLocation] )
        {
        [locationManager stopUpdatingLocation];
        }
    
#ifdef DEBUG
    NSLog(@"BMLTAppDelegate didUpdateToLocation I'm at (%f, %f), the horizontal accuracy is %f, and the time interval is %d.", newLocation.coordinate.longitude, newLocation.coordinate.latitude, newLocation.horizontalAccuracy, t);
#endif
    [self setMyLocation:newLocation];
}

#pragma mark - Network Monitor Methods -
/***************************************************************\**
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
    NSURL       *test_uri = [NSURL URLWithString:NSLocalizedString(@"INITIAL-SERVER-URI",nil)];
    NSString    *root_uri = [test_uri host];
    hostReachable = [Reachability reachabilityWithHostName:root_uri];
    [hostReachable startNotifier];
}

/***************************************************************\**
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

/***************************************************************\**
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
        
        [self callInSick];
        }
}

/***************************************************************\**
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

@end
