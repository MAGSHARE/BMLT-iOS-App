//
//  A_BMLT_SearchViewController.m
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

#import "A_BMLT_SearchViewController.h"
#import "BMLTAppDelegate.h"
#import "BMLT_Prefs.h"

static int kSearchAnnotationOffsetRight   = 7;  /**< This is how many pixels to shift the annotation view right. */
static int kSearchAnnotationOffsetUp      = 24;  /**< This is how many pixels to shift the annotation view up. */

/**************************************************************//**
 \class WildcardGestureRecognizer
 \brief This is used to find taps anywhere in the map.
        It is inspired (and cribbed) from here:
        http://stackoverflow.com/questions/1049889/how-to-intercept-touches-events-on-a-mkmapview-or-uiwebview-objects/4064538#4064538
 *****************************************************************/
@implementation WildcardGestureRecognizer
@synthesize myController;

/**************************************************************//**
 \brief Initialize the gesture recognizer.
 \returns self
 *****************************************************************/
-(id) init
{
    self = [super init];
    if ( self )
        {
        [self setCancelsTouchesInView:NO];
        }
    
    return self;
}

/**************************************************************//**
 \brief Called when the touch has completed, and the recognizer has decided it was legit.
 *****************************************************************/
- (void)touchesEnded:(NSSet *)touches   ///< The touches involved. We ignore this.
           withEvent:(UIEvent *)event   ///< The event in question. We use this data.
{
#ifdef DEBUG
    NSLog(@"WildcardGestureRecognizer::touchesEnded: withEvent:%@", [event description]);
#endif
    
    UITouch *viewTouch = (UITouch *)[[event touchesForGestureRecognizer:self] anyObject];
    
    if ( viewTouch )
        {
        MKMapView *myView = (MKMapView *)[self view];
        CGPoint position = [viewTouch locationInView:myView];
        CLLocationCoordinate2D  longLat = [myView convertPoint:position toCoordinateFromView:myView];
        
#ifdef DEBUG
        NSLog(@"WildcardGestureRecognizer::touchesEnded: withEvent: Position of Touch In View: (%f, %f)", position.x, position.y);
        NSLog(@"WildcardGestureRecognizer::touchesEnded: withEvent: Long/Lat of Touch In View: (%f, %f)", longLat.longitude, longLat.latitude);
#endif
        [myController updateMapWithThisLocation:longLat];
        }
}
@end

/**************************************************************//**
 \class BMLT_Search_BlackAnnotationView
 \brief We modify the black annotation view to allow dragging.
 *****************************************************************/
@implementation BMLT_Search_BlackAnnotationView
@synthesize coordinate = _coordinate;                           ///< The annotation/marker coordinate.

/**************************************************************//**
 \brief We simply switch on the draggable bit, here.
 \returns self
 *****************************************************************/
- (id)initWithAnnotation:(id<MKAnnotation>)annotation           ///< The annotation for this marker view
         reuseIdentifier:(NSString *)reuseIdentifier            ///< The Reuse ID
              coordinate:(CLLocationCoordinate2D)inCoordinate   ///< The corrdinate of the annotation.
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];

    if ( self )
        {
        [self setDraggable:YES];
        [self setCoordinate:inCoordinate];
        [self setCenterOffset:CGPointMake(kSearchAnnotationOffsetRight, -kSearchAnnotationOffsetUp)];    // Hardcoded, but the image has a specific point.
        }

    return self;
}

/**************************************************************//**
\brief Ensure the proper image is displayed for dragging.
*****************************************************************/
- (void)selectImage
{
    [self setImage:[UIImage imageNamed:@"MapMarkerBlack.png"]];
}

/**************************************************************//**
 \brief Handles dragging. Changes the image while dragging.
 *****************************************************************/
