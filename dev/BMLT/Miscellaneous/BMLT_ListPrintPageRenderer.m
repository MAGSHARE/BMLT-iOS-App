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

static int  kNumberOfMeetingsPerPage    = 10;   ///< This is how many meetings we can list per page.
static int  kFontSizeOfMeetingName      = 16;   ///< The font size, in points, of the meeting name.
static int  kDisplayGap                 = 4;    ///< The vertical space between lines, in the meeting display.

/**************************************************************//**
 \class BMLT_ListPrintPageRenderer
 \brief This is a concrete class that implements a list display print.
 *****************************************************************/
@implementation BMLT_ListPrintPageRenderer

/**************************************************************//**
 \brief This is how many pages we'll need to print.
 \returns an integer, with the number of pages to print.
 *****************************************************************/
- (NSInteger)numberOfPages
{
    NSInteger   pages = (NSInteger)ceil ( (float)[[self myMeetings] count] / (float)kNumberOfMeetingsPerPage );
#ifdef DEBUG
    NSLog(@"BMLT_ListPrintPageRenderer::numberOfPages: (%d meetings, %d meetings per page, %d pages)", [[self myMeetings] count], kNumberOfMeetingsPerPage, pages);
#endif
    return pages;
}

/**************************************************************//**
 \brief This will draw up the content for this list of meetings.
 *****************************************************************/
- (void)drawContentForPageAtIndex:(NSInteger)index  ///< The page index
                           inRect:(CGRect)inRect    ///< The content rect
{
    int   firstMeetingIndex = kNumberOfMeetingsPerPage * index;
    int   lastMeetingIndex = MIN( firstMeetingIndex + kNumberOfMeetingsPerPage, [[self myMeetings] count]) - 1;
    
#ifdef DEBUG
    NSLog(@"BMLT_ListPrintPageRenderer::drawContentForPageAtIndex: %d inRect: (%f, %f), (%f, %f). %d meetings. First Meeting Index is %d. Last Meeting Index is %d", index, inRect.origin.x, inRect.origin.y, inRect.size.width, inRect.size.height, [[self myMeetings] count], firstMeetingIndex, lastMeetingIndex);
#endif
    
    float   meetingCellHeight = (inRect.size.height / (float)kNumberOfMeetingsPerPage);
    
    CGRect  meetingCellRect = inRect;
    
    meetingCellRect.size.height = meetingCellHeight;
    
    // Cycle through all the meetings, and 
    for ( int myInd = firstMeetingIndex; myInd <= lastMeetingIndex; myInd++ )
        {
        [self drawOneMeeting:(BMLT_Meeting *)[[self myMeetings] objectAtIndex:myInd] inRect:meetingCellRect];
        meetingCellRect.origin.y += meetingCellRect.size.height;
        }
}

/**************************************************************//**
 \brief This will draw one meeting in the list.
 *****************************************************************/
- (void)drawOneMeeting:(BMLT_Meeting *)inMeeting    ///< The meeting object to be drawn.
                inRect:(CGRect)inRect               ///< The rect in which it is to be drawn.
{
#ifdef DEBUG
    NSLog(@"BMLT_ListPrintPageRenderer::drawOneMeeting: inRect: (%f, %f), (%f, %f). Meeting named \"%@\"", inRect.origin.x, inRect.origin.y, inRect.size.width, inRect.size.height, [inMeeting getBMLTName]);
#endif
    UIFont  *currentFont = [UIFont boldSystemFontOfSize:kFontSizeOfMeetingName];    // We will use this variable to hold whatever font we're working with.
    
    [[inMeeting getBMLTName] drawInRect:inRect withFont:currentFont lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentCenter];
    
    float   lineHeight = [[inMeeting getBMLTName] sizeWithFont:currentFont].height + kDisplayGap;
    inRect.origin.y += lineHeight;      // Adjust the next line top...
    inRect.size.height -= lineHeight;   // ...and the size
}

@end
