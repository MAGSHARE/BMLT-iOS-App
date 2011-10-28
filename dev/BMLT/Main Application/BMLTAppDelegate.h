//
//  BMLTAppDelegate.h
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

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BMLT_Driver.h"
#import "BMLT_Meeting_Search.h"
#import "MapViewController.h"
#import "ListViewController.h"
#import "SpecifyNewSearchViewController.h"
#import "PrefsViewController.h"

#define kGoogleReverseLooupURI_Format @"http://maps.google.com/maps/geo?q=%@&output=xml&sensor=false"
#define kAddressLookupTimeoutPeriod_in_seconds  10

@interface BMLTAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, CLLocationManagerDelegate, NSXMLParserDelegate>
{
    BMLT_Driver                         *bmlt_driver;
    BMLT_Meeting_Search                 *mySearch;
    
    UITabBarController                  *tabBarController;
    UIBarButtonItem                     *newSearchButton_list;
    UIBarButtonItem                     *newSearchButton_map;
    
    UINavigationController              *mapSearchController;
    UINavigationController              *listSearchController;
    PrefsViewController                 *prefsController;
    CLLocationManager                   *locationManager;
    ListViewController                  *myListViewController;
    MapViewController                   *myMapViewController;
    CLLocation                          *whereImAt;
    NSArray                             *searchResults;
    BOOL                                listNeedsRefresh;
    BOOL                                mapNeedsRefresh;
    CLLocationCoordinate2D              lastLookup;
    NSString                            *currentElement;
    BOOL                                visitingMAGSHARE;
    BOOL                                openSearch;
}
@property (nonatomic, retain) IBOutlet UIWindow *window;

+ (void)lookupLocationFromAddressString:(NSString *)inLocationString;
+ (CLLocationCoordinate2D)getLastLookup;
+ (BMLTAppDelegate *)getBMLTAppDelegate;
+ (void)imVisitingMAGSHARE;
+ (NSDate *)getLocalDateAutoreleaseWithGracePeriod:(BOOL)useGracePeriod;
- (void)setVisitingMAGSHARE;
- (IBAction)swipeFromList:(UIGestureRecognizer *)sender;
- (IBAction)swipeFromMapToList:(UIGestureRecognizer *)sender;
- (IBAction)swipeFromMapToPrefs:(UIGestureRecognizer *)sender;
- (IBAction)swipeFromPrefs:(UIGestureRecognizer *)sender;
- (BOOL)listNeedsRefresh;
- (BOOL)mapNeedsRefresh;
- (BOOL)isLookupValid;
- (CLLocationCoordinate2D)lastLookup;
- (void)clearLastLookup;
- (void)clearListNeedsRefresh;
- (void)clearMapNeedsRefresh;
- (void)clearSearch;
- (void)resetNavigationControllers;
- (void)setSearchResults:(NSArray *)inResults;
- (NSArray *)getSearchResults;
- (BMLT_Meeting_Search *)getMeetingSearch:(BOOL)createIfNotAlreadyThere withParams:(NSDictionary *)inSearchParams;
- (void)deleteMeetingSearch;
- (CLLocation *)getWhereImAt;
- (void)engageNewSearch:(BOOL)isMap;
- (void)disableListNewSearch;
- (void)disableMapNewSearch;
- (void)validateSearches;
- (void)findLocation;
- (void)transitionBetweenThisView:(UIView *)srcView andThisView:(UIView *)dstView;
- (void)sortMeetingsByWeekdayAndTime;
- (void)sortMeetingsByDistance;
- (UITabBarController *)tabBarController;
NSInteger timeSort (id meeting1, id meeting2, void *context);
NSInteger distanceSort (id meeting1, id meeting2, void *context);
@end
