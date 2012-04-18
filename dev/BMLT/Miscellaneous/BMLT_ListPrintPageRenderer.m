//
//  BMLTPrintPageRenderer.m
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

#import "BMLT_ListPrintPageRenderer.h"
#import "BMLT_Meeting.h"
#import "BMLT_Format.h"
#import "BMLTAppDelegate.h"
#import "BMLT_Results_MapPointAnnotationView.h"

static int  kNumberOfMeetingsPerPage    = 10;   ///< This is how many meetings we can list per page.
static int  kFontSizeOfMeetingName      = 16;   ///< The font size, in points, of the meeting name.
static int  kFontSizeOfMeetingTownState = 12;   ///< The font size, in points, of the meeting town and state display.
static int  kFontSizeOfAddress          = 10;   ///< The font size for the address line.
static int  kFontSizeOfFormats          = 9;    ///< The size of the formats strings.
static int  kFontSizeOfComments         = 9;    ///< The size of the comments string.
static int  kDisplayGap                 = 0;    ///< The vertical space between lines, in the meeting display.
static int  kLeftPadding                = 4;    ///< The number of pixels in from the left edge of the paper.
static int  kRightPadding               = 4;    ///< The number of pixels in from the right edge of the paper.
static int  BMLT_Meeting_Distance_Threshold_In_Pixels = 12; ///< The minimum distance apart for map annotations, before they are combined.

/**************************************************************//**
 \class BMLT_ListPrintPageRenderer
 \brief This is a concrete class that implements a list display print.
 *****************************************************************/
@implementation BMLT_ListPrintPageRenderer
@synthesize myMap;

/**************************************************************//**
 \brief This is how many pages we'll need to print.
 \returns an integer, with the number of pages to print.
 *****************************************************************/
- (NSInteger)numberOfPages
{
    NSInteger   pages = (NSInteger)ceil ( (float)[[self myMeetings] count] / (float)kNumberOfMeetingsPerPage ) + 1;
#ifdef DEBUG
    NSLog(@"BMLT_ListPrintPageRenderer::numberOfPages: (%d meetings, %d meetings per page, %d pages)", [[self myMeetings] count], kNumberOfMeetingsPerPage, pages);
#endif
    return pages;
}

/**************************************************************//**
 \brief 
 *****************************************************************/
- (void)prepareForDrawingPages:(NSRange)range
{
#ifdef DEBUG
    NSLog(@"BMLT_ListPrintPageRenderer::prepareForDrawingPages: %d to %d", range.location, range.length);
#endif
    if ( range.location == 0 )
        {
        [self setMyMap:[[MKMapView alloc] initWithFrame:[self printableRect]]];
        
        if ( [self myMap] )
            {
            [self determineMapSize];
            NSArray *annotations = [self mapMeetingAnnotations];
            
            if ( annotations )  // If we have annotations, we draw them.
                {
#ifdef DEBUG
                NSLog(@"BMLT_ListPrintPageRenderer::prepareForDrawingPages: -Adding %d annotations", [annotations count]);
#endif
                [[self myMap] addAnnotations:annotations];
                }
            [self addPrintFormatter:[[self myMap] viewPrintFormatter] startingAtPageAtIndex:0];
            }
        }
}

/**************************************************************//**
 \brief This will draw up the content for this list of meetings.
 *****************************************************************/
- (void)drawContentForPageAtIndex:(NSInteger)index  ///< The page index
                           inRect:(CGRect)inRect    ///< The content rect
{
    if ( index > 0 )
        {
        int   firstMeetingIndex = kNumberOfMeetingsPerPage * (index - 1);
        int   lastMeetingIndex = MIN( firstMeetingIndex + kNumberOfMeetingsPerPage, [[self myMeetings] count]) - 1;
    
#ifdef DEBUG
        NSLog(@"BMLT_ListPrintPageRenderer::drawContentForPageAtIndex: %d inRect: (%f, %f), (%f, %f). %d meetings. First Meeting Index is %d. Last Meeting Index is %d", index, inRect.origin.x, inRect.origin.y, inRect.size.width, inRect.size.height, [[self myMeetings] count], firstMeetingIndex, lastMeetingIndex);
#endif
    
        float   meetingCellHeight = (inRect.size.height / (float)kNumberOfMeetingsPerPage);
        
        CGRect  meetingCellRect = inRect;
        
        meetingCellRect.size.height = meetingCellHeight;
        
        // Cycle through all the meetings, and write out each meeting.
        for ( int myInd = firstMeetingIndex; myInd <= lastMeetingIndex; myInd++ )
            {
            [self drawOneMeeting:(BMLT_Meeting *)[[self myMeetings] objectAtIndex:myInd] inRect:meetingCellRect];
            meetingCellRect.origin.y += meetingCellRect.size.height;
            }
        }
}

