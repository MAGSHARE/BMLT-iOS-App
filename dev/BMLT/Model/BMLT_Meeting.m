//
//  BMLT_Meeting.m
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
/***************************************************************\**
 \file BMLT_Meeting.m
 \brief This contains all the relevant data for one NA meeting.
 *****************************************************************/

#import <UIKit/UIKit.h>
#import "BMLT_Meeting.h"
#import "BMLT_Meeting_Search.h"
#import "BMLT_Location.h"
#import "BMLT_Prefs.h"
#import "BMLT_Server.h"
#import "A_BMLT_Search.h"
#import "BMLTAppDelegate.h"
#import <CoreLocation/CoreLocation.h>

/***************************************************************\**
 \class BMLT_Meeting
 \brief This class holds information about a meeting.
 *****************************************************************/
@implementation BMLT_Meeting

#pragma mark - Override Functions -

/***************************************************************\**
 \brief Initializer
 \returns self
 *****************************************************************/
- (id)init
{
    return [self initWithParent:nil andName:nil andDescription:nil];
}

#pragma mark - Class-Specific Functions -

/***************************************************************\**
 \brief Initializer with simple input data (name & description)
 \returns self
 *****************************************************************/
- (id)initWithParent:(NSObject *)inParent       ///< The "parent" object for this instance
             andName:(NSString *)inName         ///< The name of the meeting
      andDescription:(NSString *)inDescription  ///< The description (the Comments are usually used, here)
{
    self = [super initWithParent:inParent];
    
    if (self)
        {
        [self setBMLTName:inName];
        [self setBMLTDescription:inDescription];
        [self setDuration:0.0];
        [self setMeetingID:0];
        startTime = nil;
        currentElement = nil;
        location_object = [[BMLT_Location alloc] init];
        moreFields = [[NSMutableDictionary alloc] init];
        }
    
    return self;
}

/***************************************************************\**
 \brief Set the local BMLT meeting ID.
 *****************************************************************/
- (void)setMeetingID:(NSInteger)inID    ///< The local BMLT meeting ID
{
    meeting_id = inID;
}

/***************************************************************\**
 \brief Set the meeting start time.
 *****************************************************************/
- (void)setStartTime:(NSDate *)inStartTime  ///< The start time (only the time is used in the date).
{
    startTime = inStartTime;
}

/***************************************************************\**
 \brief Set the duration of the meeting.
 *****************************************************************/
- (void)setDuration:(NSTimeInterval)inDuration  ///< The length of the meeting.
{
    duration = inDuration;
}

/***************************************************************\**
 \brief Set the server object for this meeting connection.
 *****************************************************************/
- (void)setMyServer:(BMLT_Server *)inServerObject   ///< The server that "owns" this meeting.
{
    myServer = inServerObject;
}

/***************************************************************\**
 \brief Get the meeting location
 \returns the meeting location, as a BMLT_Location instance.
 *****************************************************************/
- (BMLT_Location *)getLocation
{
    return location_object;
}

/***************************************************************\**
 \brief Get the BMLT root server meeting ID
 \returns an integer, containing the meeting ID.
 *****************************************************************/
- (NSInteger)getMeetingID
{
    return meeting_id;
}

/***************************************************************\**
 \brief Get the start time, as an integer
 \returns an integer, containing the military start time.
 *****************************************************************/
- (int)getStartTimeOrdinal
{
    return ordinalStartTime;
}

/***************************************************************\**
 \brief return the start time as an NSDate object
 \returns an NSDate object, with the start time.
 *****************************************************************/
- (NSDate *)getStartTime
{
    return startTime;
}

/***************************************************************\**
 \brief Get the duration, as a time interval object
 \returns an NSTimeInterval object, with the duration.
 *****************************************************************/
- (NSTimeInterval)getDuration
{
    return duration;
}

/***************************************************************\**
 \brief Return the meeting formats, as an array of BMLT_Format objects.
 \returns an array of BMLT_Format objects, containing the meeting formats.
 *****************************************************************/
- (NSArray *)getFormats
{
    return formats;
}

/***************************************************************\**
 \brief Returns the various miscellaneous firelds for the meeting.
        Most BMLT meeting data is held as KVP (Key/Value Pair) data,
        so this returns the data in a dictionary.
 \returns an NSDictionary, with the data.
 *****************************************************************/
- (NSDictionary *)getMoreFields
{
    return moreFields;
}

