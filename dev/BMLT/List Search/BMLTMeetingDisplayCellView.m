//
//  MeetingDisplayCellView.m
//  BMLT
//
//  Created by MAGSHARE
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

#import "BMLTMeetingDisplayCellView.h"

static int List_Meeting_Annotation_Size                = 26;
static int List_Meeting_Name_Text_Size                 = 16;
static int List_Meeting_Display_Text_Size              = 12;
static int List_Meeting_Format_Distance_Label_Width    = 70;
static int List_Meeting_Format_Weekday_Width           = 70;
static int List_Meeting_Format_Time_Width              = 120;
static int List_Meeting_Format_Town_Width              = 160;

int List_Meeting_Display_Line_Height                   = 25;

@implementation BMLTMeetingDisplayCellView

/**************************************************************//**
 \brief     This is the initializer with a meeting and other info.
 \returns   self
 *****************************************************************/
- (id)initWithMeeting:(BMLT_Meeting *)inMeeting ///< The meeting object for this cell.
             andFrame:(CGRect)frame             ///< The containing frame.
           andReuseID:(NSString *)reuseID       ///< The cell's reuse ID (we don't use this, anyway)
             andIndex:(int)index                ///< The cells, index in the order (so we know what background to use).
{
    self = [super initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:reuseID];
    
    if ( self )
        {
        myMeeting = inMeeting;
        frame.origin = CGPointZero;
        [self setFrame:frame];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth];
        wrapperView = [[UIView alloc] initWithFrame:frame];
        [wrapperView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        
        UIColor *myBGColor1 = [[UIColor alloc] initWithCGColor:[[BMLTVariantDefs getSortOddColor] CGColor]];
        UIColor *myBGColor2 = [[UIColor alloc] initWithCGColor:[[BMLTVariantDefs getSortEvenColor] CGColor]];

        if ( index - (floor(index / 2) * 2) )
            {
            [wrapperView setBackgroundColor:myBGColor1];
            }
        else
            {
            [wrapperView setBackgroundColor:myBGColor2];
            }
        
        myBGColor1 = nil;
        myBGColor2 = nil;
        
        [self addSubview:wrapperView];
        }
    
    return self;
}

/**************************************************************//**
 \brief This is where we fill out all the values.
 *****************************************************************/
- (void)layoutSubviews
{
    [self setAnnotation];
    [self setMeetingName];
    [self setWeekdayAndTime];
    [self setTownAndState];
    [self setLocationAndAddress];
    [self setDistance];
    [self setFormats];
}

/**************************************************************//**
 \brief 
 *****************************************************************/
- (void)drawRect:(CGRect)rect
forViewPrintFormatter:(UIViewPrintFormatter *)formatter
{
#ifdef DEBUG
    NSLog(@"BMLTMeetingDisplayCellView::drawRect: forViewPrintFormatter:");
#endif
}

/**************************************************************//**
 \brief This is the controller for our modal dialogs (We like to use the top).
 *****************************************************************/
- (void)setMyModalController:(BMLTDisplayListResultsViewController *)inController   ///< The controller in question.
{
    myModalController = inController;
}

/**************************************************************//**
 \brief This is an accessor to get our controller.
 \returns The reference to our modal controller.
 *****************************************************************/
- (BMLTDisplayListResultsViewController *)getMyModalController
{
    return myModalController;
}

/**************************************************************//**
 \brief Returns the meeting object for this cell.
 \returns the meeting object in question.
 *****************************************************************/
- (BMLT_Meeting *)getMyMeeting
{
    return myMeeting;
}

/**************************************************************//**
 \brief Sets the item that draws the annotation key.
 *****************************************************************/
