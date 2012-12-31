//
//  BMLT_Driver.m
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
/******************************************************************/
/**
 \file  BMLT_Driver.m
 \brief This is the main "driver" implementation file for connecting
        to the BMLT root server. It gathers up the preliminary info,
        then channels connections for searches.
        It is a SINGLETON pattern, with only one instance.
        Each connection is managed through a server object.
 *****************************************************************/

#import "BMLT_Driver.h"
#import "BMLT_Server.h"
#import "BMLT_Prefs.h"

static  BMLT_Driver *g_driver = nil;    ///< This will be a SINGLETON

/******************************************************************/
/**
 \class  BMLT_Driver
 \brief  This is a class that describes a "driver," that manages one or
 more connetions to BMLT root servers, and handles searches.
 *****************************************************************/
@implementation BMLT_Driver

/******************************************************************/
/**
 \brief   SINGLETON fetcher
 \returns a BMLT_Driver instance. It allocates it, if not already done.
 *****************************************************************/
+ (BMLT_Driver *)getBMLT_Driver
{
    if ( !g_driver )
        {
        g_driver = [[BMLT_Driver alloc] init];
        }
    
    return g_driver;
}

/******************************************************************/
/**
 \brief     Given a URI string, the driver returns the BMLT_Server
            instance that connects to that URI.
 \returns   A BMLT_Server instance
 *****************************************************************/
+ (BMLT_Server *)getServerByURI:(NSString *)inURI   ///< The URI to the root server for the desired server object
{
    BMLT_Server *ret = nil;
    
    if ( inURI )
        {
        NSArray *servers = [[BMLT_Driver getBMLT_Driver] getChildObjects];
        
        for ( NSInteger c = 0; c < [servers count]; c++ )
            {
            BMLT_Server *server = (BMLT_Server *)[servers objectAtIndex:c];
            
            if ( server )
                {
                NSString    *uri = [server getURI];
                
                if ( NSOrderedSame == [uri caseInsensitiveCompare:inURI] )
                    {
                    ret = server;
                    break;
                    }
                }
            }
        }
    
    return ret;
}

/******************************************************************/
/**
 \brief Initializes and instantiates the servers.
        This works by triggering the server setup. The server is
        "added" when it gets back with a valid connection.
        An "added" server is in the child objects for the driver.
 *****************************************************************/
+ (void)setUpServers
{
    BMLT_Driver *myDriver = [BMLT_Driver getBMLT_Driver];
    
    NSArray *servers = [[BMLT_Prefs getBMLT_Prefs] servers];    // The servers are in the prefs.
    
    if ( [servers count] )
        {
        for ( BMLT_ServerPref *server in servers )
            {
            [myDriver addServerObjectByURI:[server getServerURI]
                                  withName:[server getServerName]
                           withDescription:[server getServerDescription]];
            }
        }
    else
        {
#ifdef DEBUG
        NSLog(@"No Servers!");
#endif
        }
}

/******************************************************************/
/**
 \brief     Get the validated server objects.
 \returns   An array of BMLT_Server objects
 *****************************************************************/
+ (NSArray *)getValidServers
{
    BMLT_Driver *myDriver = [BMLT_Driver getBMLT_Driver];
    
    return [myDriver getChildObjects];
}

#pragma mark - Override Functions -

/******************************************************************/
/**
 \brief   initializer
 \returns self
 *****************************************************************/
- (id)init
{
    return [self initWithServerObjects:nil andName:nil andDescription:nil];
}

#pragma mark - Class-Specific Functions -

/******************************************************************/
/**
 \brief     Initializer with server objects.
 \returns   self
 *****************************************************************/
- (id)initWithServerObjects:(NSArray *)inServerObjects  ///< The list of server objects as an array
                    andName:(NSString *)inName          ///< The name of this driver
             andDescription:(NSString *)inDescription   ///< The description for this driver
{
    self = [super init];
    if (self)
        {
        [self setServerObjects:inServerObjects];
        [self setBMLTName:inName];
        [self setBMLTDescription:inDescription];
        }
    return self;
}

/******************************************************************/
/**
 \brief Sets the server objects from an array
 *****************************************************************/
- (void)setServerObjects:(NSArray *)inServerObjects ///< An array of BMLT_Server objects to be directly added
{
    
    serverObjects = nil;
    
    if ( inServerObjects )
        {
        serverObjects = [NSArray arrayWithArray:inServerObjects];
        }
}

