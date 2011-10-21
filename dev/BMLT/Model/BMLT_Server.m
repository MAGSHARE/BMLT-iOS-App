//
//  BMLT_Server.m
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

#import "BMLT_Server.h"
#import "BMLT_Driver.h"

@implementation BMLT_Server

#pragma mark - Override Functions -
/***************************************************************\**
 \brief This is the default initializer for this class. It calls the
        main initializer.
 \returns the initialized instance of the class.
 *****************************************************************/

- (id)init
{
    self = [self initWithURI:nil andParent:nil andName:nil andDescription:nil andDelegate:nil];
    
    if ( self )
        {
        current_element = nil;
        cachedFormats = nil;
        languages = nil;
        version = nil;
        delegate = nil;
        }
    
    return self;
}

/***************************************************************\**
 \brief Bye now.
 *****************************************************************/
- (void)dealloc
{
    [current_element release];
    [cachedFormats release];
    [languages release];
    [version release];
    [delegate release];
    [super dealloc];
}

#pragma mark - Class-Specific Functions -

/***************************************************************\**
 \brief This is the main initializer for this class.
 \returns the initialized instance of the class.
 *****************************************************************/
- (id)initWithURI:(NSString *)inURI
        andParent:(NSObject *)inParentObject
          andName:(NSString *)inName
   andDescription:(NSString *)inDescription
      andDelegate:(NSObject *)inDelegate
{
    self = [super initWithURI:inURI andParent:inParentObject andName:inName andDescription:inDescription];
    
    if (self)
        {
        cachedFormats = nil;
        languages = nil;
        version = nil;
        parsingVersion = 0;
        versionCheck = NO;
        versionSuccess = NO;
        
        [self setDelegate:inDelegate];
        [self verifyServerAndAddToParent];
        }
    
    return self;
}

/***************************************************************\**
 \brief Sets the server delegate for this object.
 *****************************************************************/
- (void)setDelegate:(NSObject *)inDelegate
{
    [inDelegate retain];
    [delegate release];
    delegate = inDelegate;
}

/***************************************************************\**
 \brief Accessor - Get the object delegate.
 \returns the delegate for this onject.
 *****************************************************************/
- (NSObject *)getDelegate
{
    return delegate;
}

/***************************************************************\**
 \brief Accessor - Get the cached server formats.
 \returns an NSArray of BMLT_format objects.
 *****************************************************************/
- (NSArray *)getFormats
{
    return cachedFormats;
}

/***************************************************************\**
 \brief Accessor - Get the cached Server languages.
 \returns an NSArray of NSString, with the language enumerators.
 *****************************************************************/
- (NSArray *)getLanguages
{
    return languages;
}

/***************************************************************\**
 \brief Accessor - Get the server version.
 \returns an NSString, with the server version.
 *****************************************************************/
- (NSString *)getVersion
{
    return version;
}

/***************************************************************\**
 \brief Queries the server for its version. If the server returns
 a good version, then we consider it a valid BMLT server.
 *****************************************************************/
- (void)verifyServer
{
    if ( uri )
        {
        NSString *serverURI = [NSString stringWithFormat:@"%@/client_interface/serverInfo.xml", uri];
        
#ifdef _CONNECTION_PARSE_TRACE_
        NSLog(@"BMLT_Server verifyServer Calling URI: %@", serverURI);
#endif
        versionCheck = YES;
        versionSuccess = NO;
        parsingVersion = 0;
        loadFormats = NO;
        BMLT_Parser *myParser = [[BMLT_Parser alloc] initWithContentsOfURL:[NSURL URLWithString:serverURI]];
        [myParser setDelegate:self];
        [myParser parseAsync:NO WithTimeout:initial_query_timeout_in_seconds];
        [myParser release];

        if ( loadFormats )
            {
            [self loadFormatsAndForce:YES];
            }
        }
}

/***************************************************************\**
 \brief Queries the server for its version. If the server returns
 a good version, then we consider it a valid BMLT server.
 *****************************************************************/
- (void)loadFormatsAndForce:(BOOL)inForce
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"BMLT_Server loadFormatsAndForce");
#endif
    if ( uri )
        {
        NSString *serverURI = [NSString stringWithFormat:@"%@/client_interface/xml/index.php?switcher=GetFormats", uri];
        BMLT_Parser *myParser = [[BMLT_Parser alloc] initWithContentsOfURL:[NSURL 
                                                                            URLWithString:serverURI]];

        versionCheck = NO;
        versionSuccess = NO;
        versionCheck = NO;
        versionSuccess = NO;
        loading_formats = YES;
        [current_element release];
        current_element = nil;
        
        [myParser setDelegate:self];
        [myParser parseAsync:NO WithTimeout:format_query_timeout_in_seconds];
        [myParser release];
        }
}