/**************************************************************//**
 \brief This will draw one meeting in the list.
 *****************************************************************/
- (int)drawOneMeeting:(BMLT_Meeting *)inMeeting    ///< The meeting object to be drawn.
                inRect:(CGRect)inRect               ///< The rect in which it is to be drawn.
{
#ifdef DEBUG
    NSLog(@"BMLT_ListPrintPageRenderer::drawOneMeeting: inRect: (%f, %f), (%f, %f). Meeting named \"%@\"", inRect.origin.x, inRect.origin.y, inRect.size.width, inRect.size.height, [inMeeting getBMLTName]);
#endif
    UIFont  *currentFont = [UIFont boldSystemFontOfSize:kFontSizeOfMeetingName];    // We will use this variable to hold whatever font we're working with.

    inRect.origin.x += kLeftPadding;
    inRect.size.width -= kLeftPadding + kRightPadding;
    
    [[inMeeting getBMLTName] drawInRect:inRect withFont:currentFont lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentLeft];
    
    float   lineHeight = [[inMeeting getBMLTName] sizeWithFont:currentFont].height + kDisplayGap;
    inRect.origin.y += lineHeight;      // Adjust the next line top...
    inRect.size.height -= lineHeight;   // ...and the size
    
    float ret = lineHeight;
    
    // We indent the meeting info slightly.
    inRect.origin.x += kLeftPadding;
    inRect.size.width -= kLeftPadding;
    
    lineHeight = [self drawTownStateDayAndTime:inMeeting inRect:inRect];
    
    ret += lineHeight + kDisplayGap;
    
    inRect.origin.y += lineHeight + kDisplayGap;
    inRect.size.height -= lineHeight + kDisplayGap;
    
    lineHeight = [self drawAddress:inMeeting inRect:inRect];
    
    ret += lineHeight + kDisplayGap;
    
    inRect.origin.y += lineHeight + kDisplayGap;
    inRect.size.height -= lineHeight + kDisplayGap;
    
    lineHeight = [self drawFormats:inMeeting inRect:inRect];
    
    ret += lineHeight + kDisplayGap;
    
    inRect.origin.y += lineHeight + kDisplayGap;
    inRect.size.height -= lineHeight + kDisplayGap;
    
    lineHeight = [self drawComments:inMeeting inRect:inRect];
    
    ret += lineHeight + kDisplayGap;
    
    return ceil ( ret );
}

/**************************************************************//**
 \brief This sets the town and state.
 *****************************************************************/
