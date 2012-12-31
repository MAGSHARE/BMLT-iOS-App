//
//  BMLT_Location.m
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
/*****************************************************************/
/**
 \file  BMLT_Location.m
 \brief A simple class that holds locations for use by the app.
        This extends NSCoding, and allows location data to be stored
        as KVP values (DICTIONARY pattern).
 *****************************************************************/

#import "BMLT_Location.h"

/*****************************************************************/
/**
 \class BMLT_Location
 \brief This class holds information about a meeting location.
 *****************************************************************/
@implementation BMLT_Location

/*****************************************************************/
/**
 \brief Set a location item as a string, using a key.
 *****************************************************************/
- (void)setLocationElementValue:(id)inValue         ///< The value to set
                         forKey:(NSString *)inKey   ///< The key, at which the vlue is stored.
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"\t\t\tBMLT_Location Setting Value: \"%@\" for Key: \"%@\"", (NSString *)inValue, inKey );
#endif
    if ( [inKey isEqual:@"longitude"] )
        {
        CLLocationDegrees   lat = 0.0;
        
        if ( location_position )
            {
            lat = [location_position coordinate].latitude;
            }
        
#ifdef _CONNECTION_PARSE_TRACE_
        NSLog(@"\t\t\tBMLT_Location Setting Location Longitude To: \"%@\". Current Latitude is \"%f\"", (NSString *)inValue, lat );
#endif
        
        location_position = [[CLLocation alloc] initWithLatitude:lat longitude:(CLLocationDegrees)[(NSString *)inValue doubleValue]];
        }
    else
        {
        if ( [inKey isEqual:@"latitude"] )
            {
            CLLocationDegrees   lng = 0.0;
            
            if ( location_position )
                {
                lng = [location_position coordinate].longitude;
                }
            
#ifdef _CONNECTION_PARSE_TRACE_
            NSLog(@"\t\t\tBMLT_Location Setting Location Latitude To: \"%@\". Current Longitude is \"%f\"", (NSString *)inValue, lng );
#endif
            
            location_position = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)[(NSString *)inValue doubleValue] longitude:lng];
            }
        else
            {
            if ( !location_strings )
                {
                location_strings = [[NSMutableDictionary alloc] init];
                }
            
#ifdef _CONNECTION_PARSE_TRACE_
            NSLog(@"\t\t\tBMLT_Location Setting Location Value of \"%@\" for the Key \"%@\".", (NSString *)inValue, inKey );
#endif
            NSString    *value = (NSString*)[location_strings objectForKey:inKey];
            
            if ( !value )
                {
                value = @"";
                }
            
            value = [value stringByAppendingString:inValue];
            
            [location_strings setObject:value forKey:inKey];
            }
        }
}

/*****************************************************************/
/**
 \brief Get the string for a given key.
 \returns a string, containing the value.
 *****************************************************************/
- (id)getLocationElement:(NSString *)inKey  ///< The key, to get the value
{
    return [location_strings objectForKey:inKey];
}

/*****************************************************************/
/**
 \brief Get the location long/lat coordinates, as a CLLocation
 \returns a CLLocation object, with the coordinates
 *****************************************************************/
- (CLLocation *)getLocationCoords
{
    return location_position;
}

/*****************************************************************/
/**
 \brief Get all the string items for the location.
 \returns an NSDictionary instance that has all the strings.
 *****************************************************************/
- (NSDictionary *)getLocationStrings
{
    return location_strings;
}

#pragma mark - NSCoder Protocol Implementation -

/*****************************************************************/
/**
 \brief Initializer -uses the NSCoder interface
 \returns self
 *****************************************************************/
-(id)initWithCoder:(NSCoder *)decoder   ///< The decoder, to get the initial values.
{
    self = [super init];
    
    if ( self && decoder )
        {
        location_strings = [decoder decodeObjectForKey:@"bmlt_location_strings"];
        
        if ( !location_strings )
            {
            location_strings = [[NSMutableDictionary alloc] init];
            }
        
        location_position = [decoder decodeObjectForKey:@"bmlt_location_position"];
        
        if ( !location_position )
            {
            location_position = [[CLLocation alloc] init];
            }
        }
    
    return self;
}

/*****************************************************************/
/**
 \brief Set the values into a coder.
 *****************************************************************/
-(void)encodeWithCoder:(NSCoder *)encoder   ///< The coder, to place the current values.
{
    [encoder encodeObject:location_strings forKey:@"bmlt_location_strings"];
    [encoder encodeObject:location_position forKey:@"bmlt_location_position"];
}

@end
