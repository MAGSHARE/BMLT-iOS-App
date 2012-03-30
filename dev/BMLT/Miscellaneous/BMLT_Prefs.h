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

/**************************************************************//**
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
#define _PREFER_ADVANCED_SEARCH 1   ///< Start on the Advanced Search.

/**************************************************************//**
 \class BMLT_Prefs
 \brief This class is a global SINGLETON instance with all of the
        prefs.
 *****************************************************************/
@interface BMLT_Prefs : NSObject <NSCoding>
{
    NSMutableArray  *servers;                   ///< An array of server prefs.
}

@property (atomic)   BOOL   startWithMap;               ///< Version 1.X only: Start with a map search.
@property (atomic)   BOOL   preferDistanceSort;         ///< Prefer that ist responses be sorted by distance.
@property (atomic)   BOOL   lookupMyLocation;           ///< Look up the user's current location upon startup.
@property (atomic)   int    gracePeriod;                ///< This is how many minutes can pass before a meeting is considered "too long underway to be considered."
@property (atomic)   BOOL   startWithSearch;            ///< Version 1.X only: Start up in search tab.
@property (atomic)   BOOL   preferAdvancedSearch;       ///< Version 1.X only: Prefer start in advanced search.
@property (atomic)   int    searchTypePref;             ///< Version 2.0 new: Determine the type of search the user prefers (see defines, above).
@property (atomic)   BOOL   preferSearchResultsAsMap;   ///< Version 2.0 new: YES, if the user prefers the search results displayed initially as map results.
@property (atomic)   BOOL   preserveAppStateOnSuspend;  ///< Version 2.0 new: YES, if the user wants the app to remember where it was when being recalled.
@property (atomic)   BOOL   keepUpdatingLocation;       ///< Version 2.0 new: YES, if we want to keep our location updated.
@property (atomic)   int    resultCount;                ///< Version 2.0 new: This is the desired "ballpark" for the number of meetings returned automatically. It affects the number of meetings returned by locality searches.


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

- (NSInteger)addServerWithURI:(NSString *)inURI andName:(NSString *)inName andDescription:(NSString *)inDescription;
- (BOOL)removeServerWithURI:(NSString *)inURI;
- (NSArray *)servers;

@end
