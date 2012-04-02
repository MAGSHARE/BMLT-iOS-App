//
//  A_BMLT_Search.m
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
/**************************************************************//**
 \file      A_BMLT_Search.m
 \brief     This file implements the main search object of the app.
            The search is done asynchronously, and a delegate system
            is used to signal completion and/or errors.
            It uses a standard SAX XML parser.
 *****************************************************************/

#import "A_BMLT_Search.h"
#import "BMLT_Driver.h"
#import "BMLT_Meeting.h"
#import "BMLT_Server.h"
#import "BMLTAppDelegate.h"

/**************************************************************//**
 \class  A_BMLT_Search
 \brief  This class contains a search instance, with criteria and
 results. The search will run an XML parse.
 *****************************************************************/
@implementation A_BMLT_Search

#pragma mark - Override Functions -

/**************************************************************//**
 \brief     Initializer
 \returns   self
 *****************************************************************/
- (id)init
{
    return [self initWithCriteria:nil andName:nil andDescription:nil];
}

/**************************************************************//**
 \brief un-initializer
 *****************************************************************/
- (void)dealloc
{
    [self clearSearch];
}

#pragma mark - Class-Specific Functions -

/**************************************************************//**
 \brief     Initializer with search criteria
 \returns   self
 *****************************************************************/
- (id)initWithCriteria:(NSDictionary *)inSearchCriteria ///< The search criteria
               andName:(NSString *)inName               ///< The name of the search
        andDescription:(NSString *)inDescription        ///< The description of the search
{
    self = [super initWithParent:[BMLT_Driver getBMLT_Driver]];
    if (self)
        {
        [self setBMLTName:inName];
        [self setBMLTDescription:inDescription];
        if ( inSearchCriteria )
            {
            searchCriteria = [[NSMutableDictionary alloc] init];
            [searchCriteria addEntriesFromDictionary:inSearchCriteria];
            }
        else
            {
            searchCriteria = nil;
            }
        }
    
    return self;
}

/**************************************************************//**
 \brief Add a single search criteria to the search object
 *****************************************************************/
- (void)addSearchCriteriaData:(NSString *)inValue   ///< The value of the KVP
                        atKey:(NSString *)inKey     ///< The criteria key
{
    if ( !searchCriteria )
        {
        searchCriteria = [[NSMutableDictionary alloc] init];
        }

#ifdef DEBUG
    NSString    *prevValue = [searchCriteria objectForKey:inKey];
    
    if ( prevValue )
        {
        NSLog(@"A_BMLT_Search addSearchCriteria Previous Value for the Key \"%@\": \"%@\"", inKey, prevValue);
        }
    
    NSLog(@"A_BMLT_Search addSearchCriteria New Value for the Key \"%@\": \"%@\"", inKey, inValue);
#endif
   
    [searchCriteria setObject:inValue forKey:inKey];
}

/**************************************************************//**
 \brief See if there is a search under way (async)
 \returns YES if there is a search going on.
 *****************************************************************/
- (BOOL)searchInProgress
{
    return searchInProgress;
}

/**************************************************************//**
 \brief     Get the search criteria dictionary
 \returns   A dictionary, with all the search criteria
 *****************************************************************/
- (NSDictionary *)getCriteria
{
    return searchCriteria;
}

/**************************************************************//**
 \brief Executes the search asynchronously
 *****************************************************************/
