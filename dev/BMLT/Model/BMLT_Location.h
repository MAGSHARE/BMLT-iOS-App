//
//  BMLT_Location.h
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

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/*****************************************************************/
/**
 \class BMLT_Location
 \brief This class holds information about a meeting location.
 *****************************************************************/
@interface BMLT_Location : NSObject <NSCoding>
{
    NSMutableDictionary *location_strings;  ///< There can be a number of strings used to describe the location. They are held as key/value pairs.
    CLLocation          *location_position; ///< The long/lat position of the location.
}

- (void)setLocationElementValue:(id)inValue forKey:(NSString *)inKey;
- (id)getLocationElement:(NSString *)inKey;
- (CLLocation *)getLocationCoords;
- (NSDictionary *)getLocationStrings;

@end
