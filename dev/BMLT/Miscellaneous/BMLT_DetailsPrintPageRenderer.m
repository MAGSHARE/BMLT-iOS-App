//
//  BMLT_DetailsPrintPageRenderer.m
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

#import "BMLT_DetailsPrintPageRenderer.h"
#import "BMLT_Meeting.h"

@implementation BMLT_DetailsPrintPageRenderer
@synthesize myMapFormatter;   ///< This will contain the map print formatter.

static float    kHeaderHeight   = 100.0;

/**************************************************************//**
 \brief Initializer with initial info.
 \returns self
 *****************************************************************/
- (id)initWithMeetings:(NSArray *)inMeetings                ///< An NSArray of BMLT_Meeting objects that describe the list of meetings. For this class, it will always only be one element in size.
       andMapFormatter:(UIViewPrintFormatter *)inFormatter  ///< The print formatter for the displayed map (can be nil).
{
    assert([inMeetings count] == 1);    // There can only be one...
    
    self = [super initWithMeetings:inMeetings andMapFormatter:inFormatter];
    
    if ( self )
        {
        [self setHeaderHeight:kHeaderHeight];   // This class uses the header for all its info.
        }
    
    return self;
}

/**************************************************************//**
 \brief This is how many pages we'll need to print.
 \returns an integer. Always 1
 *****************************************************************/
- (NSInteger)numberOfPages
{
#ifdef DEBUG
    NSLog(@"BMLT_DetailsPrintPageRenderer::numberOfPages:");
#endif
    return 1;
}

/**************************************************************//**
 \brief This will draw up the header, which contains most of the info.
 *****************************************************************/
- (void)drawHeaderForPageAtIndex:(NSInteger)index  ///< The page index
                          inRect:(CGRect)inRect    ///< The header rect
{
#ifdef DEBUG
    NSLog(@"BMLT_DetailsPrintPageRenderer::drawHeaderForPageAtIndex: %d inRect: (%f, %f), (%f, %f)", index, inRect.origin.x, inRect.origin.y, inRect.size.width, inRect.size.height );
#endif
    BMLT_Meeting    *myMeeting = (BMLT_Meeting *)[[self myMeetings] objectAtIndex:0];
    
    UIFont  *currentFont = [UIFont boldSystemFontOfSize:kFontSizeOfMeetingName];    // We will use this variable to hold whatever font we're working with.
    
    inRect.origin.x += kLeftPadding;
    inRect.size.width -= kLeftPadding + kRightPadding;
    
    [[myMeeting getBMLTName] drawInRect:inRect withFont:currentFont lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentLeft];
    
    float   lineHeight = [[myMeeting getBMLTName] sizeWithFont:currentFont].height + kDisplayGap;
    inRect.origin.y += lineHeight;      // Adjust the next line top...
    inRect.size.height -= lineHeight;   // ...and the size
    
    // We indent the meeting info slightly.
    inRect.origin.x += kLeftPadding;
    inRect.size.width -= kLeftPadding;
    
    lineHeight = [self drawTownStateDayAndTime:myMeeting inRect:inRect];
    
    inRect.origin.y += lineHeight + kDisplayGap;
    inRect.size.height -= lineHeight + kDisplayGap;
    
    lineHeight = [self drawAddress:myMeeting inRect:inRect];
    
    inRect.origin.y += lineHeight + kDisplayGap;
    inRect.size.height -= lineHeight + kDisplayGap;
    
    lineHeight = [self drawFormats:myMeeting inRect:inRect];
    
    inRect.origin.y += lineHeight + kDisplayGap;
    inRect.size.height -= lineHeight + kDisplayGap;
    
    [self drawComments:myMeeting inRect:inRect];
}

@end
