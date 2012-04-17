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

/**************************************************************//**
 \class A_BMLT_PrintPageRenderer
 \brief This is an abstract base class that implements a print formatter.
 *****************************************************************/
@implementation A_BMLT_PrintPageRenderer
@synthesize myMeetings = _myMeetings;

/**************************************************************//**
 \brief initializer with the meetings to be displayed.
 \returns self
 *****************************************************************/
- (id)initWithMeetings:(NSArray *)inMeetings
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

/**************************************************************//**
 \brief 
 *****************************************************************/
- (void)prepareForDrawingPages:(NSRange)range
{
#ifdef DEBUG
    NSLog(@"A_BMLT_PrintPageRenderer prepareForDrawingPages: range.location: %d, range.length: %d", range.location, range.length);
#endif
}

/**************************************************************//**
 \brief 
 *****************************************************************/
- (void)drawHeaderForPageAtIndex:(NSInteger)index
                          inRect:(CGRect)inRect
{
#ifdef DEBUG
    NSLog(@"A_BMLT_PrintPageRenderer drawHeaderForPageAtIndex: %d inRect: (%f, %f), (%f, %f)", index, inRect.origin.x, inRect.origin.y, inRect.size.width, inRect.size.height );
#endif
}

/**************************************************************//**
 \brief 
 *****************************************************************/
- (void)drawContentForPageAtIndex:(NSInteger)index
                           inRect:(CGRect)inRect
{
#ifdef DEBUG
    NSLog(@"A_BMLT_PrintPageRenderer drawContentForPageAtIndex: %d inRect: (%f, %f), (%f, %f)", index, inRect.origin.x, inRect.origin.y, inRect.size.width, inRect.size.height );
#endif
}

/**************************************************************//**
 \brief 
 *****************************************************************/
- (void)drawFooterForPageAtIndex:(NSInteger)index
                          inRect:(CGRect)inRect
{
#ifdef DEBUG
    NSLog(@"A_BMLT_PrintPageRenderer drawFooterForPageAtIndex: %d inRect: (%f, %f), (%f, %f)", index, inRect.origin.x, inRect.origin.y, inRect.size.width, inRect.size.height );
#endif
}
@end
