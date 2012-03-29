//
//  BMLTMapResultsViewController.m
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

#import "BMLTMapResultsViewController.h"
#import "BMLTAppDelegate.h"
#import "BMLT_Meeting.h"
#import "BMLT_Results_MapPointAnnotationView.h"
#import "BMLTDisplayListResultsViewController.h"

/**************************************************************//**
 \class  BMLTMapResultsViewController -Private Interface
 \brief  This class will control display of mapped results.
 *****************************************************************/
@implementation BMLTMapResultsViewController

#pragma mark - View Lifecycle -
/**************************************************************//**
 \brief 
 *****************************************************************/
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
        {
        [self clearLastRegion];
        }
    return self;
}

/**************************************************************//**
 \brief 
 *****************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ( ![self isMapInitialized] )
        {
        [self determineMapSize:[[BMLTAppDelegate getBMLTAppDelegate] searchResults]];
        [self setMapInit:YES];
        }
}

/**************************************************************//**
 \brief 
 *****************************************************************/
- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - Custom Functions -
/**************************************************************//**
 \brief Accessor -Set the initialization state of the map;
 *****************************************************************/
- (void)setMapInit:(BOOL)isInit
{
    _map_initialized = isInit;
}

/**************************************************************//**
 \brief Accessor -Is the map initialized?
 \returns YES, if the map is new, and needs an initial setup.
 *****************************************************************/
- (BOOL)isMapInitialized
{
    return _map_initialized;
}

/**************************************************************//**
 \brief 
 *****************************************************************/
- (void)displayMapAnnotations:(NSArray *)inResults
{
    [(MKMapView *)[self view] removeAnnotations:[(MKMapView *)[self view] annotations]];
    
    NSArray *annotations = [self mapMeetingAnnotations:inResults];
    
    if ( annotations )
        {
#ifdef DEBUG
        NSLog(@"BMLTMapResultsViewController displayMapAnnotations -Adding %d annotations", [inResults count]);
#endif
        [(MKMapView *)[self view] addAnnotations:annotations];
        }
}

/**************************************************************//**
 \brief 
 *****************************************************************/
- (void)clearLastRegion
{
    lastRegion.center.longitude = lastRegion.center.latitude = 0.0;
    lastRegion.span.latitudeDelta = 0.0;
    lastRegion.span.longitudeDelta = 0.0;
    [self setMapInit:NO];
}

/**************************************************************//**
 \brief 
 *****************************************************************/
- (void)clearMapCompletely
{
    [self clearLastRegion];
    if ( [[(MKMapView *)[self view] annotations] count] )
        {
        [(MKMapView *)[self view] removeAnnotations:[(MKMapView *)[self view] annotations]];
        }
    [self setMapInit:NO];
}

/**************************************************************//**
 \brief 
 *****************************************************************/
- (void)determineMapSize:(NSArray *)inResults
{    
    [self clearLastRegion];
    CLLocationCoordinate2D  northWestCorner;
    CLLocationCoordinate2D  southEastCorner;
    
    northWestCorner = [(BMLT_Meeting *)[inResults objectAtIndex:0] getMeetingLocationCoords].coordinate;
    southEastCorner = [(BMLT_Meeting *)[inResults objectAtIndex:0] getMeetingLocationCoords].coordinate;
    
    for ( BMLT_Meeting *meeting in inResults )
        {
#ifdef DEBUG
        NSLog(@"BMLTMapResultsViewController determineMapSize -Calculating the container, working on meeting \"%@\".", [meeting getBMLTName]);
#endif
        CLLocationCoordinate2D  meetingLocation = [meeting getMeetingLocationCoords].coordinate;
        northWestCorner.longitude = fmin(northWestCorner.longitude, meetingLocation.longitude);
        northWestCorner.latitude = fmax(northWestCorner.latitude, meetingLocation.latitude);
        southEastCorner.longitude = fmax(southEastCorner.longitude, meetingLocation.longitude);
        southEastCorner.latitude = fmin(southEastCorner.latitude, meetingLocation.latitude);
        }
#ifdef DEBUG
    NSLog(@"BMLTMapResultsViewController determineMapSize -The current map area is NW: (%f, %f), SE: (%f, %f)", northWestCorner.longitude, northWestCorner.latitude, southEastCorner.longitude, southEastCorner.latitude );
#endif
    
    // OK. We now know how much room we need. Let's make sure that the map can accommodate all the points.
    double  longSpan = southEastCorner.longitude - northWestCorner.longitude;
    double  latSpan = northWestCorner.latitude - southEastCorner.latitude;
    CLLocationCoordinate2D  center;
    center.latitude = (northWestCorner.latitude + southEastCorner.latitude) / 2.0;
    center.longitude = (southEastCorner.longitude + northWestCorner.longitude) / 2.0;
    MKCoordinateSpan    mapSpan = MKCoordinateSpanMake(latSpan * 1.2, longSpan * 1.2);  // Slight expansion to give us "padding."
    MKCoordinateRegion  mapMap = MKCoordinateRegionMake ( center, mapSpan );
    
    [(MKMapView *)[self view] setRegion:mapMap animated:NO];
    [self displayMapAnnotations:inResults];
}

