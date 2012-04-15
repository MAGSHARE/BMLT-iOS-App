//
//  BMLTFormattedOutputSmartView.m
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

#import "BMLTFormattedOutputSmartView.h"
#import "BMLT_Meeting.h"

/**************************************************************//**
 \class BMLTFormattedOutputSmartView
 \brief Draws a customized version of the search results for print or PDF
        This uses a pattern I've used a number of times: "Smart View."
        It's an amalgam of a V and a C in the MVC pattern. Basically,
        it's a view that can accept some model data, and is "smart"
        enough to draw itself, based on that data. It is a great deal
        simpler and less cumbersome to make this an atomic class,
        as opposed to separate V and C classes. Also, it can easily
        be repurposed and handed to different controllers for display.
 *****************************************************************/
@implementation BMLTFormattedOutputSmartView
@synthesize myMeetings = _myMeetings;

/**************************************************************//**
 \brief Initializes with model data
 \returns self
 *****************************************************************/
- (id)initWithFrame:(CGRect)inFrame         ///< The view frame.
     andMeetingList:(NSArray *)inMeetings   ///< The model data (an array of BMLT_Meeting objects. If just one, then the view produces a detailed drawing)
{
#ifdef DEBUG
    NSLog( @"BMLTFormattedOutputSmartView::initWithFrame: (%f, %f), (%f, %f) andMeetingList: (%d entries)", inFrame.origin.x, inFrame.origin.y, inFrame.size.width, inFrame.size.height, [inMeetings count] );
#endif
    self = [super initWithFrame:inFrame];
    if (self)
        {
        _myMeetings = inMeetings;
        }
    return self;
}

/**************************************************************//**
 \brief Rolls up its sleeves, and draws the data. rect is ignored.
 *****************************************************************/
- (void)drawRect:(CGRect)rect   ///< We ignore the requested rect, and draw the whole damn thing, every time.
{
#ifdef DEBUG
    NSLog( @"BMLTFormattedOutputSmartView::drawRect: (%f, %f), (%f, %f)", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height );
#endif
}

/**************************************************************//**
 \brief This allows us to do special stuff when printing.
 *****************************************************************/
- (void)drawRect:(CGRect)rect                           ///< The requested rect (ignored)
forViewPrintFormatter:(UIViewPrintFormatter *)formatter ///< The print formatter object.
{
#ifdef DEBUG
    NSLog( @"BMLTFormattedOutputSmartView::drawRect: (%f, %f), (%f, %f) forViewPrintFormatter:", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height );
#endif
}

@end
