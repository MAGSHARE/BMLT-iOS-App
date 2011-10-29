//
//  BMLT_Prefs.h
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

#import <Foundation/Foundation.h>

#define BMLT_Pref_Default_Value_Grace_Period    15

@interface BMLT_ServerPref : NSObject <NSCoding>
{
    NSString    *serverURI;
    NSString    *serverName;
    NSString    *serverDescription;
}

- (id)initWithURI:(NSString *)inURI andName:(NSString *)inName andDescription:(NSString *)inDescription;
- (void)setServerURI:(NSString *)inURI;
- (void)setServerName:(NSString *)inName;
- (void)setServerDescription:(NSString *)inDescription;
- (NSString *)getServerURI;
- (NSString *)getServerName;
- (NSString *)getServerDescription;

@end

@interface BMLT_Prefs : NSObject <NSCoding>
{
    NSMutableArray  *servers;
    BOOL            startWithMap;
    BOOL            preferDistanceSort;
    BOOL            lookupMyLocation;
    int             gracePeriod;
    BOOL            startWithSearch;
    BOOL            preferAdvancedSearch;
}

+ (BMLT_Prefs *)getBMLT_Prefs;
+ (NSString *)docPath;
+ (NSInteger)getServerCount;
+ (BMLT_ServerPref *)getServerAt:(NSInteger)inIndex;
+ (NSArray *)getServers;
+ (void)saveChanges;

- (NSArray *)servers;
- (NSInteger)addServerWithURI:(NSString *)inURI andName:(NSString *)inName andDescription:(NSString *)inDescription;
- (BOOL)removeServerWithURI:(NSString *)inURI;
- (BOOL)startWithMap;
- (BOOL)preferDistanceSort;
- (BOOL)lookupMyLocation;
- (BOOL)startWithSearch;
- (BOOL)preferAdvancedSearch;
- (int)gracePeriod;
- (void)setStartWithMap:(BOOL)inValue;
- (void)setPreferDistanceSort:(BOOL)inValue;
- (void)setLookupMyLocation:(BOOL)inValue;
- (void)setGracePeriod:(int)inValue;
- (void)setStartWithSearch:(BOOL)inValue;
- (void)setPreferAdvancedSearch:(BOOL)inValue;

@end
