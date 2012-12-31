//
//  A_BMLT_PrintPageRenderer.m
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

#import "A_BMLT_PrintPageRenderer.h"

/*****************************************************************/
/**
 \class A_BMLT_PrintPageRenderer
 \brief This is an abstract base class that implements a print formatter.
 *****************************************************************/
@implementation A_BMLT_PrintPageRenderer
@synthesize myMeetings = _myMeetings;

/*****************************************************************/
/**
 \brief initializer with the meetings to be displayed.
 \returns self
 *****************************************************************/
- (id)initWithMeetings:(NSArray *)inMeetings    ///< The list of BMLT_Meeting objects to be displayed.
{
#ifdef DEBUG
    NSLog(@"A_BMLT_PrintPageRenderer initWithMeetings: (%d meetings)", [inMeetings count]);
#endif
    self = [super init];
    
    if ( self )
        {
        _myMeetings = inMeetings;
        }
    
    return self;
}

/*****************************************************************/
/**
 \brief This is how many pages we'll need to print.
 \returns an integer. Always 0, as this is an abstract class.
 *****************************************************************/
- (NSInteger)numberOfPages
{
#ifdef DEBUG
    NSLog(@"A_BMLT_PrintPageRenderer::numberOfPages:");
#endif
    return 0;
}

/*****************************************************************/
/**
 \brief Prepares for drawing. Set up any initial stuff here.
 *****************************************************************/
- (void)prepareForDrawingPages:(NSRange)range   ///< The range of pages to be drawn.
{
#ifdef DEBUG
    NSLog(@"A_BMLT_PrintPageRenderer prepareForDrawingPages: From page %d, to page %d", range.location, range.length);
#endif
}

/*****************************************************************/
/**
 \brief Draw the header for the printed page.
 *****************************************************************/
- (void)drawHeaderForPageAtIndex:(NSInteger)index  ///< The page index
                          inRect:(CGRect)inRect    ///< The content rect
{
#ifdef DEBUG
    NSLog(@"A_BMLT_PrintPageRenderer drawHeaderForPageAtIndex: %d inRect: (%f, %f), (%f, %f)", index, inRect.origin.x, inRect.origin.y, inRect.size.width, inRect.size.height );
#endif
}

/*****************************************************************/
/**
 \brief This is ignored in the superclass.
 *****************************************************************/
- (void)drawContentForPageAtIndex:(NSInteger)index  ///< The page index
                           inRect:(CGRect)inRect    ///< The content rect
{
#ifdef DEBUG
    NSLog(@"A_BMLT_PrintPageRenderer drawContentForPageAtIndex: %d inRect: (%f, %f), (%f, %f)", index, inRect.origin.x, inRect.origin.y, inRect.size.width, inRect.size.height );
#endif
}

/*****************************************************************/
/**
 \brief Draw the footer for the printed page.
 *****************************************************************/
- (void)drawFooterForPageAtIndex:(NSInteger)index  ///< The page index
                          inRect:(CGRect)inRect    ///< The content rect
{
#ifdef DEBUG
    NSLog(@"A_BMLT_PrintPageRenderer drawFooterForPageAtIndex: %d inRect: (%f, %f), (%f, %f)", index, inRect.origin.x, inRect.origin.y, inRect.size.width, inRect.size.height );
#endif
}
@end
