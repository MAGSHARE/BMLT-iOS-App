//
//  BMLTFormattedOutputSmartView.h
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

@class BMLT_Meeting;

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
@interface BMLTFormattedOutputSmartView : UIView
{

}
@property (weak, nonatomic, readonly) NSArray *myMeetings;
@property (nonatomic, assign) BOOL  isPDF;

- (id)initWithFrame:(CGRect)inFrame andMeetingList:(NSArray *)inMeetings asPDF:(BOOL)isPDF;
- (void)drawThisMeeting:(BMLT_Meeting *)inMeeting inRect:(CGRect)rect;
- (void)drawPageNumber:(NSInteger)pageNum;
@end
