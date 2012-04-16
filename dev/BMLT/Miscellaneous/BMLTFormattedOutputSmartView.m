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

static int  kNumberOfMeetingsPerListPage = 10;

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
@synthesize myMeetings = _myMeetings, isPDF = _isPDF;

/**************************************************************//**
 \brief Initializes with model data
 \returns self
 *****************************************************************/
- (id)initWithFrame:(CGRect)inFrame         ///< The view frame.
     andMeetingList:(NSArray *)inMeetings   ///< The model data (an array of BMLT_Meeting objects. If just one, then the view produces a detailed drawing)
              asPDF:(BOOL)isPDF
{
#ifdef DEBUG
    NSLog( @"BMLTFormattedOutputSmartView::initWithFrame: (%f, %f), (%f, %f) andMeetingList: (%d entries)", inFrame.origin.x, inFrame.origin.y, inFrame.size.width, inFrame.size.height, [inMeetings count] );
#endif
    self = [super initWithFrame:inFrame];
    if (self)
        {
        _myMeetings = inMeetings;
        _isPDF = isPDF;
        }
    return self;
}

/**************************************************************//**
 \brief Rolls up its sleeves, and draws the data. rect is ignored.
 *****************************************************************/
- (void)drawRect:(CGRect)rect   ///< We ignore the requested rect, and draw the whole damn thing, every time.
{
#ifdef DEBUG
    NSLog( @"BMLTFormattedOutputSmartView::drawRect: (%f, %f), (%f, %f) -This is ignored, anyway.", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height );
#endif
    CGSize      myPageSize = [BMLTVariantDefs pdfPageSize];
    
    if ( [self isPDF] )
        {
        NSString    *pdfFileName = [NSString stringWithFormat:[BMLTVariantDefs pdfTempFileNameFormat], time(NULL)];
        NSString    *containerDirectory = NSTemporaryDirectory();
        
        pdfFileName = [containerDirectory stringByAppendingPathComponent:pdfFileName];
        
        UIGraphicsBeginPDFContextToFile ( pdfFileName, CGRectZero, nil) ;
        
#ifdef DEBUG
        NSLog(@"BMLTFormattedOutputSmartView::drawRect: The page size is: (%f, %f), and the file name is %@", myPageSize.width, myPageSize.height, pdfFileName);
#endif
        }
    
    int index = 0;
    CGRect  meetingCellRect = [self bounds];
    
    meetingCellRect.size.height = myPageSize.height / kNumberOfMeetingsPerListPage;
    
    for ( BMLT_Meeting *myMeeting in _myMeetings )
        {
        if ( !fmod(index++, kNumberOfMeetingsPerListPage) )
            {
#ifdef DEBUG
            NSLog( @"BMLTFormattedOutputSmartView::drawRect: New PDF Page (first meeting is number %d)", index );
#endif
            if ( [self isPDF] )
                {
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, myPageSize.width, myPageSize.height), nil);
                }
            else
                {

                }
            
            meetingCellRect.origin = CGPointZero;
            [self drawPageNumber:index];
            }
#ifdef DEBUG
        NSLog( @"BMLTFormattedOutputSmartView::drawRect: About to draw meeting number %d.", index );
#endif
        [self drawThisMeeting:myMeeting inRect:meetingCellRect];
        
        meetingCellRect.origin.y += meetingCellRect.size.height;
        }
    
    if ( [self isPDF] )
        {
        UIGraphicsEndPDFContext();
        }
}

/**************************************************************//**
 \brief Writes out one meeting.
 *****************************************************************/
- (void)drawThisMeeting:(BMLT_Meeting *)inMeeting
                 inRect:(CGRect)rect  ///< The meeting to be written out.
{
#ifdef DEBUG
    NSLog( @"BMLTFormattedOutputSmartView::drawThisMeeting: (%f, %f), (%f, %f) -%@.", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height, [inMeeting getBMLTName] );
#endif
    [[inMeeting getBMLTName] drawInRect:rect withFont:[UIFont boldSystemFontOfSize:16]];
}

/**************************************************************//**
 \brief Writes out the page number.
 *****************************************************************/
- (void)drawPageNumber:(NSInteger)pageNum
{
    CGSize    myPageSize = [BMLTVariantDefs pdfPageSize];
    NSString* pageString = [NSString stringWithFormat:@"Page %d", pageNum];
    UIFont* theFont = [UIFont systemFontOfSize:12];
    CGSize maxSize = CGSizeMake(myPageSize.width, myPageSize.height / 10);
    
    CGSize pageStringSize = [pageString sizeWithFont:theFont
                                   constrainedToSize:maxSize
                                       lineBreakMode:UILineBreakModeClip];
    
    CGRect stringRect = CGRectMake(((myPageSize.width - pageStringSize.width) / 2.0),
                                   myPageSize.height + ((myPageSize.height / 10 - pageStringSize.height) / 2.0) ,
                                   pageStringSize.width,
                                   pageStringSize.height);
    
    [pageString drawInRect:stringRect withFont:theFont];
}
@end
