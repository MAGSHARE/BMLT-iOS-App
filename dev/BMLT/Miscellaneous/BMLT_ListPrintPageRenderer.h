//
//  BMLTPrintPageRenderer.h
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

#import <UIKit/UIKit.h>
#import "A_BMLT_PrintPageRenderer.h"
#import <MapKit/MapKit.h>

@class BMLT_Meeting;

extern int  kLeftPadding;                   ///< The number of pixels in from the left edge of the paper.
extern int  kRightPadding;                  ///< The number of pixels in from the right edge of the paper.
extern int  kFontSizeOfMeetingName;         ///< The font size, in points, of the meeting name.
extern int  kFontSizeOfMeetingTownState;    ///< The font size, in points, of the meeting town and state display.
extern int  kFontSizeOfAddress;             ///< The font size for the address line.
extern int  kFontSizeOfFormats;             ///< The size of the formats strings.
extern int  kFontSizeOfComments;            ///< The size of the comments string.
extern int  kDisplayGap;                    ///< The vertical space between lines, in the meeting display.

/*****************************************************************/
/**
 \class BMLT_ListPrintPageRenderer
 \brief This is a concrete class that implements a list display print.
 *****************************************************************/
@interface BMLT_ListPrintPageRenderer : A_BMLT_PrintPageRenderer <MKMapViewDelegate>
@property (retain, atomic, readwrite)  UIViewPrintFormatter *myMapFormatter;   ///< This will contain the map print formatter.

- (id)initWithMeetings:(NSArray *)inMeetings andMapFormatter:(UIViewPrintFormatter *)inFormatter;
- (int)drawOneMeeting:(BMLT_Meeting *)inMeeting inRect:(CGRect)inRect;
- (int)drawTownStateDayAndTime:(BMLT_Meeting *)inMeeting inRect:(CGRect)inRect;
- (int)drawAddress:(BMLT_Meeting *)inMeeting inRect:(CGRect)inRect;
- (int)drawFormats:(BMLT_Meeting *)inMeeting inRect:(CGRect)inRect;
- (int)drawComments:(BMLT_Meeting *)inMeeting inRect:(CGRect)inRect;
@end
