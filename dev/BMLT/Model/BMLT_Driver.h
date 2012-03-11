//
//  BMLT_Driver.h
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
#import "BMLT_Model_Protocols.h"

@class A_BMLT_Search;
@class BMLT_Server;

@interface BMLT_Driver : NSObject <BMLT_ParentProtocol, BMLT_NameDescProtocol, BMLT_ServerDelegateProtocol>
{
    NSMutableArray                          *serverObjects;
    NSString                                *bmlt_name;
    NSString                                *bmlt_description;
    NSObject<BMLT_DriverDelegateProtocol>   *myDelegate;
}
+ (BMLT_Driver *)getBMLT_Driver;
+ (BMLT_Server *)getServerByURI:(NSString *)inURI;
+ (void)setUpServers;
+ (NSArray *)getValidServers;

- (id)initWithServerObjects:(NSArray *)inServerObjects andName:(NSString *)inName andDescription:(NSString *)inDescription;
- (void)setServerObjects:(NSArray *)inServerObjects;
- (void)addServerObject:(BMLT_Server *)inServerObject;
- (void)removeServerObject:(BMLT_Server *)inServer;
- (void)setDelegate:(NSObject<BMLT_DriverDelegateProtocol> *)inDelegate;
- (NSObject<BMLT_DriverDelegateProtocol> *)getDelegate;
- (void)addServerObjectByURI:(NSString *)inServerURI withName:(NSString *)inName withDescription:(NSString *)inDescription;
@end
