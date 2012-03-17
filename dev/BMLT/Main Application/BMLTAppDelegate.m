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

static BMLTAppDelegate *g_AppDelegate = nil;

@interface BMLTAppDelegate ()
{
    BOOL    _findMeetings;   ///< If this is YES, then a meeting search will be done.
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
+(BOOL)locationServicesAvailable
{
    return [CLLocationManager locationServicesEnabled] != NO && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied;
}

#pragma mark - Standard Instance Methods
/***************************************************************\**
 \brief  Initialize the object
 \returns    self
 *****************************************************************/
- (id) init
{
    self = [super init];
    
    if ( self )
        {
        g_AppDelegate = self;
        }
    
    return self;
}

/***************************************************************\**\brief  Called when the app has finished its launch setup.
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
 \brief  Called when the app is about to show up.
 *****************************************************************/
- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

/***************************************************************\**
 \brief Begins a lookup search, in which a location is found first,
        then all meetings near there are returned.
 *****************************************************************/
- (void)searchForMeetingsNearMeAllWeek
{
    [self findLocationAndMeetings:YES];
}

#pragma mark - Custom Instance Methods
/***************************************************************\**
 \brief Starts an asynchronous Location Manager update process.
        If the findMeetings flag is YES, then a locale-based meeting
        search will take place after the location lookup.
 *****************************************************************/
- (void)findLocationAndMeetings:(BOOL)findMeetings
{
#ifdef DEBUG
    NSLog(@"BMLTAppDelegate findLocation Where the hell am I?");
#endif
    [self setMyLocation:nil];
    _findMeetings = NO;
    
    if ( !locationManager )
        {
        locationManager = [[CLLocationManager alloc] init];
        }
    
    if ( locationManager )
        {
        [locationManager setDelegate:nil];
        [locationManager setDistanceFilter:kCLDistanceFilterNone];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [locationManager setDelegate:self];
        [locationManager startUpdatingLocation];
        _findMeetings = findMeetings;
        }
    else
        {
        [locationManager stopUpdatingLocation];
        }
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
    
    [locationManager stopUpdatingLocation];
    
#ifdef DEBUG
    NSLog(@"BMLTAppDelegate didUpdateToLocation I'm at (%f, %f), the horizontal accuracy is %f, and the time interval is %d.", newLocation.coordinate.longitude, newLocation.coordinate.latitude, newLocation.horizontalAccuracy, t);
#endif
    [self setMyLocation:newLocation];
}

/***************************************************************\**
 \brief This method starts an asynchronous test of the network,
        ensuring that 
 *****************************************************************/
- (void)verifyConnectivity
{
#ifdef DEBUG
    NSLog(@"Verifying the network status.");
#endif
    internetActive = NO;
    hostActive = NO;
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    [internetReachable stopNotifier];
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    [hostReachable stopNotifier];
    // check if a pathway to our root server exists
    NSURL       *test_uri = [NSURL URLWithString:NSLocalizedString(@"INITIAL-SERVER-URI",nil)];
    NSString    *root_uri = [test_uri host];
    hostReachable = [Reachability reachabilityWithHostName:root_uri];
    [hostReachable startNotifier];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    switch ([internetReachable currentReachabilityStatus])
        {
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
        case NotReachable:
            {
#ifdef DEBUG
            NSLog(@"A gateway to the host server is down.");
#endif
            hostActive = NO;
            
            break;
            }
        
        case ReachableViaWiFi:
            {
#ifdef DEBUG
            NSLog(@"A gateway to the host server is working via WIFI.");
#endif
            hostActive = YES;
            
            break;
            }
        
        case ReachableViaWWAN:
            {
#ifdef DEBUG
            NSLog(@"A gateway to the host server is working via WWAN.");
#endif
            hostActive = YES;
            
            break;
            }
        }
    
    NSArray *validServers = [BMLT_Driver getValidServers];
    
    if ( (!validServers || (0 == [validServers count])) && hostActive && internetActive )
        {
#ifdef DEBUG
        NSLog(@"The network connection is fine, and we don't have valid servers, so we'll set up the server.");
#endif
        [BMLT_Driver setUpServers];
        }
    else if ((!hostActive || !internetActive) && validServers && [validServers count])
        {
#ifdef DEBUG
        NSLog(@"The network connection is not usable, so we'll make sure we delete our servers.");
#endif
        NSInteger num_servers = [validServers count];
        
        for ( NSInteger c = num_servers; 0 < c; c-- )
            {
            BMLT_Server *sv = (BMLT_Server*)[validServers objectAtIndex:c - 1];
            
            if ( sv )
                {
                [[BMLT_Driver getBMLT_Driver] removeServerObject:sv];
                }
            }
        }
    
    if (!hostActive || !internetActive)
        {
        }
    else
        {
        }
}

@end
