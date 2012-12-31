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
#import "BMLT_DetailsPrintPageRenderer.h"

@interface BMLTMeetingDetailViewController ()
@property (strong, atomic)  UIBarButtonItem *_toggleButton;
@end

@implementation BMLTMeetingDetailViewController
@synthesize addressButton;
@synthesize commentsTextView;
@synthesize frequencyTextView;
@synthesize formatsContainerView;
@synthesize meetingMapView, myMeeting = _myMeeting;
@synthesize myModalController;
@synthesize meetingNameLabel;
@synthesize _toggleButton;

static int List_Meeting_Format_Circle_Size_Big = 30;

#pragma mark - View lifecycle

/*****************************************************************/
/**
 \brief Sets up the view, with all its parts.
 *****************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self navigationItem] setTitle:NSLocalizedString(@"MEETING-DETAILS", nil)];
    [[[self navigationItem] titleView] sizeToFit];
    
    [[self meetingNameLabel] setText:[_myMeeting getBMLTName]];
    UIBarButtonItem *theButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionItemClicked:)];
    // iPad has enough room for us to add a "Directions" button.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
        UIBarButtonItem *dirButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"DIRECTIONS-BUTTON-TITLE",nil) style:UIBarButtonItemStylePlain target:self action:@selector(callForDirections:)];
        NSArray *buttons = [NSArray arrayWithObjects:theButton, dirButton, nil];
        [[self navigationItem] setRightBarButtonItems:buttons];
        }
    else    // iPhone does not.
        {
        [[self navigationItem] setRightBarButtonItem:theButton];
        }
    
    [self setMeetingFrequencyText];
    
    CGRect  description_frame = [frequencyTextView frame];
    CGRect  address_frame = [addressButton frame];
    CGPoint top_of_map = CGPointMake ( description_frame.origin.x, description_frame.origin.y + description_frame.size.height);
    
    if ( [_myMeeting getBMLTDescription] )
        {
        [commentsTextView setHidden:NO];
        [self setMeetingCommentsText];
        CGRect  comments_frame = [commentsTextView frame];
        top_of_map = CGPointMake ( comments_frame.origin.x, comments_frame.origin.y + comments_frame.size.height);
        }
    else
        {
        [commentsTextView setHidden:YES];
        }

    CGRect  map_frame = [[self meetingMapView] frame];
    map_frame.origin.y = top_of_map.y + description_frame.size.height;
    map_frame.size.height = address_frame.origin.y - map_frame.origin.y;
    [[self meetingMapView] setFrame:map_frame];
    
    [self setMeetingLocationText];
    [self setFormats];
    [self addToggleMapButton];
    [[BMLTAppDelegate getBMLTAppDelegate] toggleThisMapView:[self meetingMapView] fromThisButton:nil];
}

/*****************************************************************/
/**
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

/*****************************************************************/
/**
 \brief  This just makes sure that the print popover goes away.
 *****************************************************************/
- (void)viewWillDisappear:(BOOL)animated
{
    [[UIPrintInteractionController sharedPrintController] dismissAnimated:YES];    
}

#pragma mark - Custom Functions -

/*****************************************************************/
/**
 \brief  This adds the map toggle button to the navbar.
 *****************************************************************/
- (void)addToggleMapButton
{
    if ( YES )
        {
        NSMutableArray  *buttons = [[NSMutableArray alloc]initWithArray:[[self navigationItem] rightBarButtonItems]];
        [buttons removeObject:[self _toggleButton]];
    
        NSString    *label = NSLocalizedString ( ([[BMLTAppDelegate getBMLTAppDelegate] mapType] == MKMapTypeStandard ? @"TOGGLE-MAP-LABEL-SATELLITE" : @"TOGGLE-MAP-LABEL-MAP" ), nil);
    
        if ( ![self _toggleButton] )
            {
            [self set_toggleButton:[[UIBarButtonItem alloc] initWithTitle:label style:UIBarButtonItemStyleBordered target:self action:@selector(toggleMapView:)]];
            }
        else
            {
            [[self _toggleButton] setTitle:label];
            }
    
        [buttons addObject:[self _toggleButton]];
    
        [[self navigationItem] setRightBarButtonItems:buttons animated:NO];
        }
}

