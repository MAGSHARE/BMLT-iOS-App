//
//  BMLT_Meeting.h
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

#import "A_BMLT_ChildClass.h"
#import <CoreLocation/CoreLocation.h>

@class BMLT_Location;
@class BMLT_Server;

@interface BMLT_Meeting : A_BMLT_ChildClass <BMLT_NameDescProtocol, NSXMLParserDelegate>
{
    BMLT_Location           *location_object;
    NSInteger               meeting_id;
    NSDate                  *startTime;
    NSTimeInterval          duration;
    NSMutableArray          *formats;
    NSString                *bmlt_name;
    NSString                *bmlt_description;
    NSMutableDictionary     *moreFields;
    int                     weekday;
    int                     ordinalStartTime;
    NSString                *currentElement;
    BMLT_Server             *myServer;
}

- (id)initWithParent:(NSObject *)inParent andName:(NSString *)inName andDescription:(NSString *)inDescription;

- (void)setMeetingID:(NSInteger)inID;
- (void)setStartTime:(NSDate *)inStartTime;
- (void)setDuration:(NSTimeInterval)inDuration;
- (void)setWeekday:(int)inWeekday;
- (void)setMyServer:(BMLT_Server *)inServerObject;
- (NSObject *)getValueFromField:(NSString *)inKey;
- (int)getWeekdayOrdinal;
- (NSString *)getWeekday;
- (NSInteger)getMeetingID;
- (int)getStartTimeOrdinal;
- (NSDate *)getStartTime;
- (NSTimeInterval)getDuration;
- (NSArray *)getAvailableFields;
- (NSArray *)getFormats;
- (BMLT_Server *)getMyServer;
- (NSDictionary *)getMoreFields;
- (CLLocation *)getMeetingLocationCoords;
@end
