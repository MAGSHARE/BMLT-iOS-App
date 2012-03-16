//
//  BMLT_Prefs.h
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

#define BMLT_Pref_Default_Value_Grace_Period    15

/***************************************************************\**
 \class BMLT_Prefs
 \brief This class is a preference for a single server connection.
 *****************************************************************/
@interface BMLT_ServerPref : NSObject <NSCoding>
{
    NSString    *serverURI;         ///< The URI to the root server's main_server directory
    NSString    *serverName;        ///< The name of the server.
    NSString    *serverDescription; ///< A textual description of the server.
}

- (id)initWithURI:(NSString *)inURI andName:(NSString *)inName andDescription:(NSString *)inDescription;
- (void)setServerURI:(NSString *)inURI;
- (void)setServerName:(NSString *)inName;
- (void)setServerDescription:(NSString *)inDescription;
- (NSString *)getServerURI;
- (NSString *)getServerName;
- (NSString *)getServerDescription;

@end

/// These define the state of the searchTypePref datamember.
#define _PREFER_SIMPLE_SEARCH   0   ///< Start on the Simple Search.
#define _PREFER_MAP_SEARCH      1   ///< Start on the Map Search.
#define _PREFER_ADVANCED_SEARCH 2   ///< Start on the Advanced Search.

/***************************************************************\**
 \class BMLT_Prefs
 \brief This class is a global SINGLETON instance with all of the
        prefs.
 *****************************************************************/
@interface BMLT_Prefs : NSObject <NSCoding>
{
    NSMutableArray  *servers;                   ///< An array of server prefs.
    BOOL            startWithMap;               ///< Start with a map search (From previous versions).
    BOOL            preferDistanceSort;         ///< Prefer that ist responses be sorted by distance.
    BOOL            lookupMyLocation;           ///< Look up the user's current location upon startup.
    int             gracePeriod;                ///< This is how many minutes can pass before a meeting is considered "too long underway to be considered."
    BOOL            startWithSearch;            ///< Start up in search tab (From previous versions).
    BOOL            preferAdvancedSearch;       ///< Prefer start in advanced search (From previous versions).
    int             searchTypePref;             ///< Version 2.0 new: Determine the type of search the user prefers (see defines, above).
    BOOL            preferSearchResultsAsMap;   ///< Version 2.0 new: YES, if the user prefers the search results displayed initially as map results.
    BOOL            preserveAppStateOnSuspend;  ///< Version 2.0 new: YES, if the user wants the app to remember where it was when being recalled.
}

+ (BMLT_Prefs *)getBMLT_Prefs;
+ (NSString *)docPath;
+ (NSInteger)getServerCount;
+ (BMLT_ServerPref *)getServerAt:(NSInteger)inIndex;
+ (NSArray *)getServers;
+ (BOOL)getStartWithMap;
+ (BOOL)getPreferDistanceSort;
+ (BOOL)getLookupMyLocation;
+ (BOOL)getStartWithSearch;
+ (BOOL)getPreferAdvancedSearch;
+ (int)getGracePeriod;
+ (void)saveChanges;
+ (BOOL)locationServicesAvailable;

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