- (int)drawTownStateDayAndTime:(BMLT_Meeting *)inMeeting    ///< The meeting object to be drawn.
                         inRect:(CGRect)inRect               ///< The rect in which it is to be drawn.
{
    UIFont  *currentFont = [UIFont boldSystemFontOfSize:kFontSizeOfMeetingTownState];    // We will use this variable to hold whatever font we're working with.
    
    NSString    *displayString = @"";
    
    if ( [inMeeting getValueFromField:@"location_province"] )
        {
        displayString = [NSString stringWithFormat:@"%@, %@", (([inMeeting getValueFromField:@"location_city_subsection"]) ? (NSString *)[inMeeting getValueFromField:@"location_city_subsection"] : (NSString *)[inMeeting getValueFromField:@"location_municipality"]), (NSString *)[inMeeting getValueFromField:@"location_province"]];
        }
    else
        {
        displayString = [NSString stringWithString: (([inMeeting getValueFromField:@"location_city_subsection"]) ? (NSString *)[inMeeting getValueFromField:@"location_city_subsection"] : (NSString *)[inMeeting getValueFromField:@"location_municipality"])];
        }
    
    NSDate      *startTime = [inMeeting getStartTime];
    NSString    *timeString = [NSDateFormatter localizedStringFromDate:startTime dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
    NSCalendar  *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    if ( gregorian )
        {
        NSDateComponents    *dateComp = [gregorian components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:startTime];
        
        if ( [dateComp hour] >= 23 && [dateComp minute] > 45 )
            {
            timeString = NSLocalizedString(@"TIME-MIDNIGHT", nil);
            }
        else if ( [dateComp hour] == 12 && [dateComp minute] == 0 )
            {
            timeString = NSLocalizedString(@"TIME-NOON", nil);
            }
        }
    
    displayString = [displayString stringByAppendingFormat:NSLocalizedString(@"PRINT-TOWN-DATE-FORMAT-STRING", nil), [inMeeting getWeekday], timeString];
    
    float   lineHeight = [displayString sizeWithFont:currentFont].height;
    [displayString drawInRect:inRect withFont:currentFont lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentLeft];
    
    return ceil ( lineHeight );
}

/**************************************************************//**
 \brief This sets the town and state.
 *****************************************************************/
- (int)drawAddress:(BMLT_Meeting *)inMeeting
            inRect:(CGRect)inRect
{
    UIFont  *currentFont = [UIFont italicSystemFontOfSize:kFontSizeOfAddress];    // We will use this variable to hold whatever font we're working with.

    NSString    *displayString = [NSString stringWithFormat:@"%@%@", (([inMeeting getValueFromField:@"location_text"]) ? [NSString stringWithFormat:@"%@, ", (NSString *)[inMeeting getValueFromField:@"location_text"]] : @""), [inMeeting getValueFromField:@"location_street"]];
    
    if ( !displayString )
        {
        displayString =  @"";
        }
    
    float   lineHeight = [displayString sizeWithFont:currentFont].height;
    [displayString drawInRect:inRect withFont:currentFont lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentLeft];

    return ceil ( lineHeight );
}

/**************************************************************//**
 \brief This writes out the format names.
 *****************************************************************/
- (int)drawFormats:(BMLT_Meeting *)inMeeting
            inRect:(CGRect)inRect
{
    UIFont      *currentFont = [UIFont boldSystemFontOfSize:kFontSizeOfFormats];    // We will use this variable to hold whatever font we're working with.
    NSString    *displayString = @"";
    
    NSArray *formats = [inMeeting getFormats];
    
    for ( BMLT_Format *format in formats )
        {
        displayString = [displayString stringByAppendingFormat:([displayString length] ? @", %@" : @"%@"), [format getBMLTName]];
        }
    
    float   lineHeight = [displayString sizeWithFont:currentFont].height;
    [displayString drawInRect:inRect withFont:currentFont lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentLeft];
    
    return ceil ( lineHeight );
}

/**************************************************************//**
 \brief This writes out any comments about the meeting.
 *****************************************************************/
- (int)drawComments:(BMLT_Meeting *)inMeeting
            inRect:(CGRect)inRect
{
    if ( [inMeeting getValueFromField:@"comments"] )
        {
        UIFont      *currentFont = [UIFont italicSystemFontOfSize:kFontSizeOfComments];    // We will use this variable to hold whatever font we're working with.
        NSString    *displayString = (NSString *)[inMeeting getValueFromField:@"comments"];
                
        float   lineHeight = [displayString sizeWithFont:currentFont].height;
        [displayString drawInRect:inRect withFont:currentFont lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentLeft];
        
        return ceil ( lineHeight );
        }
    
    return 0.0;
}

/**************************************************************//**
 \brief This scans through the list of meetings, and will produce
 a region that encompasses them all. It then scales the
 map to cover that region.
 *****************************************************************/
- (void)determineMapSize
{    
    CLLocationCoordinate2D  northWestCorner;
    CLLocationCoordinate2D  southEastCorner;
    
    northWestCorner = [(BMLT_Meeting *)[[self myMeetings] objectAtIndex:0] getMeetingLocationCoords].coordinate;
    southEastCorner = [(BMLT_Meeting *)[[self myMeetings] objectAtIndex:0] getMeetingLocationCoords].coordinate;
    
    for ( BMLT_Meeting *meeting in [self myMeetings] )
        {
#ifdef DEBUG
        NSLog(@"BMLT_ListPrintPageRenderer::determineMapSize -Calculating the container, working on meeting \"%@\".", [meeting getBMLTName]);
#endif
        CLLocationCoordinate2D  meetingLocation = [meeting getMeetingLocationCoords].coordinate;
        northWestCorner.longitude = fmin(northWestCorner.longitude, meetingLocation.longitude);
        northWestCorner.latitude = fmax(northWestCorner.latitude, meetingLocation.latitude);
        southEastCorner.longitude = fmax(southEastCorner.longitude, meetingLocation.longitude);
        southEastCorner.latitude = fmin(southEastCorner.latitude, meetingLocation.latitude);
        }
#ifdef DEBUG
    NSLog(@"BMLT_ListPrintPageRenderer::determineMapSize -The current map area is NW: (%f, %f), SE: (%f, %f)", northWestCorner.longitude, northWestCorner.latitude, southEastCorner.longitude, southEastCorner.latitude );
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
    
    [[self myMap] setRegion:[[self myMap] regionThatFits:mapMap] animated:NO];
}

/**************************************************************//**
 \brief This function looks for meetings in close proximity to each
        other, and collects them into "red markers."
 \returns an NSArray of BMLT_Results_MapPointAnnotation objects.
 *****************************************************************/
- (NSArray *)mapMeetingAnnotations
{
#ifdef DEBUG
    NSLog(@"BMLT_ListPrintPageRenderer::mapMeetingAnnotations - Checking %d Meetings.", [[self myMeetings] count]);
#endif
    NSMutableArray  *ret = nil;
    
    if ( [[self myMeetings] count] )
        {
        NSMutableArray  *points = [[NSMutableArray alloc] init];
        for ( BMLT_Meeting *meeting in [self myMeetings] )
            {
#ifdef DEBUG
            NSLog(@"BMLT_ListPrintPageRenderer::mapMeetingAnnotations - Checking Meeting \"%@\".", [meeting getBMLTName]);
#endif
            CLLocationCoordinate2D  meetingLocation = [meeting getMeetingLocationCoords].coordinate;
            CGPoint meetingPoint = [[self myMap] convertCoordinate:meetingLocation toPointToView:nil];
            CGRect  hitTestRect = CGRectMake(meetingPoint.x - BMLT_Meeting_Distance_Threshold_In_Pixels,
                                             meetingPoint.y - BMLT_Meeting_Distance_Threshold_In_Pixels,
                                             BMLT_Meeting_Distance_Threshold_In_Pixels * 2,
                                             BMLT_Meeting_Distance_Threshold_In_Pixels * 2);
            
            BMLT_Results_MapPointAnnotation *annotation = nil;
#ifdef DEBUG
            NSLog(@"BMLT_ListPrintPageRenderer::mapMeetingAnnotations - Meeting \"%@\" Has the Following Hit Test Rect: (%f, %f), (%f, %f).", [meeting getBMLTName], hitTestRect.origin.x, hitTestRect.origin.y, hitTestRect.size.width, hitTestRect.size.height);
#endif
            
            for ( BMLT_Results_MapPointAnnotation *annotationTemp in points )
                {
                CGPoint annotationPoint = [[self myMap] convertCoordinate:annotationTemp.coordinate toPointToView:nil];
#ifdef DEBUG
                NSLog(@"BMLT_ListPrintPageRenderer::mapMeetingAnnotations - Comparing the Following Annotation Point: (%f, %f).", annotationPoint.x, annotationPoint.y);
#endif
                
                if ( !([[annotationTemp getMyMeetings] containsObject:meeting]) && CGRectContainsPoint(hitTestRect, annotationPoint) )
                    {
#ifdef DEBUG
                    for ( BMLT_Meeting *t_meeting in [annotationTemp getMyMeetings] )
                        {
                        NSLog(@"BMLT_ListPrintPageRenderer::mapMeetingAnnotations - Meeting \"%@\" Is Close to \"%@\".", [meeting getBMLTName], [t_meeting getBMLTName]);
                        }
#endif
                    annotation = annotationTemp;
                    }
                }
            
            if ( !annotation )
                {
#ifdef DEBUG
                NSLog(@"BMLT_ListPrintPageRenderer::mapMeetingAnnotations -This meeting gets its own annotation.");
#endif
                NSArray *meetingsAr = [[NSArray alloc] initWithObjects:meeting, nil];  
                annotation = [[BMLT_Results_MapPointAnnotation alloc] initWithCoordinate:[meeting getMeetingLocationCoords].coordinate andMeetings:meetingsAr andIndex:0];
                [points addObject:annotation];
                }
            else
                {
#ifdef DEBUG
                NSLog(@"BMLT_ListPrintPageRenderer::mapMeetingAnnotations -This meeting gets lumped in with others.");
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
                NSLog(@"BMLT_ListPrintPageRenderer::mapView: viewForAnnotation: -Annotation Selected. This annotation contains %d meetings.", [(BMLT_Results_MapPointAnnotation *)annotation getNumberOfMeetings]);
#endif
                ret = [[BMLT_Results_MapPointAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Map_Annot"];
                }
            else
                {
#ifdef DEBUG
                NSLog(@"BMLT_ListPrintPageRenderer::mapView: viewForAnnotation: -Black Center Annotation.");
#endif
                ret = [[BMLT_Results_BlackAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Search_Location_Annot"];
                
                [ret setCanShowCallout:YES];
                }
            }
        }
    return ret;
}

@end
