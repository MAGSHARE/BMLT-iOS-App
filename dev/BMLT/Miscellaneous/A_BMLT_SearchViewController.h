//
//  A_BMLT_SearchViewController.h
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

#import <UIKit/UIKit.h>
#import "A_BMLTNavBarViewController.h"
#import "BMLT_Results_MapPointAnnotationView.h"
#import <MapKit/MapKit.h>

@class A_BMLT_SearchViewController; ///< Forward declaration for the gesture recognizer.

/**************************************************************//**
 \class WildcardGestureRecognizer
 \brief This is used to find taps anywhere in the map.
        It is inspired (and cribbed) from here:
        http://stackoverflow.com/questions/1049889/how-to-intercept-touches-events-on-a-mkmapview-or-uiwebview-objects/4064538#4064538
 *****************************************************************/
@interface WildcardGestureRecognizer : UIGestureRecognizer
    @property (atomic, assign) A_BMLT_SearchViewController  *myController;  ///< This will hold the view controller that we'll use to update.
@end

/**************************************************************//**
 \class BMLT_Search_BlackAnnotationView
 \brief We modify the black annotation view to allow dragging.
 *****************************************************************/
@interface BMLT_Search_BlackAnnotationView : BMLT_Results_BlackAnnotationView
    @property (atomic,readwrite,assign) CLLocationCoordinate2D   coordinate;

    - (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier coordinate:(CLLocationCoordinate2D)inCoordinate;
@end

/**************************************************************//**
 \class A_BMLT_SearchViewController
 \brief This class acts as an abstract base for the two search dialogs.
 its only purpose is to handle the interactive map presented in
 the iPad version of the app.
 *****************************************************************/
@interface A_BMLT_SearchViewController : A_BMLTNavBarViewController <MKMapViewDelegate>
    @property (strong, atomic, readwrite) BMLT_Results_MapPointAnnotation  *myMarker;    ///< This holds the marker in the search location map.
    @property (weak, atomic, readwrite) IBOutlet MKMapView  *mapSearchView;             ///< If this is an iPad, then this will point to the map view. iPhone will be nil. The property is linked in the storyboard.
    @property (weak, atomic, readwrite) IBOutlet UIButton   *lookupLocationButton;        ///< This will be for a button that allows the user to re-establish their location.

    - (void)addToggleMapButton;                                     ///< Adds a "toggle" button to the navbar.
    - (CLLocationCoordinate2D)getSearchCoordinates;                 ///< This returns whatever coordinates are to be used in the next search.
    - (void)setUpMap;                                               ///< In the case of this being an iPad, set up the search map.
    - (void)updateMapWithThisLocation:(CLLocationCoordinate2D)inCoordinate; ///< Updates the map to a new location.
    - (void)updateMap;                                              ///< Same as above, but for being called in the main thread.
    - (IBAction)locationButtonPressed:(id)sender;                   ///< Causes the app. delegate to look up the user's location again.
    - (IBAction)toggleMapView:(id)sender;                               ///< Toggles the map between satellite and map.
@end