- (void)doSearch
{
    BMLT_Driver *myParent = (BMLT_Driver *)[self getParentObject];
    
    NSArray *servers = [myParent getChildObjects];
    
    if ( [servers count] )
        {
        for ( BMLT_Server *server in [myParent getChildObjects] )
            {
            if ( [server serverValid] )
                {
#ifdef DEBUG
                NSLog(@"A_BMLT_Search doSearch Starting a new server: %@", [server getURI]);
#endif
                NSArray *keyArray = [searchCriteria allKeys];
                NSString    *params = @"";
                
                if ( keyArray )
                    {
                    int count = [keyArray count];
                    
                    if ( count )
                        {
                        for (int i=0; i < count; i++)
                            {
                            NSString    *key = (NSString *)[keyArray objectAtIndex:i];
                            NSString    *value = (NSString *)[searchCriteria objectForKey:key];

                            if ( [key isEqualToString:@"weekdays"] )
                                {
                                NSArray *values = [value componentsSeparatedByString:@","];
                                
                                if ( [values count] )
                                    {
                                    params = [params stringByAppendingFormat:@"&weekdays[]=%@", [values componentsJoinedByString:@"&weekdays[]="]];
                                    }
                                else
                                    {
                                    params = [params stringByAppendingFormat:@"&weekdays=%@", value];
                                    }
                                }
                            else
                                {
                                params = [params stringByAppendingFormat:@"&%@=%@", key, value];
                                }
                            } 
                        }
                    }
                
                params = [params stringByReplacingOccurrencesOfString:@" " withString:@"+"];
                params = [params stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSString *uri = [NSString stringWithFormat:@"%@/client_interface/xml/index.php?switcher=GetSearchResults%@", [server getURI], params];
                
#ifdef DEBUG
                NSLog(@"A_BMLT_Search doSearch Calling URI: %@", uri);
#endif
                [[NSURLCache sharedURLCache] setMemoryCapacity:0];
                [[NSURLCache sharedURLCache] setDiskCapacity:0];
                
                NSData *xml = [NSData 
                               dataWithContentsOfURL: [NSURL 
                                                       URLWithString:uri]];
                BMLT_Parser *myParser = [[BMLT_Parser alloc] initWithData:xml];
                
                [myParser setDelegate:self];
                [myParser setMyServer:server];
                
                searchInProgress = YES;
                
                [myParser parseAsync:NO
                         WithTimeout:meeting_search_timeout_period_in_seconds];
#ifdef DEBUG
                NSLog(@"A_BMLT_Search doSearch Back from Kicking Off Search");
#endif
                }
            }
        }
    else
        {
#ifdef DEBUG
        NSLog(@"No servers!");
#endif
        if ( myDelegate )
            {
            [myDelegate searchCompleteWithError:nil];
            }
#ifdef DEBUG
        NSLog(@"A_BMLT_Search doSearch Releasing Parser");
#endif
        }
}

#pragma mark - Protocol Functions
#pragma mark - BMLT_ParentProtocol
/**************************************************************//**
 \brief     Gets all the child objects of the search (the results)
 \returns   An array of meeting objects
 *****************************************************************/
- (NSArray *)getChildObjects
{
    return searchResults;
}

#pragma mark - BMLT_NameDescProtocol
/**************************************************************//**
 \brief Set the name of this search
 *****************************************************************/
- (void)setBMLTName:(NSString *)inName  ///< The name string
{
    bmlt_name = inName;
}

/**************************************************************//**
 \brief Set the description of the search
 *****************************************************************/
- (void)setBMLTDescription:(NSString *)inDescription    ///< The textual description
{
    bmlt_description = inDescription;
}


/**************************************************************//**
 \brief     Get the name of the search
 \returns   a string -the search name
 *****************************************************************/
- (NSString *)getBMLTName
{
    return bmlt_name;
}

/**************************************************************//**
 \brief     Get the search description
 \returns   a string -the description
 *****************************************************************/
- (NSString *)getBMLTDescription
{
    return bmlt_description;
}

/**************************************************************//**
 \brief Set the delegate to receive search notifications
 *****************************************************************/
- (void)setDelegate:(NSObject<SearchDelegate> *)inDelegate  ///< The search caller
{
    myDelegate = inDelegate;
}

/**************************************************************//**
 \brief Add a single result to the search results array
 *****************************************************************/
- (void)addSearchResult:(NSObject<BMLT_NameDescProtocol> *)inResult ///< The search result (will be a meeting object)
{
#ifdef DEBUG
    NSLog(@"\tAdding A New %@ Search Result Object Named \"%@\"", [inResult class], [inResult getBMLTName]);
#endif
    if ( !searchResults )
        {
        searchResults = [[NSMutableArray alloc] init];
        }

    [searchResults addObject:inResult];
#ifdef DEBUG
    NSLog(@"\tThere Are Now %d Results in the Search", [searchResults count]);
#endif
}

/**************************************************************//**
 \brief     Get the search delegate
 \returns   The search "owner."
 *****************************************************************/
- (NSObject<SearchDelegate> *)getDelegate
{
    return myDelegate;
}

/**************************************************************//**
 \brief Clears all the search results, and the criteria
 *****************************************************************/
- (void)clearSearch
{
#ifdef DEBUG
    NSLog(@"A_BMLT_Search clearSearch");
#endif
    bmlt_name = nil;
    bmlt_description = nil;
    searchCriteria = nil;
    searchResults = nil;
    myDelegate = nil;
    searchInProgress = NO;
}

/**************************************************************//**
 \brief     Get the search results
 \returns   an array of meeting objects
 *****************************************************************/
- (NSArray *)getSearchResults
{
    return searchResults;
}

#pragma mark - NSXMLParserDelegate
/**************************************************************//**
 \brief The parse of one element in the XML response is beginning
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser            ///< The parser object
didStartElement:(NSString *)elementName         ///< The name of the element
  namespaceURI:(NSString *)namespaceURI         ///< The namespace
 qualifiedName:(NSString *)qName                ///< The qname
    attributes:(NSDictionary *)attributeDict    ///< The attributes of the element
{
    [(BMLT_Parser *)parser setCurrentElement:nil];
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"A_BMLT_Search Parser Start %@ element", elementName );
#endif
}

/**************************************************************//**
 \brief Character data have been found in the elemnt
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser    ///< The parser object
foundCharacters:(NSString *)string      ///< The character data
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"A_BMLT_Search Parser foundCharacters: \"%@\"", string );
#endif
}

/**************************************************************//**
 \brief The element being parsed is closing
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser    ///< The parser object
 didEndElement:(NSString *)elementName  ///< The name of the elemnt being closed
  namespaceURI:(NSString *)namespaceURI ///< The namespace
 qualifiedName:(NSString *)qName        ///< The qname
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"A_BMLT_Search Parser Stop %@ element", elementName );
#endif
}

/**************************************************************//**
 \brief Called if there was an error in parsing the XML
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser        ///< The parser object
parseErrorOccurred:(NSError *)parseError    ///< The error object
{
    searchInProgress = NO;
    if ( myDelegate )   /// We call any search delegates
        {
        [myDelegate performSelectorOnMainThread:@selector(searchCompleteWithError:) withObject:parseError waitUntilDone:YES];
        }
    [parser abortParsing];
}

/**************************************************************//**
 \brief Called when parsing is complete.
 *****************************************************************/
- (void)parserDidEndDocument:(NSXMLParser *)parser  ///< The parser in question
{
    [(BMLT_Parser *)parser cancelTimeout];
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"A_BMLT_Search Parser Complete" );
#endif
    if ( myDelegate )   // Let the delegate know we're done.
        {
        [myDelegate searchCompleteWithError:nil];
        }
    searchInProgress = NO;
#ifdef DEBUG
    NSLog(@"A_BMLT_Search parserDidEndDocument Releasing Parser");
#endif
}
@end
