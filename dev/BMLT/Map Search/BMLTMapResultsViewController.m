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

#import "BMLTMapResultsViewController.h"
#import "BMLTAppDelegate.h"
#import "BMLT_Meeting.h"
#import "BMLT_Results_MapPointAnnotationView.h"
#import "BMLTDisplayListResultsViewController.h"
#import "BMLT_ListPrintPageRenderer.h"

static int  BMLT_Meeting_Distance_Threshold_In_Pixels = 12; ///< The minimum distance apart for map annotations, before they are combined.

/**************************************************************//**
 \class  BMLTMapResultsViewController -Private Interface
 \brief  This class will control display of mapped results.
 *****************************************************************/
@interface BMLTMapResultsViewController ()
{
    BOOL                _map_initialized;
    BMLT_Results_MapPointAnnotation *_selectedAnnotation;   ///< Holds the currently selected annotation.
    IBOutlet MKMapView  *meetingMapView;
    MKCoordinateRegion  lastRegion;
    UIPopoverController *listPopover;   ///< This will handle the list view in a popover.
}
@end

/**************************************************************//**
 \class  BMLTMapResultsViewController -Implementation
 \brief  This class will control display of mapped results.
 *****************************************************************/
@implementation BMLTMapResultsViewController

#pragma mark - View Lifecycle -
/**************************************************************//**
 \brief Initializer (with coder, because it comes from the storyboard).
 \returns self
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
 \brief Called when the view is about to be drawn.
 *****************************************************************/
- (void)viewWillAppear:(BOOL)animated   ///< YES, if the appearance will be animated.
{
    [super viewWillAppear:animated];
    if ( ![self isMapInitialized] )
        {
        [self determineMapSize:[self dataArray]];
        [self setMapInit:YES];
        }
}

/**************************************************************//**
 \brief Called after the view has been drawn.
 *****************************************************************/
- (void)viewDidAppear:(BOOL)animated   ///< YES, if the appearance was animated.
{
    [super viewDidAppear:animated];
    [self dismissListPopover];      ///< This deselects any selected annotations.
}

/**************************************************************//**
 \brief Called when the view is about to unload.
 *****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setMyModalController:self];
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
 \brief This draws annotations for the meetings passed in.
 *****************************************************************/
- (void)displayMapAnnotations:(NSArray *)inResults  ///< This is an NSArray of BMLT_Meeting objects. Each one represents a meeting.
{
    // First, clear out all the old annotations (there shouldn't be any).
    [(MKMapView *)[self view] removeAnnotations:[(MKMapView *)[self view] annotations]];
    
    // This function looks for meetings in close proximity to each other, and collects them into "red markers."
    NSArray *annotations = [self mapMeetingAnnotations:inResults];
    
    if ( annotations )  // If we have annotations, we draw them.
        {
#ifdef DEBUG
        NSLog(@"BMLTMapResultsViewController displayMapAnnotations -Adding %d annotations", [inResults count]);
#endif
        [(MKMapView *)[self view] addAnnotations:annotations];
        }
}

/**************************************************************//**
 \brief This simply clears our cached position (which we use to
        calculate the necessity for a redraw).
 *****************************************************************/
- (void)clearLastRegion
{
    lastRegion.center.longitude = lastRegion.center.latitude = 0.0;
    lastRegion.span.latitudeDelta = 0.0;
    lastRegion.span.longitudeDelta = 0.0;
    [self setMapInit:NO];
}

/**************************************************************//**
 \brief This wipes out everything.
 *****************************************************************/
- (void)clearMapCompletely
{
    [self clearLastRegion];
    if ( [[(MKMapView *)[self view] annotations] count] )
        {
        [(MKMapView *)[self view] removeAnnotations:[(MKMapView *)[self view] annotations]];
        }
    [self setDataArrayFromData:nil];
    [self setMapInit:NO];
}

/**************************************************************//**
 \brief This scans through the list of meetings, and will produce
        a region that encompasses them all. It then scales the
        map to cover that region.
 *****************************************************************/
