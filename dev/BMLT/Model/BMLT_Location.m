//
//  BMLT_Location.m
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

#import "BMLT_Location.h"

@implementation BMLT_Location

- (void)dealloc
{
    [location_position release];
    [location_strings release];
    
    [super dealloc];
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (void)setLocationElementValue:(id)inValue forKey:(NSString *)inKey
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
            [location_position release];
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
                [location_position release];
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

/***************************************************************\**
 \brief 
 *****************************************************************/
- (id)getLocationElement:(NSString *)inKey
{
    return [location_strings objectForKey:inKey];
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (CLLocation *)getLocationCoords
{
    return location_position;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (NSDictionary *)getLocationStrings
{
    return location_strings;
}

#pragma mark - NSCoder Protocol Implementation -

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
-(id)initWithCoder:(NSCoder *)decoder
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

/***************************************************************\**
 \brief 
 *****************************************************************/
-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:location_strings forKey:@"bmlt_location_strings"];
    [encoder encodeObject:location_position forKey:@"bmlt_location_position"];
}

@end
