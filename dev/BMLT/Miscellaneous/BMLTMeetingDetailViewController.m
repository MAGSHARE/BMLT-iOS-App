//
//  BMLTMeetingDetailViewController.m
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

#import "BMLT_Results_MapPointAnnotationView.h"
#import "BMLTMeetingDetailViewController.h"
#import "BMLT_Meeting.h"
#import "BMLT_Format.h"
#import "BMLTAppDelegate.h"

@implementation BMLTMeetingDetailViewController
@synthesize addressButton;
@synthesize commentsTextView;
@synthesize frequencyTextView;
@synthesize formatsContainerView;
@synthesize selectSatelliteButton;
@synthesize selectMapButton;
@synthesize meetingMapView, myMeeting = _myMeeting;
@synthesize myModalController;

#pragma mark - View lifecycle

/**************************************************************//**
 \brief Sets up the view, with all its parts.
 *****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationItem] setTitle:[_myMeeting getBMLTName]];
    [[[self navigationItem] titleView] sizeToFit];
    [self setFormats];
    [self setMeetingFrequencyText];
    [self setMeetingCommentsText];
    [self setMapLocation];
    [self setMeetingLocationText];
    [[self view] setBackgroundColor:[BMLTVariantDefs meetingDetailBackgroundColor]];
}

/**************************************************************//**
 \brief Scram the reactor.
 *****************************************************************/
- (void)viewDidUnload
{
    [self setAddressButton:nil];
    [self setCommentsTextView:nil];
    [self setFrequencyTextView:nil];
    [self setFormatsContainerView:nil];
    [self setSelectSatelliteButton:nil];
    [self setSelectMapButton:nil];
    [super viewDidUnload];
}

/**************************************************************//**
 \brief Called when the device is rotated.
 \returns NO, unless portrait (iPhone), or YES for everything (iPad).
 *****************************************************************/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io   ///< The desired interface orientation.
{
    BOOL    ret = (io == UIInterfaceOrientationPortrait);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
        ret = YES;
        }
    
    return ret;
}

#pragma mark - Custom Functions -

/**************************************************************//**
 \brief Set up the display of the format circles.
 *****************************************************************/
- (void)setFormats
{
    NSArray *formats = [_myMeeting getFormats];
    
    if ( [formats count] )
        {
        CGRect  formatsBounds = [formatsContainerView frame];
        formatsBounds.size.width = 0;
        
        CGRect  boundsRect = [formatsContainerView bounds];
        
        boundsRect.origin = CGPointZero;
        boundsRect.size.width = boundsRect.size.height = (List_Meeting_Format_Circle_Size_Big);
        boundsRect.origin.y = (formatsBounds.size.height - boundsRect.size.height) / 2;
        
        for ( BMLT_Format *format in formats )
            {
            BMLT_FormatButton   *newButton = [[BMLT_FormatButton alloc] initWithFrame:boundsRect andFormat:format];
            
            if ( newButton )
                {
                [newButton addTarget:[self myModalController] action:@selector(displayFormatDetail:) forControlEvents:UIControlEventTouchUpInside];
                [formatsContainerView addSubview:newButton];
                }
            
            newButton = nil;

            formatsBounds.size.width += boundsRect.size.width + List_Meeting_Format_Line_Padding;
            boundsRect.origin.x += boundsRect.size.width + List_Meeting_Format_Line_Padding;
            }

        formatsBounds.size.width -= List_Meeting_Format_Line_Padding;
        boundsRect = [[self view] bounds];
        formatsBounds.origin.x = (boundsRect.size.width - formatsBounds.size.width) / 2;
        [formatsContainerView setFrame:formatsBounds];
        }
}

/**************************************************************//**
 \brief Set up the display of the text as to when and how long the meeting meets.
 *****************************************************************/