- (void)determineMapSize:(NSArray *)inResults   ///< This is an NSArray of BMLT_Meeting objects. Each one represents a meeting.
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
    // We include the user location in the map.
    CLLocationCoordinate2D lastLookup = [[BMLTAppDelegate getBMLTAppDelegate] searchMapMarkerLoc];
    
    if ( lastLookup.longitude && lastLookup.latitude )
        {
        northWestCorner.longitude = fmin(northWestCorner.longitude, lastLookup.longitude);
        northWestCorner.latitude = fmax(northWestCorner.latitude, lastLookup.latitude);
        southEastCorner.longitude = fmax(southEastCorner.longitude, lastLookup.longitude);
        southEastCorner.latitude = fmin(southEastCorner.latitude, lastLookup.latitude);
        }
    
    // OK. We now know how much room we need. Let's make sure that the map can accommodate all the points.
    double  longSpan = (southEastCorner.longitude - northWestCorner.longitude) * 1.2;   // The 1.2 is to add some extra padding, to make sure that the markers get drawn.
    double  latSpan = (northWestCorner.latitude - southEastCorner.latitude) * 1.2;
    CLLocationCoordinate2D  center = CLLocationCoordinate2DMake((northWestCorner.latitude + southEastCorner.latitude) / 2.0, (southEastCorner.longitude + northWestCorner.longitude) / 2.0);
    MKCoordinateRegion  mapMap = MKCoordinateRegionMake ( center, MKCoordinateSpanMake(latSpan, longSpan) );
    
    [(MKMapView *)[self view] setRegion:[(MKMapView *)[self view] regionThatFits:mapMap] animated:NO];
    [self displayMapAnnotations:inResults];
}

/**************************************************************//**
 \brief This function looks for meetings in close proximity to each
        other, and collects them into "red markers."
 \returns an NSArray of BMLT_Results_MapPointAnnotation objects.
 *****************************************************************/
- (NSArray *)mapMeetingAnnotations:(NSArray *)inResults ///< This is an NSArray of BMLT_Meeting objects. Each one represents a meeting.
{
#ifdef DEBUG
    NSLog(@"BMLTMapResultsViewController mapMeetingAnnotations - Checking %d Meetings.", [inResults count]);
#endif
    NSMutableArray  *ret = nil;
    
    NSInteger   displayIndex = 1;
    
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
                annotation = [[BMLT_Results_MapPointAnnotation alloc] initWithCoordinate:[meeting getMeetingLocationCoords].coordinate andMeetings:meetingsAr andIndex:0];
                [annotation setDisplayIndex:displayIndex++];
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
    
    // This is the black marker.
    BMLT_Results_MapPointAnnotation *annotation = [[BMLT_Results_MapPointAnnotation alloc] initWithCoordinate:[[BMLTAppDelegate getBMLTAppDelegate] searchMapMarkerLoc] andMeetings:nil andIndex:0];
    
    if ( annotation )
        {
        [annotation setTitle:NSLocalizedString(@"BLACK-MARKER-TITLE", nil)];
        [ret addObject:annotation];
        }
    
    return ret;
}

/**************************************************************//**
 \brief This checks the cached location, to see if we have strayed
        far enough to warrant a redraw of the annotations.
 *****************************************************************/
- (void)displayAllMarkersIfNeeded
{
    if ( (ABS(lastRegion.span.latitudeDelta - [(MKMapView *)[self view] region].span.latitudeDelta) > (ABS(lastRegion.span.latitudeDelta) * 0.01))
        || (ABS(lastRegion.span.longitudeDelta - [(MKMapView *)[self view] region].span.longitudeDelta) > (ABS(lastRegion.span.longitudeDelta) * 0.01)) )
        {
#ifdef DEBUG
        NSLog(@"BMLTMapResultsViewController mapView:displayAllMarkersIfNeeded -Redrawing Markers, Based on a Delta of (%f, %f).", lastRegion.span.latitudeDelta - [(MKMapView *)[self view] region].span.latitudeDelta, lastRegion.span.longitudeDelta - [(MKMapView *)[self view] region].span.longitudeDelta);
#endif
        [self displayMapAnnotations: [self dataArray]];
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
 \brief This displays a list of meetings (for a red marker).
        It will use a popover for iPad.
 *****************************************************************/
- (void)viewMeetingList:(NSArray *)inList   ///< This is an NSArray of BMLT_Meeting objects. Each one represents a meeting.
                 atRect:(CGRect)selectRect  ///< The rect for the marker.
                 inView:(UIView *)inContext ///< The context for the display.
{
    UIStoryboard    *st = [self storyboard];
    
    UIViewController    *newController = [st instantiateViewControllerWithIdentifier:@"list-view-results"];
    
    [(BMLTDisplayListResultsViewController *)newController setDataArrayFromData:inList];
    [(BMLTDisplayListResultsViewController *)newController setMyModalController:self];

    if ( ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) )
        {
        listPopover = [[UIPopoverController alloc] initWithContentViewController:newController];
        
        [listPopover setDelegate:self];
        
        selectRect.size.width -= (kRegularAnnotationOffsetRight * 2);   // This just makes sure that the popover appears over the annotation exactly.
        
        [listPopover presentPopoverFromRect:selectRect
                                       inView:inContext
                     permittedArrowDirections:UIPopoverArrowDirectionAny
                                     animated:YES];
        }
    else
        {
        [[self navigationController] pushViewController:newController animated:YES];
        }
}

/**************************************************************//**
 \brief Cleans up when the popover is closed. Closes the popover, if necessary.
 *****************************************************************/
- (void)dismissListPopover
{
    if (listPopover)
        {
        [listPopover dismissPopoverAnimated:YES];
        listPopover = nil;
        }
    
    [_selectedAnnotation setIsSelected:NO];
    [(BMLT_Results_MapPointAnnotationView *)[(MKMapView *)[self view] viewForAnnotation:_selectedAnnotation] selectImage];
    _selectedAnnotation = nil;
}

/**************************************************************//**
 \brief Instantiates and returns the appropriate page renderer
 \returns an instance of BMLT_MapPrintPageRenderer, disguised as a UIPrintPageRenderer
 *****************************************************************/
- (UIPrintPageRenderer *)getMyPageRenderer
{
    return [[BMLT_ListPrintPageRenderer alloc] initWithMeetings:[self dataArray] andMapFormatter:[[self view] viewPrintFormatter]];
}

#pragma mark - UIPopoverControllerDelegate Functions -

/**************************************************************//**
 \brief Called when the popover closes.
 *****************************************************************/
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [_selectedAnnotation setIsSelected:NO];
    [(BMLT_Results_MapPointAnnotationView *)[(MKMapView *)[self view] viewForAnnotation:_selectedAnnotation] selectImage];
    _selectedAnnotation = nil;
}