- (void)setDragState:(MKAnnotationViewDragState)newDragState    ///< The upcoming drag state
            animated:(BOOL)animated                             ///< Whether or not to animate the drag.
{
#ifdef DEBUG
    NSLog(@"BMLT_Search_BlackAnnotationView::setDragState: animated: called.");
#endif
    switch ( newDragState )
    {
        case MKAnnotationViewDragStateStarting:
        [self setImage:[UIImage imageNamed:@"MapMarkerGreen.png"]];
        break;
        
        case MKAnnotationViewDragStateEnding:
        [self setImage:[UIImage imageNamed:@"MapMarkerBlack.png"]];
        break;
    }
    [super setDragState:newDragState animated:animated];
}
@end

/**************************************************************//**
 \class BMLT_Search_MapPointAnnotation
 \brief Handles annotations in the results map.
 *****************************************************************/
@implementation BMLT_Search_MapPointAnnotation
@end

/**************************************************************//**
 \class A_BMLT_SearchViewController
 \brief This class acts as an abstract base for the two search dialogs.
        its only purpose is to handle the interactive map presented in
        the iPad version of the app.
 *****************************************************************/
@implementation A_BMLT_SearchViewController
@synthesize lookupLocationButton;
@synthesize mapSearchView, myMarker;

/**************************************************************//**
 \brief  Called just before the view will appear. We use it to set
         up the map (in an iPad).
 *****************************************************************/
- (void)viewWillAppear:(BOOL)animated   /// YES, if the view will be animated.
{
    [super viewWillAppear:animated];
    [self setUpMap];
    [[BMLTAppDelegate getBMLTAppDelegate] setActiveSearchController:self];
    [mapSearchView setRegion:[mapSearchView regionThatFits:[[BMLTAppDelegate getBMLTAppDelegate] searchMapRegion]]];
    [myMarker setCoordinate:[[BMLTAppDelegate getBMLTAppDelegate] searchMapMarkerLoc]];

    if ( ![BMLTAppDelegate locationServicesAvailable] )
        {
        [[self lookupLocationButton] setEnabled:NO];
        [[self lookupLocationButton] setAlpha:0];
        }
}

/**************************************************************//**
 \brief  If this is an iPad, we'll set up the map.
 *****************************************************************/
- (void)setUpMap
{
    if ( mapSearchView && !myMarker )    // This will be set in the storyboard.
        {
#ifdef DEBUG
        NSLog(@"A_BMLT_SearchViewController setUpIpadMap called (We're an iPad, baby!).");
#endif
        BMLTAppDelegate *myAppDelegate = [BMLTAppDelegate getBMLTAppDelegate];  // Get the app delegate SINGLETON
        
        [mapSearchView setRegion:[mapSearchView regionThatFits:[myAppDelegate searchMapRegion]] animated:YES];
        
        CLLocationCoordinate2D  markerLoc = [myAppDelegate searchMapMarkerLoc];
        
        myMarker = [[BMLT_Search_MapPointAnnotation alloc] initWithCoordinate:markerLoc andMeetings:nil andIndex:0];
        
        [myMarker setTitle:@"Marker"];

        [mapSearchView addAnnotation:myMarker];
        
        [mapSearchView setDelegate:self];
        
        WildcardGestureRecognizer * tapInterceptor = [[WildcardGestureRecognizer alloc] init];
        [tapInterceptor setMyController:self];
        [mapSearchView addGestureRecognizer:tapInterceptor];
        }
}

/**************************************************************//**
 \brief  Updates the map to a new location.
 *****************************************************************/
- (void)updateMapWithThisLocation:(CLLocationCoordinate2D)inCoordinate  ///< The new coordinate for the marker.
{
    if ( mapSearchView && myMarker )
        {
        [myMarker setCoordinate:inCoordinate];
        [mapSearchView setCenterCoordinate:[myMarker coordinate] animated:YES];
        }
    if ( inCoordinate.longitude != 0 || inCoordinate.latitude != 0 )
        {
#ifdef DEBUG
        NSLog(@"A_BMLT_SearchViewController updateMapWithThisLocation set location to: %f, %f", inCoordinate.longitude, inCoordinate.latitude );
#endif
        [[BMLTAppDelegate getBMLTAppDelegate] setSearchMapMarkerLoc:inCoordinate];
        }
#ifdef DEBUG
    else
        {
        NSLog(@"A_BMLT_SearchViewController NULL location!");
        }
#endif
}