- (void)setAnnotation
{
    if ( [myMeeting meetingIndex] )
        {
        NSString    *myNum = [NSString stringWithFormat:@"%d", [myMeeting meetingIndex]];
#ifdef DEBUG
        NSLog(@"BMLTMeetingDisplayCellView::setAnnotation %@", myNum);
#endif
        UILabel    *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, List_Meeting_Annotation_Size, List_Meeting_Annotation_Size)];
        if ( textLabel )
            {
            [textLabel setBackgroundColor:[myMeeting partOfMulti] ? [UIColor colorWithRed:0.9 green:0 blue:0 alpha:1] : [UIColor colorWithRed:0 green:0 blue:0.9 alpha:1]];
            [textLabel setTextAlignment:UITextAlignmentCenter];
            [textLabel setAdjustsFontSizeToFitWidth:YES];
            [textLabel setFont:[UIFont boldSystemFontOfSize:List_Meeting_Name_Text_Size]];
            [textLabel setTextColor:[UIColor whiteColor]];
            [textLabel setText:myNum];
            [wrapperView addSubview:textLabel];
            }
        }
}

/**************************************************************//**
 \brief This sets up the meeting name header.
 *****************************************************************/
- (void)setMeetingName
{
    CGRect  boundsRect = [self bounds];
    
    boundsRect.size.height = List_Meeting_Display_Line_Height;
    
    UILabel    *textLabel = [[UILabel alloc] initWithFrame:boundsRect];
    if ( textLabel )
        {
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:UITextAlignmentCenter];
        [textLabel setAdjustsFontSizeToFitWidth:YES];
        [textLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth];
        [textLabel setFont:[UIFont boldSystemFontOfSize:List_Meeting_Name_Text_Size]];
        [textLabel setText:[myMeeting getBMLTName]];
        [wrapperView addSubview:textLabel];
        }
}

/**************************************************************//**
 \brief This sets up the weekday and time info.
 *****************************************************************/
