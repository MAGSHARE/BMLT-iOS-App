//
//  BMLT_Meeting.m
//  BMLT
//
//  Created by MAGSHARE on 8/13/11.
//  Copyright 2011 MAGSHARE. All rights reserved.
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
#import "BMLT_Meeting_Search.h"
#import "BMLT_Location.h"
#import "BMLT_Server.h"
#import "A_BMLT_Search.h"
#import "BMLTAppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@implementation BMLT_Meeting

#pragma mark - Override Functions -

/***************************************************************\**
 \brief 
 \returns
 *****************************************************************/
- (id)init
{
    return [self initWithParent:nil andName:nil andDescription:nil];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
-(void)dealloc
{
    [location_object release];
    [startTime release];
    [currentElement release];
    [formats release];
    [moreFields release];
    [bmlt_name release];
    [bmlt_description release];
    [super dealloc];
}

#pragma mark - Class-Specific Functions -

/***************************************************************\**
 \brief 
 \returns
 *****************************************************************/
- (id)initWithParent:(NSObject *)inParent
             andName:(NSString *)inName
      andDescription:(NSString *)inDescription
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
        }
    
    return self;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setMeetingID:(NSInteger)inID
{
    meeting_id = inID;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setStartTime:(NSDate *)inStartTime
{
    [inStartTime retain];
    [startTime release];
    startTime = inStartTime;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setDuration:(NSTimeInterval)inDuration
{
    duration = inDuration;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setMyServer:(BMLT_Server *)inServerObject
{
    myServer = inServerObject;
}

/***************************************************************\**
 \brief 
 \returns
 *****************************************************************/
- (BMLT_Location *)getLocation
{
    return location_object;
}

/***************************************************************\**
 \brief 
 \returns
 *****************************************************************/
- (NSInteger)getMeetingID
{
    return meeting_id;
}

/***************************************************************\**
 \brief 
 \returns
 *****************************************************************/
- (int)getStartTimeOrdinal
{
    return ordinalStartTime;
}

/***************************************************************\**
 \brief 
 \returns
 *****************************************************************/
- (NSDate *)getStartTime
{
    return startTime;
}

/***************************************************************\**
 \brief 
 \returns
 *****************************************************************/
- (NSTimeInterval)getDuration
{
    return duration;
}

/***************************************************************\**
 \brief 
 \returns
 *****************************************************************/
- (NSArray *)getFormats
{
    return formats;
}

/***************************************************************\**
 \brief 
 \returns
 *****************************************************************/
- (NSDictionary *)getMoreFields
{
    return moreFields;
}

/***************************************************************\**
 \brief 
 \returns
 *****************************************************************/
- (CLLocation *)getMeetingLocationCoords
{
    return [location_object getLocationCoords];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setWeekday:(int)inWeekday
{
    weekday = inWeekday;
}

/***************************************************************\**
 \brief 
 \returns
 *****************************************************************/
- (int)getWeekdayOrdinal
{
    return weekday;
}

/***************************************************************\**
 \brief 
 \returns
 *****************************************************************/
- (NSString *)getWeekday
{
    NSString    *key = [NSString stringWithFormat:@"WEEKDAY-NAME-%d", (weekday - 1)];
    
    return NSLocalizedString( key, nil);
}

/***************************************************************\**
 \brief 
 \returns
 *****************************************************************/
- (NSObject *)getValueFromField:(NSString *)inKey
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
 \brief 
 \returns
 *****************************************************************/
- (NSArray *)getAvailableFields
{
    NSMutableArray  *ret = [[[NSMutableArray alloc] initWithObjects:@"id_bigint", @"location_coords", @"weekday_tinyint", @"start_time", nil] autorelease];
    
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
 \brief 
 \returns 
 *****************************************************************/
- (BMLT_Server *)getMyServer
{
    return myServer;
}

#pragma mark - Protocol Functions
#pragma mark - BMLT_NameDescProtocol
/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setBMLTName:(NSString *)inName
{
    [inName retain];
    [bmlt_name release];
    bmlt_name = inName;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setBMLTDescription:(NSString *)inDescription
{
    [inDescription retain];
    [bmlt_description release];
    bmlt_description = inDescription;
}


/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
- (NSString *)getBMLTName
{
    return bmlt_name;
}

/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
- (NSString *)getBMLTDescription
{
    return bmlt_description;
}

#pragma mark - NSXMLParserDelegate
/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"\tBMLT_Meeting Parser Start %@ element", elementName );
#endif
    [elementName retain];
    [currentElement release];
    currentElement = elementName;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string
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
                                [comps release];
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
                                                            
                                                            if ( the_format && [[the_format getKey] isEqual:theKey] )
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
                                    if ( !moreFields )
                                        {
                                        moreFields = [[NSMutableDictionary alloc] init];
                                        }
                                    
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
 \brief 
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"\tBMLT_Meeting Parser Stop %@ element", elementName );
#endif
    if ( [elementName isEqual:@"row"] )
        {
        if ( ![self getValueFromField:@"distance_in_km"] )
            {
            BOOL    llActive = [CLLocationManager locationServicesEnabled] != NO && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied;
            
#ifdef DEBUG
            llActive = YES;
#endif
            if ( llActive )
                {
                CLLocation *meetingLoc = [self getMeetingLocationCoords];
                
                if ( meetingLoc )
                    {
                    CLLocationDistance  distance = [meetingLoc distanceFromLocation:[[BMLTAppDelegate getBMLTAppDelegate] getWhereImAt]] / 1000.0;
                    
                    if ( !moreFields )
                        {
                        moreFields = [[NSMutableDictionary alloc] init];
                        }
                    
                    NSString    *string = [NSString stringWithFormat:@"%f", distance];
                    
                    if ( [moreFields objectForKey:currentElement] )
                        {
                        [moreFields setObject:[(NSString *)[moreFields objectForKey:@"distance_in_km"] stringByAppendingString:string] forKey:@"distance_in_km"];
                        }
                    else
                        {
                        [moreFields setObject:string forKey:@"distance_in_km"];
                        }
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
    [currentElement release];
    currentElement = nil;
}

#ifdef _CONNECTION_PARSE_TRACE_
/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser
parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"\tERROR: BMLT_Meeting Parser Error:%@", [parseError localizedDescription] );
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"\tERROR: Parser Complete, But Too Early!" );
}
#endif

@end
