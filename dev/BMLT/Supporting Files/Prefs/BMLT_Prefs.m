//
//  BMLT_Prefs.m
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

#import "BMLT_Prefs.h"
#import <CoreLocation/CoreLocation.h>

static  BMLT_Prefs  *s_thePrefs = nil;    ///< The SINGLETON instance.

@implementation BMLT_ServerPref

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (id)init
{
    return [self initWithCoder:nil];
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (id)initWithURI:(NSString *)inURI
          andName:(NSString *)inName
   andDescription:(NSString *)inDescription
{
    self = [super init];
    
    if ( self )
        {
        [self setServerURI:inURI];
        [self setServerName:inName];
        [self setServerDescription:inDescription];
        }
    
    return self;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if ( self && decoder )
        {
        serverName = [[decoder decodeObjectForKey:@"serverName"] retain];
        serverDescription = [[decoder decodeObjectForKey:@"serverDescription"] retain];
        serverURI = [[decoder decodeObjectForKey:@"serverURI"] retain];
        }
    
    return self;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)dealloc
{
    [serverName release];
    [serverDescription release];
    [serverURI release];
    [super dealloc];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:serverName forKey:@"serverName"];
    [encoder encodeObject:serverDescription forKey:@"serverDescription"];
    [encoder encodeObject:serverURI forKey:@"serverURI"];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setServerURI:(NSString *)inURI
{
    [inURI retain];
    
    [serverURI release];
    
    serverURI = inURI;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setServerName:(NSString *)inName
{
    [inName retain];
    
    [serverName release];
    
    serverName = inName;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setServerDescription:(NSString *)inDescription
{
    [inDescription retain];
    
    [serverDescription release];
    
    serverDescription = inDescription;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (NSString *)getServerURI
{
    return serverURI;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (NSString *)getServerName
{
    return serverName;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (NSString *)getServerDescription
{
    return serverDescription;
}

@end

@implementation BMLT_Prefs

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
+ (BMLT_Prefs *)getBMLT_Prefs
{
    if ( !s_thePrefs )
        {
#ifdef DEBUG
        NSLog(@"BMLT_Prefs getBMLT_Prefs Trying unarchiving");
#endif
        s_thePrefs = [[NSKeyedUnarchiver unarchiveObjectWithFile:[BMLT_Prefs docPath]] retain];
        }
    
    if ( !s_thePrefs )
        {
#ifdef DEBUG
        NSLog(@"BMLT_Prefs getBMLT_Prefs Unarchiving didn't work. Allocating anew");
#endif
        s_thePrefs = [[[BMLT_Prefs alloc] initWithCoder:nil] retain];
        NSString    *serverName = NSLocalizedString(@"INITIAL-SERVER-NAME", nil);
        NSString    *serverDescription = NSLocalizedString(@"INITIAL-SERVER-DESCRIPTION", nil);
        NSString    *serverURI = NSLocalizedString(@"INITIAL-SERVER-URI", nil);
        
#ifdef DEBUG
        NSLog(@"BMLT_Prefs getBMLT_Prefs Adding the default server.");
#endif
        [s_thePrefs addServerWithURI:serverURI
                             andName:serverName
                      andDescription:serverDescription];
        }
    
    return s_thePrefs;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
+ (NSString *)docPath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"BMLT.data"];
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
+ (NSInteger)getServerCount
{
    return [[BMLT_Prefs getServers] count];
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
+ (BMLT_ServerPref *)getServerAt:(NSInteger)inIndex
{
    return (BMLT_ServerPref *)[[BMLT_Prefs getServers] objectAtIndex:inIndex];
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
+ (BOOL)getStartWithMap
{
    return [s_thePrefs startWithMap];
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
+ (BOOL)getPreferDistanceSort
{
    return [s_thePrefs preferDistanceSort];
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
+ (BOOL)getLookupMyLocation
{
    return [s_thePrefs lookupMyLocation];
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
+ (int)getGracePeriod
{
    return [s_thePrefs gracePeriod];
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
+ (void)saveChanges
{
    if ( s_thePrefs )
        {
#ifdef DEBUG
        NSLog(@"BMLT_Prefs saveChanges saving to %@.", [BMLT_Prefs docPath]);
#endif
        [NSKeyedArchiver archiveRootObject:s_thePrefs toFile:[BMLT_Prefs docPath]];
        }
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
+ (NSArray *)getServers
{
    return [s_thePrefs servers];
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (id)init
{
    self = [self initWithCoder:nil];
    
    return self;
}

#ifdef DEBUG
/***************************************************************\**
 \brief 
 *****************************************************************/
- (oneway void)release
{
    NSLog(@"BMLT_Prefs release called.");
    [super release];
}
#endif

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (BOOL)startWithMap
{
    return startWithMap;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (BOOL)preferDistanceSort
{
    return preferDistanceSort;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (BOOL)lookupMyLocation
{
    BOOL    llActive = [CLLocationManager locationServicesEnabled] != NO && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied;
    
    return llActive && lookupMyLocation;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (BOOL)startWithSearch
{
    return startWithSearch;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (BOOL)preferAdvancedSearch
{
    return preferAdvancedSearch;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (int)gracePeriod
{
    return gracePeriod;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)dealloc
{
    [servers release];
    [super dealloc];
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (NSArray *)servers
{
    return servers;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (NSInteger)addServerWithURI:(NSString *)inURI
                 andName:(NSString *)inName
          andDescription:(NSString *)inDescription;
{
    NSInteger   ret = -1;
    
    if ( inURI )
        {
        ret = 0;
        if ( !servers )
            {
            servers = [[NSMutableArray alloc] init];
            }
        else
            {
            for ( BMLT_ServerPref *serverPref in servers )
                {
                if ( NSOrderedSame == ([[serverPref getServerURI] caseInsensitiveCompare:inURI]) )
                    {
                    ret = -1;
                    break;
                    }
                
                ret++;
                }
            }
    
        BMLT_ServerPref *server_pref = [[BMLT_ServerPref alloc] init];
        [server_pref setServerURI:inURI];
        [server_pref setServerName:inName];
        [server_pref setServerDescription:inDescription];
        
        [servers addObject:server_pref];
        [server_pref release];
        }
    
    return ret;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (BOOL)removeServerWithURI:(NSString *)inURI
{
    BOOL    ret = NO;
    
    if ( inURI )
        {
        if ( servers )
            {
            NSInteger count = [servers count];
            for ( NSInteger index = 0; index < count; index++ )
                {
                BMLT_ServerPref *server_pref = (BMLT_ServerPref *)[servers objectAtIndex:index];
                if ( NSOrderedSame == ([[server_pref getServerURI] caseInsensitiveCompare:inURI]) )
                    {
                    [servers removeObjectAtIndex:index];
                    ret = YES;
                    break;
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
-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if ( self )
        {
        servers = nil;
        
        if ( decoder )
            {
            servers = [[decoder decodeObjectForKey:@"servers"] retain];
            
            if ( [decoder containsValueForKey:@"startWithMap"] )
                {
                startWithMap = [decoder decodeBoolForKey:@"startWithMap"];
                }
            else
                {
                [self setStartWithMap:NO];
                }
            
            if ( [decoder containsValueForKey:@"preferDistanceSort"] )
                {
                preferDistanceSort = [decoder decodeBoolForKey:@"preferDistanceSort"];
                }
            else
                {
                [self setPreferDistanceSort:NO];
                }
            
            if ( [decoder containsValueForKey:@"lookupMyLocation"] )
                {
                lookupMyLocation = [decoder decodeBoolForKey:@"lookupMyLocation"];
                }
            else
                {
                [self setLookupMyLocation:YES];
                }

            if ( [decoder containsValueForKey:@"gracePeriod"] )
                {
                gracePeriod = [decoder decodeIntForKey:@"gracePeriod"];
                }
            else
                {
                [self setGracePeriod:BMLT_Pref_Default_Value_Grace_Period];
                }
            
            if ( [decoder containsValueForKey:@"startWithSearch"] )
                {
                startWithSearch = [decoder decodeBoolForKey:@"startWithSearch"];
                }
            else
                {
                [self setStartWithSearch:YES];
                }
            
            if ( [decoder containsValueForKey:@"preferAdvancedSearch"] )
                {
                preferAdvancedSearch = [decoder decodeBoolForKey:@"preferAdvancedSearch"];
                }
            else
                {
                [self setPreferAdvancedSearch:NO];
                }
            }
        else
            {
            [self setStartWithMap:NO];
            [self setPreferDistanceSort:NO];
            [self setLookupMyLocation:YES];
            [self setGracePeriod:BMLT_Pref_Default_Value_Grace_Period];
            [self setStartWithSearch:YES];
            [self setPreferAdvancedSearch:NO];
            }
        }
    
    return self;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:servers forKey:@"servers"];
    [encoder encodeBool:startWithMap forKey:@"startWithMap"];
    [encoder encodeBool:preferDistanceSort forKey:@"preferDistanceSort"];
    [encoder encodeBool:lookupMyLocation forKey:@"lookupMyLocation"];
    [encoder encodeInt:gracePeriod forKey:@"gracePeriod"];
    [encoder encodeBool:startWithSearch forKey:@"startWithSearch"];
    [encoder encodeBool:preferAdvancedSearch forKey:@"preferAdvancedSearch"];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setStartWithMap:(BOOL)inValue
{
    startWithMap = inValue;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setPreferDistanceSort:(BOOL)inValue
{
    preferDistanceSort = inValue;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setLookupMyLocation:(BOOL)inValue
{
    lookupMyLocation = inValue;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setGracePeriod:(int)inValue
{
    gracePeriod = inValue;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setStartWithSearch:(BOOL)inValue
{
    startWithSearch = inValue;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setPreferAdvancedSearch:(BOOL)inValue
{
    preferAdvancedSearch = inValue;
}

@end
