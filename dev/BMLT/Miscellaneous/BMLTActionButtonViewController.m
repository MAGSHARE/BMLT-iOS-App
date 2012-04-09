//
//  BMLTActionButtonViewController.m
//  BMLT
//
//  Created by MAGSHARE.
//  Copyright 2012 MAGSHARE. All rights reserved.
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

#import "BMLTActionButtonViewController.h"
#import "BMLTAppDelegate.h"
#import "BMLT_Meeting.h"
#import "BMLT_Results_MapPointAnnotationView.h"
#import <time.h>

#define BMLT_Meeting_Distance_Threshold_In_Pixels   12

/**************************************************************//**
 \class BMLTActionButtonViewController
 \brief This implements the popver (iPad) or modal dialog (iPhone)
 that allows a user to create a PDF and send by email, or
 print the search/meeting details.
 *****************************************************************/
@implementation BMLTActionButtonViewController
@synthesize containerView;
@synthesize emailButton;
@synthesize printButton;
@synthesize myModalController;
@synthesize singleMeeting;
@synthesize myMapView;

/**************************************************************//**
 \brief We set up the background colors and whatnot, here.
 *****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set all the localized strings.
    [[navBar topItem] setTitle:NSLocalizedString([[navBar topItem] title], nil)];
    [[self emailButton] setTitle:NSLocalizedString([[self emailButton] titleForState:UIControlStateNormal], nil) forState:UIControlStateNormal];
    [[self printButton] setTitle:NSLocalizedString([[self printButton] titleForState:UIControlStateNormal], nil) forState:UIControlStateNormal];
    
    CGRect  frame = [[self containerView] frame];
    frame.size.height += frame.origin.y;
    
    [self setContentSizeForViewInPopover:frame.size];
    // With a popover, we don't need the "Done" button.
    if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad )
        {
        if ( [BMLTVariantDefs popoverBackgroundColor] )
            {
            [[self view] setBackgroundColor:[BMLTVariantDefs popoverBackgroundColor]];
            }
        [(UINavigationItem *)[navBar topItem] setRightBarButtonItem:nil animated:NO];
        }
    else
        {
        if ( [BMLTVariantDefs modalBackgroundColor] )
            {
            [[self view] setBackgroundColor:[BMLTVariantDefs modalBackgroundColor]];
            }
        }
}

/**************************************************************//**
 \brief Just cleaning up.
 *****************************************************************/
- (void)viewDidUnload
{
    [self setEmailButton:nil];
    [self setPrintButton:nil];
    [self setContainerView:nil];
    [super viewDidUnload];
}

/**************************************************************//**
 \brief We follow the same rules as all the other views.
 \returns YES, if the autorotation is approved.
 *****************************************************************/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io   ///< The desired orientation
{
    BOOL    ret = (io == UIInterfaceOrientationPortrait);   // iPhone is portrait-only.
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)   // iPad is any which way.
        {
        ret = YES;
        }
    
    return ret;
}

/**************************************************************//**
 \brief Draw a printable version of the search results as a map.
 *****************************************************************/
- (void)drawPrintableSearchMap
{
#ifdef DEBUG
    NSLog(@"BMLTActionButtonViewController::drawPrintableSearchMap");
#endif
    [self determineMapSize:[[BMLTAppDelegate getBMLTAppDelegate] searchResults]];
    [self displayMapAnnotations:[[BMLTAppDelegate getBMLTAppDelegate] searchResults]];
}

/**************************************************************//**
 \brief Draw a printable version of the search results.
 *****************************************************************/
- (void)drawPrintableSearchList
{
#ifdef DEBUG
    NSLog(@"BMLTActionButtonViewController::drawPrintableSearchList");
#endif
}

/**************************************************************//**
 \brief Draw a printable version of our single meeting.
 *****************************************************************/
- (void)drawPrintableMeetingDetails
{
#ifdef DEBUG
    NSLog(@"BMLTActionButtonViewController::drawPrintableMeetingDetails");
#endif
}

#pragma mark - Map Draing Functions -

/**************************************************************//**
 \brief This draws annotations for the meetings passed in.
 *****************************************************************/