/***************************************************************\**
 \brief Get the meeting location as coordinates
 \returns Gets the long/lat coordinate of the meeting as a CLLocation.
 *****************************************************************/
- (CLLocation *)getMeetingLocationCoords
{
    return [location_object getLocationCoords];
}

/***************************************************************\**
 \brief Set the weekday the meeting gathers, as an integer.
 *****************************************************************/
- (void)setWeekday:(int)inWeekday   ///< The weekday (1= Sunday, 7= Saturday).
{
    weekday = inWeekday;
}

/***************************************************************\**
 \brief Get the weekday as an integer.
 \returns an integer, from 1 (Sunday) to 7 (Saturday).
 *****************************************************************/
- (int)getWeekdayOrdinal
{
    return weekday;
}

/***************************************************************\**
 \brief Get the weekday as a string
 \returns a string, containing the localized weekday.
 *****************************************************************/
- (NSString *)getWeekday
{
    NSString    *key = [NSString stringWithFormat:@"WEEKDAY-NAME-%d", (weekday - 1)];
    
    return NSLocalizedString( key, nil);
}

/***************************************************************\**
 \brief Get an arbitrary KVP value from a meeting data field.
 \returns an object, representing that data.
 *****************************************************************/
- (NSObject *)getValueFromField:(NSString *)inKey   ///< The key, for the data.
{
    NSObject *ret = nil;
    
    if ( [inKey isEqual:@"id_bigint"] )
        {
        ret = [NSString stringWithFormat:@"%d", [self getMeetingID]];
        }
    else
        {
        if ( [inKey isEqual:@"meeting_name"] )
            {
            ret = [self getBMLTName];
            }
        else
            {
            if ( [inKey isEqual:@"comments"] )
                {
                ret = [self getBMLTDescription];
                }
            else
                {
                if ( [inKey isEqual:@"start_time"] )
                    {
                    ret = [self getStartTime];
                    }
                else
                    {
                    if ( [inKey isEqual:@"weekday_tinyint"] )
                        {
                        ret = [self getWeekday];
                        }
                    else
                        {
                        if ( [inKey isEqual:@"location_coords"] )
                            {
                            ret = [[self getLocation] getLocationCoords];
                            }
                        else
                            {
                            if ( [inKey hasPrefix:@"location_"] )
                                {
                                ret = [[self getLocation] getLocationElement:inKey];
                                }
                            else
                                {
                                if ( [inKey isEqual:@"formats"] )
                                    {
                                    ret = [self getFormats];
                                    }
                                else
                                    {
                                    ret = [moreFields objectForKey:inKey];
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    
    return ret;
}

/***************************************************************\**
 \brief Find out what fields are available from this meeting object.
 \returns an array of strings, with the KVP keys for the meeting's data.
 *****************************************************************/
- (NSArray *)getAvailableFields
{
    NSMutableArray  *ret = [[NSMutableArray alloc] initWithObjects:@"id_bigint", @"location_coords", @"weekday_tinyint", @"start_time", nil];
    
    if ( bmlt_name )
        {
        [ret addObject:@"meeting_name"];
        }
    
    if ( bmlt_description )
        {
        [ret addObject:@"comments"];
        }
    
    NSArray *allKeys = [moreFields allKeys];
    
    if ( allKeys && [allKeys count] )
        {
        for (int i = 0; i < [allKeys count]; i++)
            {
            [ret addObject:[allKeys objectAtIndex:i]];
            }
        }
    
    NSDictionary    *location_strings = [[self getLocation] getLocationStrings];
    
    if ( location_strings )
        {
        allKeys = [location_strings allKeys];
        
        if ( allKeys && [allKeys count] )
            {
            for (int i = 0; i < [allKeys count]; i++)
                {
                [ret addObject:[allKeys objectAtIndex:i]];
                }
            }
        }
    
    return ret;
}

/***************************************************************\**
 \brief Get the meeting's BMLT_Server object "owner."
 \returns a BMLT_Server object
 *****************************************************************/
- (BMLT_Server *)getMyServer
{
    return myServer;
}

#pragma mark - Protocol Functions
#pragma mark - BMLT_NameDescProtocol
/***************************************************************\**
 \brief Set the meeting name.
 *****************************************************************/
- (void)setBMLTName:(NSString *)inName  ///< The name of the meeting.
{
    bmlt_name = inName;
}

/***************************************************************\**
 \brief Set the meeting description
 *****************************************************************/
- (void)setBMLTDescription:(NSString *)inDescription    ///< The meeting description.
{
    bmlt_description = inDescription;
}


/***************************************************************\**
 \brief Get the meeting name.
 \returns a string, containing the meeting name.
 *****************************************************************/
- (NSString *)getBMLTName
{
    return bmlt_name;
}

/***************************************************************\**
 \brief Get the meeting description.
 \returns a string, containing the meeting description.
 *****************************************************************/
- (NSString *)getBMLTDescription
{
    return bmlt_description;
}

#pragma mark - NSXMLParserDelegate
/***************************************************************\**
 \brief Called when the parser starts on one of the meeting element's
 eclosed data elements.
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser            ///< The parser object
didStartElement:(NSString *)elementName         ///< The name of the element
  namespaceURI:(NSString *)namespaceURI         ///< The XML namespace
 qualifiedName:(NSString *)qName                ///< The XML qName
    attributes:(NSDictionary *)attributeDict    ///< The attributes
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"\tBMLT_Meeting Parser Start %@ element", elementName );
#endif
    currentElement = elementName;
}

/***************************************************************\**
 \brief Called when the XML parser is reading element characters.
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser    ///< The parser object
foundCharacters:(NSString *)string      ///< The characters
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"\t\tBMLT_Meeting Parser foundCharacters: \"%@\"", string );
#endif
    if ( [currentElement isEqual:@"meeting_name"] )
        {
        if ( !bmlt_name )
            {
            [self setBMLTName:[NSString stringWithString:string]];
            }
        else
            {
            [self setBMLTName:[bmlt_name stringByAppendingString:string]];
            }
#ifdef _CONNECTION_PARSE_TRACE_
        NSLog(@"\t\tBMLT_Meeting Parser Setting Meeting Name To: \"%@\"", bmlt_name );
#endif
        }
    else
        {
        if ( [currentElement isEqual:@"comments"] )
            {
            if ( !bmlt_description )
                {
                [self setBMLTDescription:[NSString stringWithString:string]];
                }
            else
                {
                [self setBMLTDescription:[bmlt_description stringByAppendingString:string]];
                }
#ifdef _CONNECTION_PARSE_TRACE_
            NSLog(@"\t\tBMLT_Meeting Parser Setting Meeting Description To: \"%@\"", bmlt_description );
#endif
            }
        else
            {
            if ( [currentElement isEqual:@"latitude"] || [currentElement isEqual:@"longitude"] )
                {
#ifdef _CONNECTION_PARSE_TRACE_
                NSLog(@"\t\tBMLT_Meeting Parser Setting Location %@ To: \"%@\"", currentElement, string );
#endif
                [location_object setLocationElementValue:string forKey:currentElement];
                }
            else
                {
                if ( [currentElement isEqual:@"id_bigint"] )
                    {
                    meeting_id = [string intValue];
                    }
                else
                    {
                    if ( [currentElement isEqual:@"weekday_tinyint"] )
                        {
                        [self setWeekday:[string intValue]];
                        }
                    else
                        {
                        if ( [currentElement isEqual:@"start_time"] )
                            {
                            NSArray *time_ar = [string componentsSeparatedByString:@":"];
                            if ( time_ar && ([time_ar count] > 1) )
                                {
                                NSDateComponents *comps = [[NSDateComponents alloc] init];
                                [comps setMinute:[(NSString *)[time_ar objectAtIndex:1] intValue]];
                                [comps setHour:[(NSString *)[time_ar objectAtIndex:0] intValue]];
                                
                                ordinalStartTime = ([(NSString *)[time_ar objectAtIndex:1] intValue] * 100) + [(NSString *)[time_ar objectAtIndex:0] intValue];
                                
                                NSCalendar  *curCal = [NSCalendar currentCalendar];
                                NSDate      *startT = [curCal dateFromComponents:comps];
                                [self setStartTime:startT];
#ifdef _CONNECTION_PARSE_TRACE_
                                NSLog(@"\t\tBMLT_Meeting Parser Setting Start Time To: \"%@\"", [self getStartTime]);
#endif
                                }
                            }
                        else
                            {
                            if ( [currentElement hasPrefix:@"location_"] )
                                {
                                [location_object setLocationElementValue:string forKey:currentElement];
#ifdef _CONNECTION_PARSE_TRACE_
                                NSLog(@"\t\t\tBMLT_Meeting Parser Setting Location Value for %@ To: \"%@\"", currentElement, string );
#endif
                                }
                            else
                                {
                                if ( [currentElement isEqual:@"formats"] )
                                    {
#ifdef _CONNECTION_PARSE_TRACE_
                                    NSLog(@"\t\t\tBMLT_Meeting Formats: \"%@\"", string );
#endif
                                    if ( !formats )
                                        {
                                        formats = [[NSMutableArray alloc] init];
                                        }
                                    
                                    if ( formats )
                                        {
                                        if ( myServer )
                                            {
                                            NSArray *format_choices = [myServer getFormats];
                                            
                                            if ( [format_choices count] )
                                                {
                                                NSArray *format_keys = [string componentsSeparatedByString:@","];
                                                if ( format_keys && ([format_keys count] > 0) )
                                                    {
                                                    for ( int i = 0; i < [format_keys count]; i++ )
                                                        {
                                                        NSString *theKey = (NSString *)[format_keys objectAtIndex:i];
                                                        
                                                        for ( int j = 0; j < [format_choices count]; j++ )
                                                            {
                                                            BMLT_Format *the_format = [format_choices objectAtIndex:j];
                                                            
                                                            if ( the_format && [[the_format key] isEqual:theKey] )
                                                                {
                                                                [formats addObject:the_format];
#ifdef _CONNECTION_PARSE_TRACE_
                                                                NSLog(@"\t\t\tBMLT_Meeting Adding the Format for Key: \"%@\"", theKey );
#endif
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
#ifdef _CONNECTION_PARSE_TRACE_
                                            else
                                                {
                                                NSLog(@"\t\t\tBMLT_Meeting No Server Formats!" );
                                                }
#endif
                                            }
#ifdef _CONNECTION_PARSE_TRACE_
                                        else
                                            {
                                            NSLog(@"\t\t\tBMLT_Meeting No Server Object!" );
                                            }
#endif
                                        }
                                    }
                                else
                                    {
                                    if ( [moreFields objectForKey:currentElement] )
                                        {
                                        [moreFields setObject:[(NSString *)[moreFields objectForKey:currentElement] stringByAppendingString:string] forKey:currentElement];
                                        }
                                    else
                                        {
                                        [moreFields setObject:string forKey:currentElement];
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
}

/***************************************************************\**
 \brief Called when the XML parser is done with the element.
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser    ///< The parser object
 didEndElement:(NSString *)elementName  ///< The name of the element being ended
  namespaceURI:(NSString *)namespaceURI ///< The XML namespace
 qualifiedName:(NSString *)qName        ///< The XML qName
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"\tBMLT_Meeting Parser Stop %@ element", elementName );
#endif
    if ( [elementName isEqual:@"row"] )
        {
        if ( ![self getValueFromField:@"distance_in_km"] )
            {
            if ( [BMLT_Prefs locationServicesAvailable] )
                {
                CLLocation *meetingLoc = [self getMeetingLocationCoords];
                
                if ( meetingLoc )
                    {
                    CLLocationDistance  distance = [meetingLoc distanceFromLocation:[[BMLTAppDelegate getBMLTAppDelegate] getWhereImAt]] / 1000.0;
                    
                    NSString    *string = [NSString stringWithFormat:@"%f", distance];
                    
                    [moreFields setObject:string forKey:@"distance_in_km"];
                    }
                }
            }
        BMLT_Meeting_Search *myParent = (BMLT_Meeting_Search *)[self getParentObject];
#ifdef _CONNECTION_PARSE_TRACE_
        NSLog(@"\tAdding Meeting named \"%@\" to Search Results.", bmlt_name );
#endif
        [myParent addSearchResult:self];
#ifdef _CONNECTION_PARSE_TRACE_
        NSLog(@"<-- Meeting Complete, handing back to the search object" );
#endif
        [parser setDelegate:myParent];
        }
    currentElement = nil;
}

    // We only use these for debug. Otherwise, we ignore errors and premature endings.
#ifdef _CONNECTION_PARSE_TRACE_
/***************************************************************\**
 \brief Called when the parser receives an error.
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser        ///< The parser object
parseErrorOccurred:(NSError *)parseError    ///< The error object
{
    NSLog(@"\tERROR: BMLT_Meeting Parser Error:%@", [parseError localizedDescription] );
}

/***************************************************************\**
 \brief Called when the parser ends the document (should never happen).
 *****************************************************************/
- (void)parserDidEndDocument:(NSXMLParser *)parser  ///< The parser object
{
    NSLog(@"\tERROR: Parser Complete, But Too Early!" );
}
#endif

@end
