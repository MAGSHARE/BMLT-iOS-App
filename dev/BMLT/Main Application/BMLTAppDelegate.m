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

static BMLTAppDelegate *g_AppDelegate = nil;

/**********************************************************************************/
/**
 *  \class  BMLTAppDelegate
 *  \brief  This is the main application delegate class for the BMLT application
 */
@implementation BMLTAppDelegate

#pragma mark - Synthesize Class Properties
@synthesize window      = _window;      ///< This will hold the window associated with this application instance.
@synthesize myLocation  = _myLocation;  ///< This will hold the location set by the last location lookup.

#pragma mark - Class Methods
/**********************************************************************************/
/**
 *  \brief  This class method allows access to the application delegate object (SINGLETON)
 */
+ (BMLTAppDelegate *)getBMLTAppDelegate
{
    return g_AppDelegate;
}

#pragma mark - Standard Instance Methods
/**********************************************************************************/
/**
 *  \brief  Initialize the object
 *  \returns    self
 */
- (id) init
{
    self = [super init];
    
    if ( self )
        {
        g_AppDelegate = self;
        }
    
    return self;
}

/**********************************************************************************/
/**
 *  \brief  Called when the app has finished its launch setup.
 *  \returns    a BOOL. The app is go for launch.
 */
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
    [tabController setSelectedIndex:0];
    tabController.delegate = self;
    return YES;
}

/**********************************************************************************/
/**
 *  \brief  Called when the app is about to show up.
 */
- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

#pragma mark - Custom Instance Methods
/**********************************************************************************/
/**
 *  \brief  Returns the location as last set (Does not trigger a new location lookup).
 *  \returns    a pointer to a CLLocation object, containing the stored location.
 */
- (CLLocation *)getWhereImAt
{
    CLLocation  *whereImAt = nil;
    
    return  whereImAt;
}
@end
