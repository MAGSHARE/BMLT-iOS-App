//
//  A_BMLT_ServiceBodyHierClass.h
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

@interface A_BMLT_ServiceBodyHierClass : A_BMLT_ChildClass <BMLT_ParentProtocol, BMLT_NameDescProtocol>
{
    NSString        *uri;
    NSString        *bmlt_name;
    NSString        *bmlt_description;
    NSMutableArray  *cachedServiceBodies;
}

- (id)initWithURI:(NSString *)inURI andParent:(NSObject *)inParentObject andName:(NSString *)inName andDescription:(NSString *)inDescription;
- (void)setURI:(NSString *)inURI;
- (NSString *)getURI;

@end