/*****************************************************************/
/**
 \brief Set up the display of the format circles.
 *****************************************************************/
- (void)setFormats
{
    NSArray *formats = [_myMeeting getFormats];
    
    for ( UIView *subView in [formatsContainerView subviews] )
        {
        [subView removeFromSuperview];
        }
    
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

/*****************************************************************/
/**
 \brief Set up the display of the text as to when and how long the meeting meets.
 *****************************************************************/
- (void)setMeetingFrequencyText
{
    NSDate              *startTime = [_myMeeting getStartTime];
    NSString            *time = [NSDateFormatter localizedStringFromDate:startTime dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
    NSDateComponents    *dateComp = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:startTime];
    
    if ( [dateComp hour] >= 23 && [dateComp minute] > 45 )
        {
        time = nil;
        time = NSLocalizedString(@"TIME-MIDNIGHT", nil);
        }
    else if ( [dateComp hour] == 12 && [dateComp minute] == 0 )
        {
        time = nil;
        time = NSLocalizedString(@"TIME-NOON", nil);
        }
    
    [frequencyTextView setText:[NSString stringWithFormat:NSLocalizedString ( @"MEETING-DETAILS-FREQUENCY-FORMAT", nil ), [_myMeeting getWeekday], time]];
}

/*****************************************************************/
/**
 \brief Display the comments for the meeting.
 *****************************************************************/
- (void)setMeetingCommentsText
{
    [commentsTextView setText:[_myMeeting getBMLTDescription]];
}

/*****************************************************************/
/**
 \brief Creates and displays a location string, based on the location coordinates of the meeting.
 *****************************************************************/
- (void)setMeetingLocationText
{
    NSString    *townAndState = [NSString stringWithFormat:@"%@, %@", (([_myMeeting getValueFromField:@"location_city_subsection"]) ? (NSString *)[_myMeeting getValueFromField:@"location_city_subsection"] : (NSString *)[_myMeeting getValueFromField:@"location_municipality"]), (NSString *)[_myMeeting getValueFromField:@"location_province"]];
    NSString    *meetingLocationString = [NSString stringWithFormat:@"%@%@", (([_myMeeting getValueFromField:@"location_text"]) ? [NSString stringWithFormat:@"%@, ", (NSString *)[_myMeeting getValueFromField:@"location_text"]] : @""), [_myMeeting getValueFromField:@"location_street"]];
    
    NSString    *theAddress = [NSString stringWithFormat:@"%@, %@", meetingLocationString, townAndState];
    [addressButton setTitle:theAddress forState:UIControlStateNormal];
}

/*****************************************************************/
/**
 \brief Sets up the location of the meeting on the map view.
 *****************************************************************/
- (void)setMapLocation
{
    // If the meeting doesn't yet have its marker, it needs setting up.
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([[_myMeeting getMeetingLocationCoords] coordinate], [NSLocalizedString(@"INITIAL-PROJECTION", nil) floatValue] * 10, [NSLocalizedString(@"INITIAL-PROJECTION", nil) floatValue] * 10);

    [meetingMapView setRegion:region animated:NO];
    if ( ![[meetingMapView annotations] count] )
        {
        [[self view] setBackgroundColor:[BMLTVariantDefs meetingDetailBackgroundColor]];    // This is here to make sure it's only called once.
        [meetingMapView addAnnotation:[[BMLT_Results_MapPointAnnotation alloc] initWithCoordinate:[[_myMeeting getMeetingLocationCoords] coordinate] andMeetings:nil andIndex:0]];
        [meetingMapView setDelegate:self];
        }
    else
        {
        [[[meetingMapView annotations] objectAtIndex:0] setCoordinate:[[_myMeeting getMeetingLocationCoords] coordinate]];
        [meetingMapView setCenterCoordinate:[[_myMeeting getMeetingLocationCoords] coordinate] animated:NO];
        }
}

/*****************************************************************/
/**
 \brief Prints the view displayed on the screen.
 *****************************************************************/
- (void)printView
{
#ifdef DEBUG
    NSLog(@"BMLTMeetingDetailViewController::printView");
#endif
    printModal = [UIPrintInteractionController sharedPrintController];
    
    if ( printModal )
        {
        [printModal setPrintPageRenderer:[self getMyPageRenderer]];
        [printModal setPrintFormatter:[[self view] viewPrintFormatter]];
        if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad )
            {
            [printModal presentFromBarButtonItem:[[self navigationItem] rightBarButtonItem] animated:YES completionHandler:
#ifdef DEBUG
             ^(UIPrintInteractionController *printInteractionController, BOOL completed, NSError *error) {
                 if (!completed)
                     {
                     NSLog(@"BMLTMeetingDetailViewController::printView completionHandler: Print FAIL");
                     }
                 else
                     {
                     NSLog(@"BMLTMeetingDetailViewController::printView completionHandler: Print WIN");
                     }
             }
#else
             nil
#endif
             ];
            }
        else
            {
            [printModal presentAnimated:YES completionHandler:
#ifdef DEBUG
             ^(UIPrintInteractionController *printInteractionController, BOOL completed, NSError *error) {
                 if (!completed)
                     {
                     NSLog(@"BMLTMeetingDetailViewController::printView completionHandler: Print FAIL");
                     }
                 else
                     {
                     NSLog(@"BMLTMeetingDetailViewController::printView completionHandler: Print WIN");
                     }
             }
#else
             nil
#endif
             ];
            }
        }
}