- (void)setWeekdayAndTime
{
    CGRect  origBoundsRect = [self bounds];
    CGRect  boundsRect = origBoundsRect;
    boundsRect.size.height = List_Meeting_Display_Line_Height;
    boundsRect.origin.x = List_Meeting_Format_Line_Padding;
    boundsRect.origin.y = List_Meeting_Display_Line_Height;
    boundsRect.size.width = List_Meeting_Format_Weekday_Width;
    
    UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:boundsRect];
    UIFont  *theFont = [UIFont boldSystemFontOfSize:List_Meeting_Display_Text_Size];
    
    if ( weekdayLabel )
        {
        [weekdayLabel setFont:theFont];
        [weekdayLabel setBackgroundColor:[UIColor clearColor]];
        [weekdayLabel setText:[myMeeting getWeekday]];
        [weekdayLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
        [wrapperView addSubview:weekdayLabel];
        }
    
    boundsRect.origin.x += boundsRect.size.width;
    boundsRect.size.width = List_Meeting_Format_Time_Width;

    UILabel *timeLabel = [[UILabel alloc] initWithFrame:boundsRect];
    
    if ( timeLabel )
        {
        [timeLabel setFont:theFont];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        NSDate      *timeDate = [myMeeting getStartTime];
        NSString    *timeString = [NSDateFormatter localizedStringFromDate:timeDate dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
        NSCalendar  *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSDateComponents    *dateComp = [gregorian components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:timeDate];
        
        float   adder = 0.0;
        
        if ( [dateComp hour] >= 23 && [dateComp minute] > 45 )
            {
            timeString = NSLocalizedString(@"TIME-MIDNIGHT", nil);
            adder = 60.0;
            }
        else if ( [dateComp hour] == 12 && [dateComp minute] == 0 )
            {
            timeString = NSLocalizedString(@"TIME-NOON", nil);
            }
        
        NSTimeInterval  duration = [myMeeting getDuration] + adder;
        timeDate = [timeDate dateByAddingTimeInterval:duration];
        NSString    *timeString2 = [NSDateFormatter localizedStringFromDate:timeDate dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
        dateComp = [gregorian components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:timeDate];
            
        if ( [dateComp hour] >= 23 && [dateComp minute] > 45 )
            {
            timeString2 = NSLocalizedString(@"TIME-MIDNIGHT", nil);
            }
        else if ( [dateComp hour] == 12 && [dateComp minute] == 0 )
            {
            timeString2 = NSLocalizedString(@"TIME-NOON", nil);
            }
        
        timeString = [timeString stringByAppendingFormat:@" - %@", timeString2];
        [timeLabel setText:timeString];
        [timeLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
        [wrapperView addSubview:timeLabel];
        }
}

/**************************************************************//**
 \brief This sets the town and state.
 *****************************************************************/
- (void)setTownAndState
{
    CGRect  origBoundsRect = [self bounds];
    CGRect  boundsRect = origBoundsRect;
    boundsRect.size.height = List_Meeting_Display_Line_Height;
    boundsRect.origin.x = boundsRect.size.width - ((List_Meeting_Format_Line_Padding *2) + List_Meeting_Format_Town_Width);
    boundsRect.origin.y = List_Meeting_Display_Line_Height;
    boundsRect.size.width = List_Meeting_Format_Town_Width;
    
    UILabel *townLabel = [[UILabel alloc] initWithFrame:boundsRect];
    
    if ( townLabel )
        {
        NSString    *town = @"";
        
        if ( [myMeeting getValueFromField:@"location_province"] )
            {
            town = [NSString stringWithFormat:@"%@, %@", (([myMeeting getValueFromField:@"location_city_subsection"]) ? (NSString *)[myMeeting getValueFromField:@"location_city_subsection"] : (NSString *)[myMeeting getValueFromField:@"location_municipality"]), (NSString *)[myMeeting getValueFromField:@"location_province"]];
            }
        else
            {
            town = [NSString stringWithString: (([myMeeting getValueFromField:@"location_city_subsection"]) ? (NSString *)[myMeeting getValueFromField:@"location_city_subsection"] : (NSString *)[myMeeting getValueFromField:@"location_municipality"])];
            }
        [townLabel setTextAlignment:UITextAlignmentRight];
        [townLabel setFont:[UIFont boldSystemFontOfSize:List_Meeting_Display_Text_Size]];
        [townLabel setBackgroundColor:[UIColor clearColor]];
        [townLabel setText:town];
        [townLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [wrapperView addSubview:townLabel];
        }
}

/**************************************************************//**
 \brief This sets up the address information.
 *****************************************************************/
- (void)setLocationAndAddress
{
    CGRect  origBoundsRect = [self bounds];
    CGRect  boundsRect = origBoundsRect;
    boundsRect.size.height = List_Meeting_Display_Line_Height;
    boundsRect.origin.x = List_Meeting_Format_Line_Padding;
    boundsRect.size.width -= (List_Meeting_Format_Line_Padding * 2);
    boundsRect.origin.y = (List_Meeting_Display_Line_Height * 2);
    
    UILabel *meetingText = [[UILabel alloc] initWithFrame:boundsRect];
    
    if ( meetingText )
        {
        NSString    *meetingLocationString = [NSString stringWithFormat:@"%@%@", (([myMeeting getValueFromField:@"location_text"]) ? [NSString stringWithFormat:@"%@, ", (NSString *)[myMeeting getValueFromField:@"location_text"]] : @""), [myMeeting getValueFromField:@"location_street"]];
        
        if ( !meetingLocationString )
            {
            meetingLocationString =  @"";
            }
        
        [meetingText setFont:[UIFont boldSystemFontOfSize:List_Meeting_Display_Text_Size]];
        [meetingText setTextAlignment:UITextAlignmentCenter];
        [meetingText setAdjustsFontSizeToFitWidth:YES];
        [meetingText setBackgroundColor:[UIColor clearColor]];
        [meetingText setText:meetingLocationString];
        [meetingText setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth];
        [wrapperView addSubview:meetingText];
        }
}

/**************************************************************//**
 \brief This displays the distance, as given by the meeting.
 *****************************************************************/
- (void)setDistance
{
    CGRect  origBoundsRect = [self bounds];
    CGRect  boundsRect = origBoundsRect;
    boundsRect.size.height = List_Meeting_Display_Line_Height;
    boundsRect.origin.x = boundsRect.size.width - (List_Meeting_Format_Line_Padding + List_Meeting_Format_Distance_Label_Width);
    boundsRect.origin.y = (List_Meeting_Display_Line_Height * 3);
    boundsRect.size.width = List_Meeting_Format_Distance_Label_Width;
    
    if ( [myMeeting getValueFromField:@"distance_in_km"] )
        {
        UILabel *distanceLabel = [[UILabel alloc] initWithFrame:boundsRect];
        
        if ( distanceLabel )
            {
            [distanceLabel setFont:[UIFont boldSystemFontOfSize:List_Meeting_Display_Text_Size]];
            [distanceLabel setBackgroundColor:[UIColor clearColor]];
            [distanceLabel setTextAlignment:UITextAlignmentRight];
            NSString    *units = [BMLTVariantDefs distanceUnits];
            double      distance = [(NSString *)[myMeeting getValueFromField:@"distance_in_km"] doubleValue] / ([units isEqualToString:@"KM"] ? 1.0 : 1.609344);
            distance = round(distance * 100) / 100.0;
            NSString    *distanceString = [NSString stringWithFormat:@"%.2F %@", distance, ([units isEqualToString:@"KM"] ? NSLocalizedString(@"DISTANCE-KM", nil) : NSLocalizedString(@"DISTANCE-MILE", nil))];
            [distanceLabel setText:distanceString];
            [distanceLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
            [wrapperView addSubview:distanceLabel];
            }
        }
}

/**************************************************************//**
 \brief This sets up the format clickable circles.
 *****************************************************************/
- (void)setFormats
{
    NSArray *formats = [myMeeting getFormats];
    
    if ( [formats count] )
        {
        CGRect  boundsRect = [self bounds];
        boundsRect.size.height = List_Meeting_Display_Line_Height;
        boundsRect.origin.y = List_Meeting_Display_Line_Height * 3;
        
        UIView  *formatsView = [[UIView alloc] initWithFrame:boundsRect];
       
        if ( formatsView )
            {
            CGRect  formatsBounds = boundsRect;
            formatsBounds.size.width = 0;

            boundsRect.origin = CGPointZero;
            boundsRect.origin.y = (List_Meeting_Display_Line_Height - List_Meeting_Format_Circle_Size) / 2;
            boundsRect.size.width = boundsRect.size.height = List_Meeting_Format_Circle_Size;
            
            for ( BMLT_Format *format in formats )
                {
                BMLT_FormatButton   *newButton = [[BMLT_FormatButton alloc] initWithFrame:boundsRect andFormat:format];
                
                if ( newButton )
                    {
                    [newButton addTarget:[self getMyModalController] action:@selector(displayFormatDetail:) forControlEvents:UIControlEventTouchUpInside];
                    [formatsView addSubview:newButton];
                    }
                
                formatsBounds.size.width += List_Meeting_Format_Circle_Size + List_Meeting_Format_Line_Padding;
                boundsRect.origin.x += List_Meeting_Format_Circle_Size + List_Meeting_Format_Line_Padding;
                }
            
            formatsBounds.size.width -= List_Meeting_Format_Line_Padding;
            boundsRect = [self bounds];
            formatsBounds.origin.x = (boundsRect.size.width - formatsBounds.size.width) / 2;
            
            // This odd bit of code is because sometimes long formats lists can overwrite the distance, and we want to nudge to the left, if so.
            if ( (formatsBounds.origin.x + formatsBounds.size.width) > (boundsRect.size.width - List_Meeting_Format_Distance_Label_Width) )
                {
                formatsBounds.origin.x -= ((formatsBounds.origin.x + formatsBounds.size.width) - (boundsRect.size.width - List_Meeting_Format_Distance_Label_Width));
                }
            
            [formatsView setFrame:formatsBounds];
            [formatsView setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleLeftMargin];
            [wrapperView addSubview:formatsView];
            }
        }
}
@end