/**************************************************************//**
 \brief 
 \returns 
 *****************************************************************/
- (NSArray *)mapMeetingAnnotations:(NSArray *)inResults
{
#ifdef DEBUG
    NSLog(@"BMLTMapResultsViewController mapMeetingAnnotations - Checking %d Meetings.", [inResults count]);
#endif
    NSMutableArray  *ret = nil;
    
    if ( [inResults count] )
        {
        NSMutableArray  *points = [[NSMutableArray alloc] init];
        for ( BMLT_Meeting *meeting in inResults )
            {
#ifdef DEBUG
            NSLog(@"BMLTMapResultsViewController mapMeetingAnnotations - Checking Meeting \"%@\".", [meeting getBMLTName]);
#endif
            CLLocationCoordinate2D  meetingLocation = [meeting getMeetingLocationCoords].coordinate;
            CGPoint meetingPoint = [(MKMapView *)[self view] convertCoordinate:meetingLocation toPointToView:nil];
            CGRect  hitTestRect = CGRectMake(meetingPoint.x - BMLT_Meeting_Distance_Threshold_In_Pixels,
                                             meetingPoint.y - BMLT_Meeting_Distance_Threshold_In_Pixels,
                                             BMLT_Meeting_Distance_Threshold_In_Pixels * 2,
                                             BMLT_Meeting_Distance_Threshold_In_Pixels * 2);
            
            BMLT_Results_MapPointAnnotation *annotation = nil;
#ifdef DEBUG
            NSLog(@"BMLTMapResultsViewController mapMeetingAnnotations - Meeting \"%@\" Has the Following Hit Test Rect: (%f, %f), (%f, %f).", [meeting getBMLTName], hitTestRect.origin.x, hitTestRect.origin.y, hitTestRect.size.width, hitTestRect.size.height);
#endif
            
            for ( BMLT_Results_MapPointAnnotation *annotationTemp in points )
                {
                CGPoint annotationPoint = [(MKMapView *)[self view] convertCoordinate:annotationTemp.coordinate toPointToView:nil];
#ifdef DEBUG
                NSLog(@"BMLTMapResultsViewController mapMeetingAnnotations - Comparing the Following Annotation Point: (%f, %f).", annotationPoint.x, annotationPoint.y);
#endif
                
                if ( !([[annotationTemp getMyMeetings] containsObject:meeting]) && CGRectContainsPoint(hitTestRect, annotationPoint) )
                    {
#ifdef DEBUG
                    for ( BMLT_Meeting *t_meeting in [annotationTemp getMyMeetings] )
                        {
                        NSLog(@"BMLTMapResultsViewController mapMeetingAnnotations - Meeting \"%@\" Is Close to \"%@\".", [meeting getBMLTName], [t_meeting getBMLTName]);
                        }
#endif
                    annotation = annotationTemp;
                    }
                }
            
            if ( !annotation )
                {
#ifdef DEBUG
                NSLog(@"BMLTMapResultsViewController mapMeetingAnnotations -This meeting gets its own annotation.");
#endif
                NSArray *meetingsAr = [[NSArray alloc] initWithObjects:meeting, nil];  
                annotation = [[BMLT_Results_MapPointAnnotation alloc] initWithCoordinate:[meeting getMeetingLocationCoords].coordinate andMeetings:meetingsAr];
                [points addObject:annotation];
                }
            else
                {
#ifdef DEBUG
                NSLog(@"BMLTMapResultsViewController mapMeetingAnnotations -This meeting gets lumped in with others.");
#endif
                [annotation addMeeting:meeting];
                }
            
            if ( annotation )
                {
                if ( !ret )
                    {
                    ret = [[NSMutableArray alloc] init];
                    }
                
                if ( ![ret containsObject:annotation] )
                    {
                    [ret addObject:annotation];
                    }
                }
            }
        }
    
    CLLocationCoordinate2D lastLookup = [[BMLTAppDelegate getBMLTAppDelegate] myLocation].coordinate;
    
    if ( [ret count] && lastLookup.longitude && lastLookup.latitude )
        {
        BMLT_Results_MapPointAnnotation *annotation = [[BMLT_Results_MapPointAnnotation alloc] initWithCoordinate:lastLookup andMeetings:nil];
        
        if ( annotation )
            {
            [annotation setTitle:NSLocalizedString(@"BLACK-MARKER-TITLE", nil)];
            [ret addObject:annotation];
            }
        }
    
    return ret;
}

/**************************************************************//**
 \brief 
 *****************************************************************/
