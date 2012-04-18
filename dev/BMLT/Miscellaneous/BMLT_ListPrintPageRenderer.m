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

/**************************************************************//**
 \class BMLT_ListPrintPageRenderer
 \brief This is a concrete class that implements a list display print.
 *****************************************************************/
@implementation BMLT_ListPrintPageRenderer
@synthesize myMapFormatter; ///< This will contain the map print formatter.

- (id)initWithMeetings:(NSArray *)inMeetings
       andMapFormatter:(UIViewPrintFormatter *)inFormatter
{
    self = [super initWithMeetings:inMeetings];
    
    if ( self )
        {
        [self setMyMapFormatter:inFormatter];
        }
    
    return self;
}

/**************************************************************//**
 \brief This is how many pages we'll need to print.
 \returns an integer, with the number of pages to print.
 *****************************************************************/
- (NSInteger)numberOfPages
{
    NSInteger   pages = (NSInteger)ceil ( (float)[[self myMeetings] count] / (float)kNumberOfMeetingsPerPage ) + (([self myMapFormatter] == nil) ? 0 : 1);
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
    if ( range.location == 0 && ([self myMapFormatter] != nil) )
        {
        [self addPrintFormatter:[self myMapFormatter] startingAtPageAtIndex:0];
        }
}

/**************************************************************//**
 \brief This will draw up the content for this list of meetings.
 *****************************************************************/
- (void)drawContentForPageAtIndex:(NSInteger)index  ///< The page index
                           inRect:(CGRect)inRect    ///< The content rect
{
    if ( index > 0 || ([self myMapFormatter] == nil) )
        {
        int   firstMeetingIndex = kNumberOfMeetingsPerPage * (index - (([self myMapFormatter] == nil) ? 0 : 1));
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
@end
