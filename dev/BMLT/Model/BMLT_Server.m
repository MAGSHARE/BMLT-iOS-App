//
//  BMLT_Server.m
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
/*****************************************************************/
/**
 \file  BMLT_Server.m
 \brief This is a class that maintains information about a BMLT
        root server.
 *****************************************************************/

#import "BMLT_Server.h"
#import "BMLT_Driver.h"

static int initial_query_timeout_in_seconds = 10;
static int format_query_timeout_in_seconds = 20;

/*****************************************************************/
/**
 \class BMLT_Server
 \brief This class models a BMLT root server.
 *****************************************************************/
@implementation BMLT_Server

#pragma mark - Override Functions -
/*****************************************************************/
/**
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

/*****************************************************************/
/**
 \brief Bye now.
 *****************************************************************/

#pragma mark - Class-Specific Functions -

/*****************************************************************/
/**
 \brief This is the main initializer for this class.
 \returns the initialized instance of the class.
 *****************************************************************/
- (id)initWithURI:(NSString *)inURI             ///< The URI of the root server
        andParent:(NSObject *)inParentObject    ///< The BMLT_Driver object that "owns" this server
          andName:(NSString *)inName            ///< The short name of the server.
   andDescription:(NSString *)inDescription     ///< The longer description of the server.
      andDelegate:(NSObject *)inDelegate        ///< Next of kin
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

/*****************************************************************/
/**
 \brief Sets the server delegate for this object.
 *****************************************************************/
- (void)setDelegate:(NSObject *)inDelegate  ///< The delegate object.
{
    delegate = inDelegate;
}

/*****************************************************************/
/**
 \brief Accessor - Get the object delegate.
 \returns the delegate for this onject.
 *****************************************************************/
- (NSObject *)getDelegate
{
    return delegate;
}

/*****************************************************************/
/**
 \brief Accessor - Get the cached server formats.
 \returns an NSArray of BMLT_format objects.
 *****************************************************************/
- (NSArray *)getFormats
{
    return cachedFormats;
}

/*****************************************************************/
/**
 \brief Accessor - Get the cached Server languages.
 \returns an NSArray of NSString, with the language enumerators.
 *****************************************************************/
- (NSArray *)getLanguages
{
    return languages;
}

/*****************************************************************/
/**
 \brief Accessor - Get the server version.
 \returns an NSString, with the server version.
 *****************************************************************/
- (NSString *)getVersion
{
    return version;
}

/*****************************************************************/
/**
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

        if ( loadFormats )
            {
            [self loadFormatsAndForce:YES];
            }
        }
}

/*****************************************************************/
/**
 \brief Queries the server for its version. If the server returns
 a good version, then we consider it a valid BMLT server.
 *****************************************************************/
- (void)loadFormatsAndForce:(BOOL)inForce   ///< This is YES, to force a refresh.
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
        current_element = nil;
        
        [myParser setDelegate:self];
        [myParser parseAsync:NO WithTimeout:format_query_timeout_in_seconds];
        }
}

/*****************************************************************/
/**
 \brief Queries the server. If it is valid, we add it to the driver.
 *****************************************************************/
- (void)verifyServerAndAddToParent
{
    [self verifyServer];
}

/*****************************************************************/
/**
 \brief Is the server a valid BMLT root server?
 \returns YES, if so.
 *****************************************************************/
- (BOOL)serverValid
{
    return nil != version;  // If we have a version, we are a valid server.
}

/*****************************************************************/
/**
 \brief Adds the given format object to the cached array.
 \returns YES, if the format was added. NO if the format was already
          in the array.
 *****************************************************************/
- (BOOL)addFormat:(BMLT_Format *)inFormat   ///< The format object to add.
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
/*****************************************************************/
/**
 \brief Called when the parser starts on one of the XML element's
 eclosed data elements.
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser            ///< The parser object
didStartElement:(NSString *)elementName         ///< The name of the element
  namespaceURI:(NSString *)namespaceURI         ///< The XML namespace
 qualifiedName:(NSString *)qName                ///< The XML qName
    attributes:(NSDictionary *)attributeDict    ///< The attributes
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"BMLT_Server Parser Start %@ element", elementName );
#endif
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
                        }
                    }
                }
            }
        }
}

/*****************************************************************/
/**
 \brief Callback    -The XML parser has some string data for us.
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser    ///< The parser object
foundCharacters:(NSString *)string      ///< The string data
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"BMLT_Server Parser foundCharacters: \"%@\"", string );
#endif
    if ( 2 == parsingVersion )
        {
        
        version = [string copy];
        versionSuccess = YES;
#ifdef _CONNECTION_PARSE_TRACE_
        NSLog(@"BMLT_Server Parser version %@", version );
#endif
        }
}

/*****************************************************************/
/**
 \brief Called when the XML parser is done with the element.
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser    ///< The parser object
 didEndElement:(NSString *)elementName  ///< The name of the element being ended
  namespaceURI:(NSString *)namespaceURI ///< The XML namespace
 qualifiedName:(NSString *)qName        ///< The XML qName
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

/*****************************************************************/
/**
 \brief Callback -Called when the parser encounters an error.
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser        ///< The parser object
parseErrorOccurred:(NSError *)parseError    ///< The error that the parser wants to tell us about.
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

/*****************************************************************/
/**
 \brief Callback -The document is done.
 *****************************************************************/
- (void)parserDidEndDocument:(NSXMLParser *)parser  ///< The parser object
{
    [(BMLT_Parser *)parser cancelTimeout];
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"\tParser Complete" );
#endif
}

#pragma mark - Timeout Handler -
/*****************************************************************/
/**
 \brief Callback -Handles a timeout error.
 *****************************************************************/
- (void)timeoutHandler
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"BMLT_Server timeoutHandler" );
#endif
    [self performSelectorOnMainThread:@selector(showTimeoutAlert) withObject:nil waitUntilDone:YES];
}

/*****************************************************************/
/**
 \brief Shows the timeout error alert.
 *****************************************************************/
- (void)showTimeoutAlert
{
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"COMM-ERROR",nil) message:NSLocalizedString(@"SERVER-TIMEOUT-ERROR",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK-BUTTON",nil) otherButtonTitles:nil];
    
    [myAlert show];
}
@end