- (void)setMeetingFrequencyText
{
    NSDate      *startTime = [_myMeeting getStartTime];
    NSString    *time = [NSDateFormatter localizedStringFromDate:startTime dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
    NSCalendar  *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    if ( gregorian )
        {
        NSDateComponents    *dateComp = [gregorian components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:startTime];
        
        if ( [dateComp hour] >= 23 && [dateComp minute] > 45 )
            {
            time = NSLocalizedString(@"TIME-MIDNIGHT", nil);
            }
        else if ( [dateComp hour] == 12 && [dateComp minute] == 0 )
            {
            time = NSLocalizedString(@"TIME-NOON", nil);
            }
        
        gregorian = nil;
        }
    
    [frequencyTextView setText:[NSString stringWithFormat:NSLocalizedString ( @"MEETING-DETAILS-FREQUENCY-FORMAT", nil ), [_myMeeting getWeekday], time]];
}

/**************************************************************//**
 \brief Display the comments for the meeting.
 *****************************************************************/
- (void)setMeetingCommentsText
{
    [commentsTextView setText:[_myMeeting getBMLTDescription]];
}

/**************************************************************//**
 \brief Creates and displays a location string, based on the location coordinates of the meeting.
 *****************************************************************/
- (void)setMeetingLocationText
{
    NSString    *townAndState = [NSString stringWithFormat:@"%@, %@", (([_myMeeting getValueFromField:@"location_city_subsection"]) ? (NSString *)[_myMeeting getValueFromField:@"location_city_subsection"] : (NSString *)[_myMeeting getValueFromField:@"location_municipality"]), (NSString *)[_myMeeting getValueFromField:@"location_province"]];
    NSString    *meetingLocationString = [NSString stringWithFormat:@"%@%@", (([_myMeeting getValueFromField:@"location_text"]) ? [NSString stringWithFormat:@"%@, ", (NSString *)[_myMeeting getValueFromField:@"location_text"]] : @""), [_myMeeting getValueFromField:@"location_street"]];
    
    NSString    *theAddress = [NSString stringWithFormat:@"%@, %@", meetingLocationString, townAndState];
    [addressButton setTitle:theAddress forState:UIControlStateNormal];
    
    CLLocation  *loc = [_myMeeting getMeetingLocationCoords];
    
    [meetingMapView addAnnotation:[[BMLT_Results_MapPointAnnotation alloc] initWithCoordinate:[loc coordinate] andMeetings:nil]];
    [selectMapButton setAlpha:0.0];
    [selectSatelliteButton setAlpha:1.0];
}

/**************************************************************//**
 \brief Sets up the location of the meeting on the map view.
 *****************************************************************/
- (void)setMapLocation
{
    CLLocation  *loc = [_myMeeting getMeetingLocationCoords];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([loc coordinate], 250, 250);
    [meetingMapView setDelegate:self];
    [meetingMapView setRegion:region animated:NO];
}

/**************************************************************//**
 \brief The map will be displayed as a map.
 *****************************************************************/
- (IBAction)selectMapView:(id)sender
{
    [meetingMapView setMapType:MKMapTypeStandard];
    [selectMapButton setAlpha:0.0];
    [selectSatelliteButton setAlpha:1.0];
}

/**************************************************************//**
 \brief The map will be displayed as a satellite view.
 *****************************************************************/
- (IBAction)selectSatelliteView:(id)sender
{
    [meetingMapView setMapType:MKMapTypeHybrid];
    [selectMapButton setAlpha:1.0];
    [selectSatelliteButton setAlpha:0.0];
}

#pragma mark - MkMapAnnotationDelegate Functions -

/**************************************************************//**
 \brief Returns the view for the marker in the center of the map.
 \returns an annotation view, representing the marker.
 *****************************************************************/
- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id < MKAnnotation >)annotation
{
    static NSString* identifier = @"single_meeting_annotation";
    
    MKAnnotationView* ret = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if ( !ret )
        {
        ret = [[BMLT_Results_BlackAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
    
    return ret;
}

/**************************************************************//**
 \brief This will use the Web browser to get directions to the
        meeting from the user's current location.
 *****************************************************************/
- (IBAction)callForDirections:(id)sender
{
    [[BMLTAppDelegate getBMLTAppDelegate] imVisitingRelatives];
    
    CLLocationCoordinate2D  meetingLocation = [_myMeeting getMeetingLocationCoords].coordinate;
    NSURL                   *helpfulGasStationAttendant = [BMLTVariantDefs directionsURITo:meetingLocation];
    
    [[UIApplication sharedApplication] openURL:helpfulGasStationAttendant];
}
@end