/**************************************************************//**
 \brief This function exists only to allow the parser to call it in the main thread.
 *****************************************************************/
- (void)updateMap
{
    CLLocationCoordinate2D  newLoc = [[BMLTAppDelegate getBMLTAppDelegate] searchMapMarkerLoc];
#ifdef DEBUG
    NSLog(@"A_BMLT_SearchViewController updateMap set location to: %f, %f", newLoc.longitude, newLoc.latitude );
#endif
    [self updateMapWithThisLocation:newLoc];
}

/**************************************************************//**
 \brief This returns whatever coordinates are to be used in the next search.
 \returns the long/lat coordinates of the search location.
 *****************************************************************/
- (CLLocationCoordinate2D)getSearchCoordinates
{
#ifdef DEBUG
    NSLog(@"A_BMLT_SearchViewController getSearchCoordinates" );
#endif
    return [[BMLTAppDelegate getBMLTAppDelegate] searchMapMarkerLoc];
}

/**************************************************************//**
 \brief  Look up the user's location.
 *****************************************************************/
- (IBAction)locationButtonPressed:(id)sender    ///< The button object.
{
    [[BMLTAppDelegate getBMLTAppDelegate] lookupMyLocation];
}

#pragma mark - MKMapViewDelegate Functions -
/**************************************************************//**
 \brief Called when the map is moved, scrolled, panned, etc.
 *****************************************************************/
- (void)mapView:(MKMapView *)mapView    ///< The map view
regionDidChangeAnimated:(BOOL)animated  ///< Whether or not the change was animated.
{
#ifdef DEBUG
    NSLog(@"A_BMLT_SearchViewController regionDidChangeAnimated" );
#endif
    [[BMLTAppDelegate getBMLTAppDelegate] setSearchMapRegion:[mapView region]];
}

/**************************************************************//**
 \brief Called when the marker is dragged.
 *****************************************************************/
- (void)mapView:(MKMapView *)mapView                    ///< The map view.
annotationView:(MKAnnotationView *)annotationView       ///< The annotation view.
didChangeDragState:(MKAnnotationViewDragState)newState  ///< The new state of the annotation.
fromOldState:(MKAnnotationViewDragState)oldState        ///< The original state of the annotation.
{
    CLLocationCoordinate2D  markerLoc = [myMarker coordinate];
#ifdef DEBUG
    NSLog(@"A_BMLT_SearchViewController::mapView: annotationView: newState: %d oldState: %d Marker location: (%f, %f).", newState, oldState, markerLoc.longitude, markerLoc.latitude);
#endif
    if ( (newState == MKAnnotationViewDragStateEnding) && (oldState == MKAnnotationViewDragStateStarting) )
        {
#ifdef DEBUG
        NSLog(@"A_BMLT_SearchViewController::mapView: annotationView: Changing Marker Location.");
#endif
        return [[BMLTAppDelegate getBMLTAppDelegate] setSearchMapMarkerLoc:markerLoc];
        }
}

#pragma mark - MkMapAnnotationDelegate Functions -
/**************************************************************//**
 \brief Returns the view for the marker in the center of the map.
 \returns an annotation view, representing the marker.
 *****************************************************************/
- (MKAnnotationView *)mapView:(MKMapView *)mapView              ///< The map view.
            viewForAnnotation:(id < MKAnnotation >)annotation   ///< The annotation view.
{
#ifdef DEBUG
    NSLog(@"A_BMLT_SearchViewController viewForAnnotation called.");
#endif
    static NSString* identifier = @"single_meeting_annotation";
    
    MKAnnotationView* ret = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if ( !ret )
        {
#ifdef DEBUG
        NSLog(@"A_BMLT_SearchViewController mapView: viewForAnnotation:. Creating Black Marker at (%f, %f)", [annotation coordinate].latitude, [annotation coordinate].longitude );
#endif
        ret = [[BMLT_Search_BlackAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier coordinate:[annotation coordinate]];
        }
    
    return ret;
}

@end