- (void)displayMapAnnotations:(NSArray *)inResults  ///< This is an NSArray of BMLT_Meeting objects. Each one represents a meeting.
{
    // First, clear out all the old annotations (there shouldn't be any).
    [[self myMapView] removeAnnotations:[[self myMapView] annotations]];
    
    // This function looks for meetings in close proximity to each other, and collects them into "red markers."
    NSArray *annotations = [self mapMeetingAnnotations:inResults];
    
    if ( annotations )  // If we have annotations, we draw them.
        {
#ifdef DEBUG
        NSLog(@"BMLTMapResultsViewController displayMapAnnotations -Adding %d annotations", [inResults count]);
#endif
        [[self myMapView] addAnnotations:annotations];
        }
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
    
    if ( [inResults count] )
        {
        NSMutableArray  *points = [[NSMutableArray alloc] init];
        for ( BMLT_Meeting *meeting in inResults )
            {
#ifdef DEBUG
            NSLog(@"BMLTMapResultsViewController mapMeetingAnnotations - Checking Meeting \"%@\".", [meeting getBMLTName]);
#endif
            CLLocationCoordinate2D  meetingLocation = [meeting getMeetingLocationCoords].coordinate;
            CGPoint meetingPoint = [[self myMapView] convertCoordinate:meetingLocation toPointToView:nil];
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
                CGPoint annotationPoint = [[self myMapView] convertCoordinate:annotationTemp.coordinate toPointToView:nil];
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
    
    // This is the black marker.
    BMLT_Results_MapPointAnnotation *annotation = [[BMLT_Results_MapPointAnnotation alloc] initWithCoordinate:[[BMLTAppDelegate getBMLTAppDelegate] searchMapMarkerLoc] andMeetings:nil];
    
    if ( annotation )
        {
        [annotation setTitle:NSLocalizedString(@"BLACK-MARKER-TITLE", nil)];
        [ret addObject:annotation];
        }
    
    return ret;
}

/**************************************************************//**
 \brief This scans through the list of meetings, and will produce
 a region that encompasses them all. It then scales the
 map to cover that region.
 *****************************************************************/
- (void)determineMapSize:(NSArray *)inResults   ///< This is an NSArray of BMLT_Meeting objects. Each one represents a meeting.
{    
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
    
    [[self myMapView] setRegion:[[self myMapView] regionThatFits:mapMap] animated:NO];
    [self displayMapAnnotations:inResults];
}

#pragma mark - IBActions -
/**************************************************************//**
 \brief This is called to close the dialog.
 *****************************************************************/
- (IBAction)doneButtonPressed:(id)sender    ///< The done button object
{
    [[self myModalController] closeModal];
}

/**************************************************************//**
 \brief This is called if the user presses the email button.
 *****************************************************************/
- (IBAction)emailPDFPressed:(id)sender  ///< The email button object
{
#ifdef DEBUG
    NSLog(@"BMLTActionButtonViewController::emailPDFPressed:");
#endif
    CGSize      myPageSize = [BMLTVariantDefs pdfPageSize];
    NSString    *pdfFileName = [NSString stringWithFormat:[BMLTVariantDefs pdfTempFileNameFormat], time(NULL)];
    NSString    *containerDirectory = NSTemporaryDirectory();
    
#ifdef DEBUG
    NSLog(@"BMLTActionButtonViewController::emailPDFPressed: The temporary directory is %@", containerDirectory);
#endif
    
    pdfFileName = [containerDirectory stringByAppendingPathComponent:pdfFileName];

    [self setMyMapView:[[MKMapView alloc] init]];
    UIGraphicsBeginPDFContextToFile ( pdfFileName, CGRectZero, nil) ;

    if ( [self singleMeeting] )
        {
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, myPageSize.width, myPageSize.height), nil);
        [self drawPrintableMeetingDetails];
        }
    else
        {
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, myPageSize.width, myPageSize.height), nil);
        [self drawPrintableSearchMap];
        }
    
    UIGraphicsEndPDFContext();
    [self setMyMapView:nil];
}

/**************************************************************//**
 \brief This is called if the user presses the print button.
 *****************************************************************/
- (IBAction)printButtonPressed:(id)sender   ///< The print button object
{
#ifdef DEBUG
    NSLog(@"BMLTActionButtonViewController::printButtonPressed:");
#endif
}
@end
