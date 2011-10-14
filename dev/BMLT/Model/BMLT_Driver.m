//
//  BMLT_Driver.m
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

#import "BMLT_Driver.h"
#import "BMLT_Server.h"

static  BMLT_Driver *g_driver = nil;    ///< This will be a SINGLETON

@implementation BMLT_Driver

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
+ (BMLT_Driver *)getBMLT_Driver
{
    if ( !g_driver )
        {
        g_driver = [[BMLT_Driver alloc] init];
        }
    
    return g_driver;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
+ (BMLT_Server *)getServerByURI:(NSString *)inURI
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

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
+ (NSInteger)setUpServers
{
    NSInteger   ret = 0;
    
    BMLT_Driver *myDriver = [BMLT_Driver getBMLT_Driver];
    
    NSArray *servers = [[BMLT_Prefs getBMLT_Prefs] servers];
    
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
    return ret;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
+ (NSArray *)getValidServers
{
    BMLT_Driver *myDriver = [BMLT_Driver getBMLT_Driver];
    
    return [myDriver getChildObjects];
}

#pragma mark - Override Functions -

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (id)init
{
    return [self initWithServerObjects:nil andName:nil andDescription:nil];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)dealloc
{
    [bmlt_name release];
    [bmlt_description release];
    [serverObjects release];
    [super dealloc];
}

#pragma mark - Class-Specific Functions -

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (id)initWithServerObjects:(NSArray *)inServerObjects
                    andName:(NSString *)inName
             andDescription:(NSString *)inDescription
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

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setServerObjects:(NSArray *)inServerObjects
{
    [serverObjects release];
    
    serverObjects = nil;
    
    if ( inServerObjects )
        {
        serverObjects = [NSArray arrayWithArray:inServerObjects];
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)addServerObject:(BMLT_Server *)inServerObject
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

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)removeServerObject:(BMLT_Server *)inServer
{
    [serverObjects removeObject:inServer];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)addServerObjectByURI:(NSString *)inServerURI
                    withName:(NSString *)inName
             withDescription:(NSString *)inDescription
{
    BMLT_Server *myServer = [[[BMLT_Server alloc] initWithURI:inServerURI
                                                    andParent:self
                                                      andName:inName
                                               andDescription:inDescription] autorelease];
    if ( myServer )
        {
        [myServer setDelegate:self];
        [myServer verifyServerAndAddToParent];
        }
}

#pragma mark - Protocol Functions
#pragma mark - BMLT_ParentProtocol
/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (NSArray *)getChildObjects
{
    return serverObjects;
}

#pragma mark - BMLT_NameDescProtocol
/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setBMLTName:(NSString *)inName
{
    [inName retain];
    [bmlt_name release];
    
    bmlt_name = nil;
    
    if ( inName )
        {
        bmlt_name = inName;
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setBMLTDescription:(NSString *)inDescription
{
    [inDescription retain];
    [bmlt_description release];
    
    bmlt_description = nil;
    
    if ( inDescription )
        {
        bmlt_description = inDescription;
        }
}


/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
- (NSString *)getBMLTName
{
    return bmlt_name;
}

/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
- (NSString *)getBMLTDescription
{
    return bmlt_description;
}

#pragma mark - BMLT_ServerDelegateProtocol
/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)serverLockedAndLoaded:(BMLT_Server *)inServer
{
#ifdef DEBUG
    NSLog(@"BMLT_Driver serverLockedAndLoaded Called");
#endif
    [self addServerObject:inServer];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)serverFAIL:(BMLT_Server *)inServer
{
#ifdef DEBUG
    NSLog(@"BMLT_Driver serverFAIL Called");
#endif
}

@end
