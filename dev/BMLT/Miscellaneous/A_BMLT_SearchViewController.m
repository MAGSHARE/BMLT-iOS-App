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
 \brief 
 *****************************************************************/
- (void)selectImage
{
    [self setImage:[UIImage imageNamed:@"SearchMarker.png"]];
}

/**************************************************************//**
 \brief Handles dragging.
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
        break;
        
        case MKAnnotationViewDragStateEnding:
        newDragState = MKAnnotationViewDragStateNone;
        break;
    }
    
    self.dragState = newDragState;
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
        
        CLLocationCoordinate2D  center;
#ifdef DEBUG
        NSLog(@"A_BMLT_SearchViewController setUpIpadMap We're using the canned coordinates.");
#endif
        center.latitude = [NSLocalizedString(@"INITIAL-MAP-LAT", nil) doubleValue];
        center.longitude = [NSLocalizedString(@"INITIAL-MAP-LONG", nil) doubleValue];
        
        if ( [myAppDelegate myLocation] )
            {
#ifdef DEBUG
            NSLog(@"A_BMLT_SearchViewController setUpIpadMap We know where we are, so we'll set the map to that.");
#endif
            center = [myAppDelegate myLocation].coordinate;
            }
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, 25000, 25000);
        
        [mapSearchView setRegion:region animated:YES];
        
        myMarker = [[BMLT_Search_MapPointAnnotation alloc] initWithCoordinate:center andMeetings:nil];
        
        [myMarker setTitle:@"Marker"];
        
        [mapSearchView addAnnotation:myMarker];
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
        [self setUpdatedOnce:YES];
        }
}

/**************************************************************//**
 \brief This returns whatever coordinates are to be used in the next search.
 \returns the long/lat coordinates of the search location.
 *****************************************************************/
- (CLLocationCoordinate2D)getSearchCoordinatesAndForceReNew:(BOOL)shouldForce   ///< If this is YES, we don't get the user location from the app delegate, which will force it to look up first.
{
    CLLocationCoordinate2D  ret;
    ret.longitude = ret.latitude = 0.0; // We start off with 0,0.
    
    if (mapSearchView)
        {
        ret = [self getMapCoordinates];
        }
    else if ( !shouldForce )
        {
        ret = [[BMLTAppDelegate getBMLTAppDelegate] myLocation].coordinate;  ///< This is where the user is, according to the app delegate.
        }
    return ret;
}

/**************************************************************//**
 \brief This returns whatever coordinates are indicated by the marker in the map.
 \returns the long/lat coordinates of the map marker.
 *****************************************************************/
- (CLLocationCoordinate2D)getMapCoordinates
{
    CLLocationCoordinate2D  ret;
    
    ret.longitude = 0;
    ret.latitude = 0;
    
    if ( myMarker )
        {
        ret = [myMarker coordinate];
        }
    
    return ret;
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
