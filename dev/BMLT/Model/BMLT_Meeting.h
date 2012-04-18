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

@class BMLT_Results_MapPointAnnotation;
@class BMLT_Location;
@class BMLT_Server;

/**************************************************************//**
 \class BMLT_Meeting
 \brief This class holds information about a meeting.
 *****************************************************************/
@interface BMLT_Meeting : A_BMLT_ChildClass <BMLT_NameDescProtocol, NSXMLParserDelegate>
{
    BMLT_Location           *location_object;   ///< The location of the meeting.
    NSInteger               meeting_id;         ///< The BMLT server ID for the meeting.
    NSDate                  *startTime;         ///< The meeting start time.
    NSTimeInterval          duration;           ///< How long the meeting lasts.
    NSMutableArray          *formats;           ///< The format codes for the meeting.
    NSString                *bmlt_name;         ///< The meeting name.
    NSString                *bmlt_description;  ///< Comments or description of the meeting.
    NSMutableDictionary     *moreFields;        ///< Additional meeting data fields (remember that meeting data is kept in an extensible KVP database).
    int                     weekday;            ///< The day of the week the meeting starts (0 = Sunday).
    int                     ordinalStartTime;   ///< The start time, as a UNIX epoch time.
    NSString                *currentElement;    ///< Used while parsing the meeting.
    BMLT_Server             *myServer;          ///< The server that "owns" this meeting.
}

@property (atomic, readwrite)   NSInteger   meetingIndex;   ///< This will be used by the printer to match the meeting to an annotation.
@property (atomic, readwrite)   BOOL        partOfMulti;    ///< This is set YES if this meeting is part of a multi-annotation.

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
