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

/**************************************************************//**
 \class BMLT_Search_BlackAnnotationView
 \brief We modify the black annotation view to allow dragging.
 *****************************************************************/
@interface BMLT_Search_BlackAnnotationView : BMLT_Results_BlackAnnotationView

@property (nonatomic,readwrite,assign) CLLocationCoordinate2D   coordinate;

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier coordinate:(CLLocationCoordinate2D)inCoordinate;
@end

/**************************************************************//**
 \class A_BMLT_SearchViewController
 \brief This class acts as an abstract base for the two search dialogs.
 its only purpose is to handle the interactive map presented in
 the iPad version of the app.
 *****************************************************************/
@interface A_BMLT_SearchViewController : A_BMLTNavBarViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapSearchView;  ///< If this is an iPad, then this will point to the map view. iPhone will be nil. The property is linked in the storyboard.
- (void)setUpMap;                                               ///< In the case of this being an iPad, set up the search map.
@end
