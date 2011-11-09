//
//  MeetingDisplayCellView.m
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

#import "MeetingDisplayCellView.h"

@implementation BMLT_FormatButton

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (id)initWithFrame:(CGRect)frame
          andFormat:(BMLT_Format *)theFormat
{
    self = [super initWithFrame:frame];
    
    if ( self )
        {
        myFormat = nil;
        [self setMyFormat:theFormat];
        }
    
    return self;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)dealloc
{
    [myFormat release];
    [super dealloc];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setMyFormat:(BMLT_Format *)inFormat
{
    [inFormat retain];
    [myFormat release];
    myFormat = inFormat;
    if ( myFormat )
        {
        for ( UIView *sub in [self subviews] )
            {
            [sub removeFromSuperview];
            }
        
        FormatUIElements    fmtEl = [BMLT_Format getFormatColor:myFormat];
        [self setBackgroundImage:[UIImage imageNamed:fmtEl.imageName2x] forState:UIControlStateNormal];
        
        UILabel *theTitleView = [[UILabel alloc]initWithFrame:[self bounds]];
        
        if ( theTitleView )
            {
            [theTitleView setFont:[UIFont boldSystemFontOfSize:List_Meeting_Display_Text_Size]];
            [theTitleView setText:fmtEl.title];
            [theTitleView setTextColor:fmtEl.textColor];
            [theTitleView setBackgroundColor:[UIColor clearColor]];
            [theTitleView setTextAlignment:UITextAlignmentCenter];
            [self addSubview:theTitleView];
            [theTitleView release];
            }
        }
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (BMLT_Format *)getMyFormat
{
    return myFormat;
}

@end

@implementation MeetingDisplayCellView

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (id)initWithMeeting:(BMLT_Meeting *)inMeeting
             andFrame:(CGRect)frame
           andReuseID:(NSString *)reuseID
             andIndex:(int)index
{
    self = [super initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:reuseID];
    
    if ( self )
        {
        myMeeting = [inMeeting retain];
        frame.origin = CGPointZero;
        [self setFrame:frame];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth];
        wrapperView = [[UIView alloc] initWithFrame:frame];
        [wrapperView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        
        if ( index - (floor(index / 2) * 2) )
            {
            [wrapperView setBackgroundColor:[UIColor colorWithRed:.8 green:.9 blue:1 alpha:1]];
            }
        
        [self addSubview:wrapperView];
        }
    
    return self;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)layoutSubviews
{
    [self setMeetingName];
    [self setWeekdayAndTime];
    [self setTownAndState];
    [self setLocationAndAddress];
    [self setDistance];
    [self setFormats];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)dealloc
{
    [myModalController release];
    [myMeeting release];
    [wrapperView release];

    [super dealloc];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setMyModalController:(A_SearchController *)inController
{
    [inController retain];
    [myModalController release];
    myModalController = inController;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (A_SearchController *)getMyModalController
{
    return myModalController;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (BMLT_Meeting *)getMyMeeting
{
    return myMeeting;
}

/***************************************************************\**
 \brief 
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
        [textLabel release];
        }
}

/***************************************************************\**
 \brief 
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
        [weekdayLabel release];
        }
    
    boundsRect.origin.x += boundsRect.size.width;
    boundsRect.size.width = List_Meeting_Format_Time_Width;

    UILabel *timeLabel = [[UILabel alloc] initWithFrame:boundsRect];
    
    if ( timeLabel )
        {
        [timeLabel setFont:theFont];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        NSDate      *startTime = [myMeeting getStartTime];
        NSString    *timeString = [NSDateFormatter localizedStringFromDate:startTime dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
        NSCalendar  *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        
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
            [gregorian release];
            }

        [timeLabel setText:timeString];
        [timeLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
        [wrapperView addSubview:timeLabel];
        [timeLabel release];
        }
}

/***************************************************************\**
 \brief 
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
        [townLabel release];
        }
}

/***************************************************************\**
 \brief 
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
        
        [meetingText setFont:[UIFont boldSystemFontOfSize:List_Meeting_Display_Text_Size]];
        [meetingText setTextAlignment:UITextAlignmentCenter];
        [meetingText setAdjustsFontSizeToFitWidth:YES];
        [meetingText setBackgroundColor:[UIColor clearColor]];
        [meetingText setText:meetingLocationString];
        [meetingText setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth];
        [wrapperView addSubview:meetingText];
        [meetingText release];
        }
}

/***************************************************************\**
 \brief 
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
            NSString    *units = NSLocalizedString(@"DISTANCE-UNITS", nil);
            double      distance = [(NSString *)[myMeeting getValueFromField:@"distance_in_km"] doubleValue] / ([units isEqualToString:@"KM"] ? 1.0 : 1.609344);
            distance = round(distance * 100) / 100.0;
            NSString    *distanceString = [NSString stringWithFormat:@"%.2F %@", distance, ([units isEqualToString:@"KM"] ? NSLocalizedString(@"DISTANCE-KM", nil) : NSLocalizedString(@"DISTANCE-MILE", nil))];
            [distanceLabel setText:distanceString];
            [distanceLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
            [wrapperView addSubview:distanceLabel];
            [distanceLabel release];
            }
        }
}

/***************************************************************\**
 \brief 
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
                    [newButton release];
                    }
                
                formatsBounds.size.width += List_Meeting_Format_Circle_Size + List_Meeting_Format_Line_Padding;
                boundsRect.origin.x += List_Meeting_Format_Circle_Size + List_Meeting_Format_Line_Padding;
                }
            
            formatsBounds.size.width -= List_Meeting_Format_Line_Padding;
            boundsRect = [self bounds];
            formatsBounds.origin.x = (boundsRect.size.width - formatsBounds.size.width) / 2;
            [formatsView setFrame:formatsBounds];
            [formatsView setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleLeftMargin];
            [wrapperView addSubview:formatsView];
            [formatsView release];
            }
        }
}
@end