/***************************************************************\**
 \brief Queries the server. If it is valid, we add it to the driver.
 *****************************************************************/
- (void)verifyServerAndAddToParent
{
    [self verifyServer];
}

/***************************************************************\**
 \brief Is the server a valid BMLT root server?
 \returns YES, if so.
 *****************************************************************/
- (BOOL)serverValid
{
    return nil != version;  // If we have a version, we are a valid server.
}

/***************************************************************\**
 \brief Adds the given format object to the cached array.
 \returns YES, if the format was added. NO if the format was already
          in the array.
 *****************************************************************/
- (BOOL)addFormat:(BMLT_Format *)inFormat
{
    BOOL    ret = NO;
    if ( !cachedFormats )
        {
        cachedFormats = [[NSMutableArray alloc] init];
        }
    
    if ( ![cachedFormats containsObject:inFormat] )
        {
        [cachedFormats addObject:inFormat];
        ret = YES;
        }
    
    return ret;
}

#pragma mark - Protocol Functions

#pragma mark - NSXMLParserDelegate
/***************************************************************\**
 \brief Callback
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"BMLT_Server Parser Start %@ element", elementName );
#endif
    [elementName retain];
    [current_element release];
    current_element = elementName;
    
    if ( [elementName isEqual:@"serverVersion"] )
        {
        parsingVersion++;
        }
    else
        {
        if ( [elementName isEqual:@"readableString"] )
            {
            parsingVersion++;
            }
        else
            {
            if ( [elementName isEqual:@"formats"] )
                {
                loading_formats = YES;
                }
            else
                {
                if ( [elementName isEqual:@"row"] && loading_formats )
                    {
#ifdef _CONNECTION_PARSE_TRACE_
                    NSLog(@"--> Starting a format, handing off to the format object" );
#endif
                    BMLT_Format    *newFormat = [[BMLT_Format alloc] initWithParent:self andKey:nil andName:nil andDescription:nil];
                    
                    if ( newFormat )
                        {
                        [parser setDelegate:newFormat];
                        [newFormat release];
                        }
                    }
                }
            }
        }
}

/***************************************************************\**
 \brief Callback
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"BMLT_Server Parser foundCharacters: \"%@\"", string );
#endif
    if ( 2 == parsingVersion )
        {
        if ( version )
            {
            [version release];
            }
        
        version = [string copy];
        versionSuccess = YES;
#ifdef _CONNECTION_PARSE_TRACE_
        NSLog(@"BMLT_Server Parser version %@", version );
#endif
        }
}

/***************************************************************\**
 \brief Callback
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"BMLT_Server Parser Stop %@ element", elementName );
#endif
    if ( [elementName isEqual:@"formats"] )
        {
        if ( delegate )
            {
#ifdef _CONNECTION_PARSE_TRACE_
            NSLog(@"BMLT_Server Server Locked And Loaded!" );
#endif
            [(NSObject <BMLT_ServerDelegateProtocol> *)delegate serverLockedAndLoaded:self];
            }
        loading_formats = NO;
        }
    else
        {
        parsingVersion = 0;
        if ( versionCheck && !versionSuccess && delegate )
            {
            [(NSObject <BMLT_ServerDelegateProtocol> *)delegate serverFAIL:self];
            }
        versionCheck = NO;
        versionSuccess = NO;
        if ( [elementName isEqual:@"bmltInfo"] )
            {
#ifdef _CONNECTION_PARSE_TRACE_
            NSLog(@"BMLT_Server Starting Format Load" );
#endif
            loadFormats = YES;
            }
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser
parseErrorOccurred:(NSError *)parseError
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"\tERROR: BMLT_Server Parser Error:%@", [parseError localizedDescription] );
#endif
    if ( delegate )
        {
#ifdef _CONNECTION_PARSE_TRACE_
        NSLog(@"\tBMLT_Server Calling the delegate fail routine" );
#endif
        [(NSObject <BMLT_ServerDelegateProtocol> *)delegate serverFAIL:self];
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [(BMLT_Parser *)parser cancelTimeout];
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"\tParser Complete" );
#endif
}

#pragma mark - Timeout Handler -
/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)timeoutHandler
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"BMLT_Server timeoutHandler" );
#endif
    [self performSelectorOnMainThread:@selector(showTimeoutAlert) withObject:nil waitUntilDone:YES];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)showTimeoutAlert
{
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"COMM-ERROR",nil) message:NSLocalizedString(@"SERVER-TIMEOUT-ERROR",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK-BUTTON",nil) otherButtonTitles:nil];
    
    [myAlert show];
    [myAlert release];
}
@end
