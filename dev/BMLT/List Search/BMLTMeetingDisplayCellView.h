//
//  MeetingDisplayCellView.h
//  BMLT
//
//  Created by MAGSHARE
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
#import "BMLT_Meeting.h"
#import "BMLT_Format.h"
#import "BMLTDisplayListResultsViewController.h"

extern int List_Meeting_Display_Line_Height;

#define List_Meeting_Display_CellHeight             ((List_Meeting_Display_Line_Height * 4) + 4)

@interface BMLTMeetingDisplayCellView : UITableViewCell
{
    BMLT_Meeting                          *myMeeting;
    BMLTDisplayListResultsViewController  *myModalController;
    UIView                                *wrapperView;
}
- (id)initWithMeeting:(BMLT_Meeting *)inMeeting andFrame:(CGRect)frame andReuseID:(NSString *)reuseID andIndex:(int)index;
- (void)setAnnotation;
- (void)setMeetingName;
- (void)setWeekdayAndTime;
- (void)setTownAndState;
- (void)setLocationAndAddress;
- (void)setDistance;
- (void)setFormats;
- (void)setMyModalController:(BMLTDisplayListResultsViewController *)inController;
- (BMLTDisplayListResultsViewController *)getMyModalController;
- (BMLT_Meeting *)getMyMeeting;
@end