- (void)displayAllMarkersIfNeeded
{
    if ( (ABS(lastRegion.span.latitudeDelta - [(MKMapView *)[self view] region].span.latitudeDelta) > (ABS(lastRegion.span.latitudeDelta) * 0.01))
        || (ABS(lastRegion.span.longitudeDelta - [(MKMapView *)[self view] region].span.longitudeDelta) > (ABS(lastRegion.span.longitudeDelta) * 0.01)) )
        {
#ifdef DEBUG
        NSLog(@"BMLTMapResultsViewController mapView:displayAllMarkersIfNeeded -Redrawing Markers, Based on a Delta of (%f, %f).", lastRegion.span.latitudeDelta - [(MKMapView *)[self view] region].span.latitudeDelta, lastRegion.span.longitudeDelta - [(MKMapView *)[self view] region].span.longitudeDelta);
#endif
        [self displayMapAnnotations:[[BMLTAppDelegate getBMLTAppDelegate] searchResults]];
        }
#ifdef DEBUG
    else
        {
        NSLog(@"BMLTMapResultsViewController mapView:displayAllMarkersIfNeeded -Not Redrawing Markers, Delta of (%f, %f) is too small.", lastRegion.span.latitudeDelta - [(MKMapView *)[self view] region].span.latitudeDelta, lastRegion.span.longitudeDelta - [(MKMapView *)[self view] region].span.longitudeDelta);
        }
#endif
    lastRegion = [(MKMapView *)[self view] region];
}

/**************************************************************//**
 \brief 
 *****************************************************************/
- (void)viewMeetingDetails:(BMLT_Meeting *)inMeeting
{
}

/**************************************************************//**
 \brief 
 *****************************************************************/
- (void)viewMeetingList:(NSArray *)inList
{
    UIStoryboard    *st = [self storyboard];
    
    UIViewController    *newController = [st instantiateViewControllerWithIdentifier:@"list-view-results"];
    
    [(BMLTDisplayListResultsViewController *)newController setDataArrayFromData:inList];

    [[self navigationController] pushViewController:newController animated:YES];
}

#pragma mark - MKMapViewDelegate Functions -

/**************************************************************//**
 \brief 
 \returns 
 *****************************************************************/
- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView* ret = nil;
    
    if ( mapView && ([mapView alpha] == 1) )
        {
        if ( [annotation isKindOfClass:[BMLT_Results_MapPointAnnotation class]] )
            {
            if ( [(BMLT_Results_MapPointAnnotation *)annotation getNumberOfMeetings] )
                {
#ifdef DEBUG
                NSLog(@"BMLTMapResultsViewController mapView:viewForAnnotation -Annotation Selected. This annotation contains %d meetings.", [(BMLT_Results_MapPointAnnotation *)annotation getNumberOfMeetings]);
#endif
                ret = [[BMLT_Results_MapPointAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Map_Annot"];
                }
            else
                {
#ifdef DEBUG
                NSLog(@"BMLTMapResultsViewController mapView:viewForAnnotation -Black Center Annotation.");
#endif
                ret = [[BMLT_Results_BlackAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Center_Annot"];
                
                [ret setCanShowCallout:YES];
                }
            }
        }
    return ret;
}

/**************************************************************//**
 \brief 
 *****************************************************************/
- (void)mapView:(MKMapView *)mapView
regionDidChangeAnimated:(BOOL)animated
{
    if ( mapView && ([mapView alpha] == 1) )
        {
        [self displayAllMarkersIfNeeded];
        }
}

/**************************************************************//**
 \brief 
 *****************************************************************/
- (void)mapView:(MKMapView *)mapView
didSelectAnnotationView:(MKAnnotationView *)view
{
    if ( mapView && ([mapView alpha] == 1) )
        {
        id<MKAnnotation>    annotation = [view annotation];
        
        if ( [annotation isKindOfClass:[BMLT_Results_MapPointAnnotation class]] && [(BMLT_Results_MapPointAnnotation *)annotation getNumberOfMeetings] )
            {
            BMLT_Results_MapPointAnnotation *theAnnotation = (BMLT_Results_MapPointAnnotation *)annotation;
#ifdef DEBUG
            NSLog(@"BMLTMapResultsViewController mapView:didSelectAnnotationView -Annotation Selected. This annotation contains %d meetings.", [theAnnotation getNumberOfMeetings]);
            if ( [theAnnotation getNumberOfMeetings] == 1 )
                {
                BMLT_Meeting    *firstMeeting = [theAnnotation getMeetingAtIndex:0];
                NSLog(@"BMLTMapResultsViewController mapView:didSelectAnnotationView -Displaying details for \"%@\".", [firstMeeting getBMLTName]);
                }
            else
                {
                NSLog(@"BMLTMapResultsViewController mapView:didSelectAnnotationView -Displaying a list of %d meetings.", [theAnnotation getNumberOfMeetings]);
                }
#endif
            NSArray *theMeetings = [theAnnotation getMyMeetings];
            
            if ( [theAnnotation getNumberOfMeetings] > 1 )
                {
                [self viewMeetingList:theMeetings];
                }
            else
                {
                if ( [theAnnotation getNumberOfMeetings] == 1 )
                    {
                    [self viewMeetingDetails:[theMeetings objectAtIndex:0]];
                    }
                }
            
            [mapView deselectAnnotation:annotation animated:NO];
            }
        }
}@end
