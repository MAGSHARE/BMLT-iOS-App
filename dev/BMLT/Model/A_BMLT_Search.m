//
//  A_BMLT_Search.m
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

#import "A_BMLT_Search.h"
#import "BMLT_Driver.h"
#import "BMLT_Meeting.h"
#import "BMLT_Server.h"
#import "BMLTAppDelegate.h"

@implementation A_BMLT_Search

#pragma mark - Override Functions -

/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
- (id)init
{
    return [self initWithCriteria:nil andName:nil andDescription:nil];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)dealloc
{
    [self clearSearch];
    [super dealloc];
}

#pragma mark - Class-Specific Functions -

/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
- (id)initWithCriteria:(NSDictionary *)inSearchCriteria
               andName:(NSString *)inName
        andDescription:(NSString *)inDescription
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

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)addSearchCriteriaData:(NSString *)inValue
                        atKey:(NSString *)inKey 
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

/***************************************************************\**
 \brief 
 \returns YES if there is a search going on.
 *****************************************************************/
- (BOOL)searchInProgress
{
    return searchInProgress;
}

/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
- (NSDictionary *)getCriteria
{
    return searchCriteria;
}

/***************************************************************\**
 \brief 
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
                [myParser release];
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
/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
- (NSArray *)getChildObjects
{
    return searchResults;
}

#pragma mark - BMLT_NameDescProtocol
/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setBMLTName:(NSString *)inName
{
    [inName retain];
    [bmlt_name release];
    bmlt_name = inName;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setBMLTDescription:(NSString *)inDescription
{
    [inDescription retain];
    [bmlt_description release];
    bmlt_description = inDescription;
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

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setDelegate:(NSObject<SearchDelegate> *)inDelegate
{
    [inDelegate retain];
    [myDelegate release];
    myDelegate = inDelegate;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)addSearchResult:(NSObject<BMLT_NameDescProtocol> *)inResult
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

/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
- (NSObject<SearchDelegate> *)getDelegate
{
    return myDelegate;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)clearSearch
{
#ifdef DEBUG
    NSLog(@"A_BMLT_Search clearSearch");
#endif
    [bmlt_name release];
    bmlt_name = nil;
    [bmlt_description release];
    bmlt_description = nil;
    [searchCriteria release];
    searchCriteria = nil;
    [searchResults release];
    searchResults = nil;
    [myDelegate release];
    myDelegate = nil;
    searchInProgress = NO;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (NSArray *)getSearchResults
{
    return searchResults;
}

#pragma mark - NSXMLParserDelegate
/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    [(BMLT_Parser *)parser setCurrentElement:nil];
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"A_BMLT_Search Parser Start %@ element", elementName );
#endif
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"A_BMLT_Search Parser foundCharacters: \"%@\"", string );
#endif
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"A_BMLT_Search Parser Stop %@ element", elementName );
#endif
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser
parseErrorOccurred:(NSError *)parseError
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"A_BMLT_Search Parser Error: %@", [parseError localizedDescription] );
#endif
    [parser abortParsing];
    if ( myDelegate )
        {
        [myDelegate searchCompleteWithError:parseError];
        }
    
#ifdef DEBUG
    NSLog(@"A_BMLT_Search parseErrorOccurred Releasing Parser");
#endif
    searchInProgress = NO;
    
}

/***************************************************************\**
 \brief 
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
