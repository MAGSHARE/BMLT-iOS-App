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

/**************************************************************//**
 \class BMLT_Search_BlackAnnotationView
 \brief We modify the black annotation view to allow dragging.
 *****************************************************************/
@implementation BMLT_Search_BlackAnnotationView
@synthesize coordinate = _coordinate;

/**************************************************************//**
 \brief We simply switch on the draggable bit, here.
 \returns self
 *****************************************************************/
- (id)initWithAnnotation:(id<MKAnnotation>)annotation
         reuseIdentifier:(NSString *)reuseIdentifier
              coordinate:(CLLocationCoordinate2D)inCoordinate
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];

    if ( self )
        {
        [self setDraggable:YES];
        [self setCoordinate:inCoordinate];
        }

    return self;
}

/**************************************************************//**
\brief Ensure the proper image is displayed for dragging.
*****************************************************************/
- (void)selectImage
{
    [self setImage:[UIImage imageNamed:@"SearchMarker.png"]];
    
    CGSize  annotationSize = [[self image] size];
    
    [self setCenterOffset:CGPointMake((annotationSize.width / 2), -(annotationSize.height / 2))];
}

/**************************************************************//**
 \brief Handles dragging. Changes the image while dragging.
 *****************************************************************/
- (void)setDragState:(MKAnnotationViewDragState)newDragState
            animated:(BOOL)animated
{
#ifdef DEBUG
    NSLog(@"BMLT_Search_BlackAnnotationView setDragState called.");
#endif
    switch ( newDragState )
    {
        case MKAnnotationViewDragStateStarting:
        newDragState = MKAnnotationViewDragStateDragging;
        [self setImage:[UIImage imageNamed:@"SearchMarkerSelected.png"]];
        break;
        
        case MKAnnotationViewDragStateEnding:
        newDragState = MKAnnotationViewDragStateNone;
        [self setImage:[UIImage imageNamed:@"SearchMarker.png"]];
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
@synthesize mapSearchView, myMarker, updatedOnce;

/**************************************************************//**
 \brief  Called just before the view will appear. We use it to set
         up the map (in an iPad).
 *****************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setUpMap];
    [[BMLTAppDelegate getBMLTAppDelegate] setActiveSearchController:self];
    [mapSearchView setRegion:[mapSearchView regionThatFits:[[BMLTAppDelegate getBMLTAppDelegate] searchMapRegion]]];
    [myMarker setCoordinate:[[BMLTAppDelegate getBMLTAppDelegate] searchMapMarkerLoc]];
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
        
        myMarker = [[BMLT_Search_MapPointAnnotation alloc] initWithCoordinate:[myAppDelegate searchMapMarkerLoc] andMeetings:nil];
        
        [myMarker setTitle:@"Marker"];
        
        [mapSearchView addAnnotation:myMarker];
        
        [mapSearchView setDelegate:self];
        }
}

/**************************************************************//**
 \brief  Updates the map to a new location.
         The way this works, is we accept only one update. That way,
         the map doesn't keep shifting away as the user chooses a
         search location.
 *****************************************************************/
- (void)updateMapWithThisLocation:(CLLocationCoordinate2D)inCoordinate
{
    if ( mapSearchView && myMarker && ![self updatedOnce] )
        {
        [myMarker setCoordinate:inCoordinate];
        [mapSearchView setCenterCoordinate:[myMarker coordinate] animated:YES];
        [[BMLTAppDelegate getBMLTAppDelegate] setSearchMapMarkerLoc:inCoordinate];
        [self setUpdatedOnce:YES];
        }
}

/**************************************************************//**
 \brief This returns whatever coordinates are to be used in the next search.
 \returns the long/lat coordinates of the search location.
 *****************************************************************/
- (CLLocationCoordinate2D)getSearchCoordinates
{
    return [[BMLTAppDelegate getBMLTAppDelegate] searchMapMarkerLoc];
}

#pragma mark - MKMapViewDelegate Functions -
/**************************************************************//**
 \brief Called when the map is moved, scrolled, panned, etc.
 *****************************************************************/
- (void)mapView:(MKMapView *)mapView    ///< The map view
regionDidChangeAnimated:(BOOL)animated  ///< Whether or not the change was animated.
{
    [[BMLTAppDelegate getBMLTAppDelegate] setSearchMapRegion:[mapView region]];
}

#pragma mark - MkMapAnnotationDelegate Functions -
/**************************************************************//**
 \brief Returns the view for the marker in the center of the map.
 \returns an annotation view, representing the marker.
 *****************************************************************/
- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id < MKAnnotation >)annotation
{
#ifdef DEBUG
    NSLog(@"A_BMLT_SearchViewController viewForAnnotation called.");
#endif
    static NSString* identifier = @"single_meeting_annotation";
    
    MKAnnotationView* ret = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if ( !ret )
        {
        ret = [[BMLT_Search_BlackAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier coordinate:[annotation coordinate]];
        }
    
    return ret;
}

@end
