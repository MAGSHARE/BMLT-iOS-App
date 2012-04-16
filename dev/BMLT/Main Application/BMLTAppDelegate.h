//
//  BMLTAppDelegate.h
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

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"
#import "BMLT_Driver.h"
#import "BMLT_Meeting_Search.h"
#import <MapKit/MapKit.h>

@class BMLT_Prefs;      ///< Foward decl for the prefs property.
@class BMLT_Meeting;    ///< Forward decl for a meeting.
@class A_BMLT_SearchViewController; ///< This will be for the active search controller.
@class BMLTDisplayListResultsViewController;
@class BMLTMapResultsViewController;
@class BMLTMeetingDetailViewController;
@class BMLTAnimationScreenViewController;

#define kGoogleReverseLooupURI_Format @"http://maps.google.com/maps/geo?q=%@&output=xml&sensor=false"

extern int kAddressLookupTimeoutPeriod_in_seconds;

/**************************************************************//**
 \class BMLTAppDelegate
 \brief This is the main application delegate class for the BMLT application
 *****************************************************************/
@interface BMLTAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, CLLocationManagerDelegate, SearchDelegate, NSXMLParserDelegate>
{
    Reachability    *internetReachable; ///< This handles tests of the network
    Reachability    *hostReachable;     ///< This handles testing for the root server.
}

@property (strong, atomic) CLLocation               *lastLocation;      ///< This will hold the last location for the user (as opposed to the search center). This is used for directions.
@property (strong, nonatomic) UIWindow              *window;            ///< This is the main window object (SINGLETON)
@property (strong, nonatomic) CLLocationManager     *locationManager;   ///< This will hold our location manager.
@property (atomic) BOOL                             internetActive;     ///< Set to YES, if the network test says that the Internet is available.
@property (atomic) BOOL                             hostActive;         ///< Set to YES, if the network test says that the root server is available.
@property (weak, atomic) BMLT_Prefs                 *myPrefs;           ///< This will have a reference to the global prefs object.
@property (strong, nonatomic) NSMutableArray        *searchResults;     ///< This will hold the latest search results.
@property (strong, nonatomic) NSMutableDictionary   *searchParams;      ///< This will hold the parameters to be used for the next search.
@property (strong, nonatomic) NSDictionary          *lastSearchParams;  ///< This will hold the parameters that were used for the last search.
@property (nonatomic, readwrite, assign) A_BMLT_SearchViewController *activeSearchController;    ///< This will point to the active search controller. Nil, if none.
@property (nonatomic, readwrite, assign) MKCoordinateRegion          searchMapRegion;            ///< Used to track the state of the search spec maps.
@property (nonatomic, readwrite, assign) CLLocationCoordinate2D      searchMapMarkerLoc;         ///< This contains the location used for the search marker.
@property (strong, nonatomic) UIViewController                       *searchNavController;       ///< This is the tab controller for all the searches.
@property (strong, nonatomic) BMLTDisplayListResultsViewController   *listResultsViewController; ///< This will point to our list results main controller.
@property (strong, nonatomic) BMLTMapResultsViewController           *mapResultsViewController;  ///< This will point to our map results main controller.
@property (nonatomic, readwrite, retain) BMLTMeetingDetailViewController *reusableMeetingDetails;    ///< This will hold an instance of the meeting details view that we will use over and over.
@property (strong, atomic) BMLTAnimationScreenViewController         *currentAnimation;          ///< This holds the current active animation controller.

/// Class methods
+ (BMLTAppDelegate *)getBMLTAppDelegate;                ///< This class method allows access to the application delegate object (SINGLETON)
+ (BOOL)locationServicesAvailable;                      ///< Used to check to see if location services are available.
+ (BOOL)canReachRootServer;                             ///< Returns YES, if the root server can be reached via network.
+ (void)viewMeetingDetails:(BMLT_Meeting *)inMeeting inContext:(UIViewController *)inController;   ///< Push the meeting details view onto the current nav stack.
+ (NSDate *)getLocalDateAutoreleaseWithGracePeriod:(BOOL)useGracePeriod;    ///< This is used to calculate the time for "later today" meetings.
+ (NSString *)createSearchResultsPDF:(NSArray *)inSearchResults;
+ (NSString *)createWholeSearchPDF;
+ (NSString *)creatingMeetingDetailsPDF:(BMLT_Meeting *)inMeeting;

/// Instance methods
- (void)searchForMeetingsNearMe:(CLLocationCoordinate2D)inMyLocation withParams:(NSDictionary *)params; ///< A lookup search with parameters.
- (void)searchForMeetingsNearMe:(CLLocationCoordinate2D)inMyLocation;                        ///< Begins a lookup search, in which a location is found first, then all meetings near there are returned.
- (void)searchForMeetingsNearMeLaterToday:(CLLocationCoordinate2D)inMyLocation;              ///< Same as above, but only meetings later today.
- (void)searchForMeetingsNearMeTomorrow:(CLLocationCoordinate2D)inMyLocation;                ///< Same as above, but only meetings tomorrow.
- (void)stopNetworkMonitor;                             ///< Stop observing the network connectivity status.
- (void)startNetworkMonitor;                            ///< Start a network test.
- (void)networkStatusCallback:(NSNotification *)notice; ///< Gets the results of the network test.
- (void)setUpTabBarItems;                               ///< Enables and Disables the UITabBar items in accordance with the current state.
- (void)clearAllSearchResults:(BOOL)inForce;            ///< Clears all the search results, and the results views.
- (void)clearAllSearchResultsYes;                       ///< Clears all the search results, and the results views (Shorthand that assumes YES).
- (void)clearAllSearchResultsNo;                        ///< Clears all the search results, and the results views (Shorthand that assumes NO).
- (void)sortMeetingsByWeekdayAndTime;                   ///< Sorts the meeting search results by weekday and time.
- (void)sortMeetingsByDistance;                         ///< Sorts the meeting search results by distance from your location.
- (void)imVisitingRelatives;                            ///< This is called by other instances to prevent the app from having its state changed between calls. It is a "One-shot" operation that loses persistency between calls.
- (void)lookupMyLocation:(BOOL)refreshSearch;           ///< Tells the app to do a CL lookup. The map (if there is one) will be updated when the location is updated.
@end