#pragma mark - MKMapViewDelegate Functions -

/**************************************************************//**
 \brief Returns the marker/annotation view to be displayed in the map view.
 \returns the annotation view requested.
 *****************************************************************/
- (MKAnnotationView *)mapView:(MKMapView *)mapView          ///< The map view
            viewForAnnotation:(id<MKAnnotation>)annotation  ///< The annotation controller that we'll return the view for.
{
    MKAnnotationView* ret = nil;
    
    if ( mapView && ([mapView alpha] == 1) )    // We have to have a map, and it needs to be visible, or no annotations.
        {
        if ( [annotation isKindOfClass:[BMLT_Results_MapPointAnnotation class]] )
            {
            if ( [(BMLT_Results_MapPointAnnotation *)annotation getNumberOfMeetings] )
                {
#ifdef DEBUG
                NSLog(@"BMLTMapResultsViewController mapView:viewForAnnotation -Annotation Selected. This annotation contains %d meetings.", [(BMLT_Results_MapPointAnnotation *)annotation getNumberOfMeetings]);
#endif
                // What we do here, is associate an index number for each meeting in the list, so it matches to the displayed meeting annotation. This is used in printing.
                for ( BMLT_Meeting *theMeeting in [(BMLT_Results_MapPointAnnotation *)annotation getMyMeetings] )
                    {
                    [theMeeting setMeetingIndex:[(BMLT_Results_MapPointAnnotation *)annotation displayIndex]];
                    [theMeeting setPartOfMulti:[(BMLT_Results_MapPointAnnotation *)annotation getNumberOfMeetings] > 1];
                    }
                
                ret = [[BMLT_Results_MapPointAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Map_Annot"];
                }
            else
                {
#ifdef DEBUG
                NSLog(@"BMLTMapResultsViewController mapView:viewForAnnotation -Black Center Annotation.");
#endif
                ret = [[BMLT_Results_BlackAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Search_Location_Annot"];
                
                [ret setCanShowCallout:YES];
                }
            }
        }
    return ret;
}

/**************************************************************//**
 \brief When the region changes, we check to see if we need to redraw the markers.
 *****************************************************************/
- (void)mapView:(MKMapView *)mapView    ///< The map view
regionDidChangeAnimated:(BOOL)animated  ///< Whether or not to animate the change.
{
#ifdef DEBUG
    NSLog(@"BMLTMapResultsViewController mapView:regionDidChangeAnimated called.");
#endif
    if ( mapView && ([mapView alpha] == 1) )
        {
        [self displayAllMarkersIfNeeded];
        }
}

/**************************************************************//**
 \brief Called when a marker is selected.
 *****************************************************************/
- (void)mapView:(MKMapView *)mapView                ///< The map view.
didSelectAnnotationView:(MKAnnotationView *)inView    ///< The selected annotation view.
{
#ifdef DEBUG
    NSLog(@"BMLTMapResultsViewController mapView:didSelectAnnotationView called.");
#endif
    if ( mapView && ([mapView alpha] == 1) )
        {
        id<MKAnnotation>    annotation = [inView annotation];
        
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
            [self dismissListPopover];
            _selectedAnnotation = theAnnotation;
            [theAnnotation setIsSelected:YES];
            [(BMLT_Results_MapPointAnnotationView *)[mapView viewForAnnotation:_selectedAnnotation] selectImage];
            
            NSArray *theMeetings = [theAnnotation getMyMeetings];
            
            if ( [theAnnotation getNumberOfMeetings] > 1 )
                {
                [self viewMeetingList:theMeetings atRect:[inView frame] inView:[inView superview]];
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
}
@end
