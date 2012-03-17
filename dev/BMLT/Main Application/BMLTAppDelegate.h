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

/***************************************************************\**
 \class BMLTAppDelegate
 \brief This is the main application delegate class for the BMLT application
 *****************************************************************/
@interface BMLTAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, CLLocationManagerDelegate>
{
    BOOL            internetActive;     ///< Set to YES, if the network test says that the Internet is available.
    BOOL            hostActive;         ///< Set to YES, if the 
    Reachability    *internetReachable; ///< This handles tests of the network
    Reachability    *hostReachable;     ///< This handles testing for the root server.
}

@property (strong, nonatomic) UIWindow          *window;            ///< This is the main window object (SINGLETON)
@property (strong, nonatomic) CLLocation        *myLocation;        ///< This will contain our location.
@property (strong, nonatomic) CLLocationManager *locationManager;   ///< This will hold our location manager.

+ (BMLTAppDelegate *)getBMLTAppDelegate;    ///< This class method allows access to the application delegate object (SINGLETON)
+ (BOOL)locationServicesAvailable;          ///< Used to check to see if location services are available.
- (BOOL)isLookupValid;                      ///< Returns YES, if the last location lookup is kosher.
- (void)findLocationAndMeetings:(BOOL)findMeetings;  ///< Starts an asynchronous GPS location lookup.
- (void)searchForMeetingsNearMeAllWeek;     ///< Begins a lookup search, in which a location is found first, then all meetings near there are returned.
- (void)verifyConnectivity;                 ///< Start a network test.
- (void)checkNetworkStatus:(NSNotification *)notice;    ///< Gets the results of the network test.
@end