/******************************************************************/
/**
 \brief Adds a single server object to the internal array
 *****************************************************************/
- (void)addServerObject:(BMLT_Server *)inServerObject   ///< A BMLT_Server object to be directly added
{
    if ( inServerObject )
        {
        if ( !serverObjects )
            {
            serverObjects = [[NSMutableArray alloc] init];
            }
        
        if ( ![serverObjects containsObject:inServerObject] )
            {
            [serverObjects addObject:inServerObject];
            }
        }
}

/******************************************************************/
/**
 \brief Remove the referenced server object
 *****************************************************************/
- (void)removeServerObject:(BMLT_Server *)inServer  ///< The BMLT_Server instance to be removed
{
    [serverObjects removeObject:inServer];
}

/******************************************************************/
/**
 \brief Asynchronous add server
        This works by telling the server object to initialize itself,
        and call back when it's done. At that time, it will be added.
 *****************************************************************/
- (void)addServerObjectByURI:(NSString *)inServerURI    ///< The URI of the root server
                    withName:(NSString *)inName         ///< The name for the new BMLT_Server object
             withDescription:(NSString *)inDescription  ///< The description for the new BMLT_Server object
{
        // Create the server object with the given parameters.
    BMLT_Server *myServer = [[BMLT_Server alloc] initWithURI:inServerURI
                                                    andParent:self
                                                      andName:inName
                                               andDescription:inDescription];
    if ( myServer ) // If successful, we tell it who we are, and to go forth and be fruitful
        {
        [myServer setDelegate:self];
        [myServer verifyServerAndAddToParent];
        }
}

/******************************************************************/
/**
 \brief Tell the driver about our delegate. Drivers retain delegates.
 *****************************************************************/
- (void)setDelegate:(NSObject<BMLT_DriverDelegateProtocol> *)inDelegate
{
    myDelegate = inDelegate;
}

/******************************************************************/
/**
 \brief     Get the driver's delegate object
 \returns   A delegate object, cast to an NSObject
 *****************************************************************/
- (NSObject<BMLT_DriverDelegateProtocol> *)getDelegate
{
    return myDelegate;
}

#pragma mark - Protocol Functions
#pragma mark - BMLT_ParentProtocol
/******************************************************************/
/**
 \brief     Return the servers
 \returns   An array of BMLT_Server objects
 *****************************************************************/
- (NSArray *)getChildObjects
{
    return serverObjects;
}

#pragma mark - BMLT_NameDescProtocol
/******************************************************************/
/**
 \brief Set the driver's name.
 *****************************************************************/
- (void)setBMLTName:(NSString *)inName  ///< A string. The name of the driver.
{
    
    bmlt_name = nil;
    
    if ( inName )
        {
        bmlt_name = inName;
        }
}

/******************************************************************/
/**
 \brief Set the driver's description.
 *****************************************************************/
- (void)setBMLTDescription:(NSString *)inDescription    ///< A string. The driver's description.
{
    
    bmlt_description = nil;
    
    if ( inDescription )
        {
        bmlt_description = inDescription;
        }
}


/******************************************************************/
/**
 \brief     Get the driver's name.
 \returns   A string. The name of the driver.
 *****************************************************************/
- (NSString *)getBMLTName
{
    return bmlt_name;
}

/******************************************************************/
/**
 \brief     Get the driver's description.
 \returns   a string. The description for the driver.
 *****************************************************************/
- (NSString *)getBMLTDescription
{
    return bmlt_description;
}

#pragma mark - BMLT_ServerDelegateProtocol
/******************************************************************/
/**
 \brief This is called when the server object is initialized and valid.
 *****************************************************************/
- (void)serverLockedAndLoaded:(BMLT_Server *)inServer   ///< The server object
{
#ifdef DEBUG
    NSLog(@"BMLT_Driver serverLockedAndLoaded Called");
#endif
    [self addServerObject:inServer];
}

/******************************************************************/
/**
 \brief This is called when the server screws the pooch.
 *****************************************************************/
- (void)serverFAIL:(BMLT_Server *)inServer  ///< The pooched server object.
{
#ifdef DEBUG
    NSLog(@"BMLT_Driver serverFAIL Called");
#endif
    if ( [self getDelegate] )
        {
        [[self getDelegate] driverFAIL:self];
        }
}

@end