/*****************************************************************/
/**
 \brief Called when the "Action Item" in the NavBar is clicked.
 *****************************************************************/
- (IBAction)actionItemClicked:(id)sender
{
#ifdef DEBUG
    NSLog(@"A_BMLTSearchResultsViewController::actionItemClicked:");
#endif
    [self printView];
}

/*****************************************************************/
/**
 \brief This toggles the map view between map and satellite.
 *****************************************************************/
- (IBAction)toggleMapView:(id)sender
{
    [[BMLTAppDelegate getBMLTAppDelegate] toggleThisMapView:[self meetingMapView] fromThisButton:[self _toggleButton]];
}

/*****************************************************************/
/**
 \brief This is called to dismiss the modal dialog or popover.
 *****************************************************************/
- (void)closeModal
{
    if (actionPopover)
        {
        [actionPopover dismissPopoverAnimated:YES];
        }
    else
        {
        [self dismissModalViewControllerAnimated:YES];
        }
    
    actionPopover = nil;
    printModal = nil;
}

/*****************************************************************/
/**
 \brief Instantiates and returns the appropriate page renderer
 \returns an instance of BMLT_DetailsPrintPageRenderer, disguised as a UIPrintPageRenderer
 *****************************************************************/
- (UIPrintPageRenderer *)getMyPageRenderer
{
    return [[BMLT_DetailsPrintPageRenderer alloc] initWithMeetings:[NSArray arrayWithObject:[self myMeeting]] andMapFormatter:[[self meetingMapView] viewPrintFormatter]];
}

#pragma mark - MkMapAnnotationDelegate Functions -

/*****************************************************************/
/**
 \brief Returns the view for the marker in the center of the map.
 \returns an annotation view, representing the marker.
 *****************************************************************/
- (MKAnnotationView *)mapView:(MKMapView *)mapView              ///< The map view
            viewForAnnotation:(id < MKAnnotation >)annotation   ///< The annotation C, in need of a V
{
    MKAnnotationView* ret = [mapView dequeueReusableAnnotationViewWithIdentifier:@"single_meeting_annotation"];
    
    if ( !ret )
        {
        ret = [[BMLT_Results_BlackAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"single_meeting_annotation"];
        }
    
    return ret;
}

/*****************************************************************/
/**
 \brief This will use the Web browser to get directions to the
        meeting from the user's current location.
 *****************************************************************/
- (IBAction)callForDirections:(id)sender    ///< The button we use for this URI.
{
    [[BMLTAppDelegate getBMLTAppDelegate] imVisitingRelatives];
    
    CLLocationCoordinate2D  meetingLocation = [_myMeeting getMeetingLocationCoords].coordinate;
    NSURL                   *helpfulGasStationAttendant = [BMLTVariantDefs directionsURITo:meetingLocation];
    
    [[UIApplication sharedApplication] openURL:helpfulGasStationAttendant];
}
@end
