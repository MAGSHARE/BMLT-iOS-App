//
//  BMLT_Meeting_Search.m
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

#import "BMLT_Meeting_Search.h"
#import "BMLT_Meeting.h"
#import "BMLT_Server.h"
#import <UIKit/UIKit.h>

/***************************************************************\**
 \class BMLT_Meeting_Search
 \brief A concrete implementation of the search, based on meetings.
 *****************************************************************/
@implementation BMLT_Meeting_Search

#pragma mark - NSXMLParserDelegate
/***************************************************************\**
 \brief Called when the parser starts on one of the search's
 eclosed data elements.
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser            ///< The parser object
didStartElement:(NSString *)elementName         ///< The name of the element
  namespaceURI:(NSString *)namespaceURI         ///< The XML namespace
 qualifiedName:(NSString *)qName                ///< The XML qName
    attributes:(NSDictionary *)attributeDict    ///< The attributes
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"BMLT_Meeting_Search Parser Start %@ element", elementName );
#endif
    if ( !firstElement && ![elementName isEqual:@"meetings"] )
        {
#ifdef _CONNECTION_PARSE_TRACE_
        NSLog(@"BMLT_Meeting_Search Parser -First element is not a 'meetings' element! The XML is invalid or corrupt! Aborting the parse!" );
#endif
        [parser abortParsing];
        }
    else
        {
        firstElement = YES;
        if ( [elementName isEqual:@"row"] )
            {
#ifdef _CONNECTION_PARSE_TRACE_
            NSLog(@"--> Starting a meeting, handing off to the meeting object" );
#endif
            if ( [[self getSearchResults] count] >= kBMLT_Max_Number_Of_Meetings_In_Response )
                {
#ifdef _CONNECTION_PARSE_TRACE_
                NSLog(@"\tToo many meetings. Stopping the search." );
#endif
                if ( myDelegate )   // Let the delegate know we're done.
                    {
                    [parser abortParsing];
                    NSString    *error_Text = [NSString stringWithFormat:NSLocalizedString(@"TOO-MANY-RESULTS-FORMAT", nil), kBMLT_Max_Number_Of_Meetings_In_Response];
                    
                    NSError *myError = [NSError errorWithDomain:@"Read Error" code:NSFileReadTooLargeError userInfo:[NSDictionary dictionaryWithObject:error_Text forKey:NSLocalizedDescriptionKey]];
                    [myDelegate searchCompleteWithError:myError];
                    myDelegate = nil;
                    }
                }
            else
                {
                BMLT_Meeting    *newMeeting = [[BMLT_Meeting alloc] initWithParent:self andName:nil andDescription:nil];
                
                if ( newMeeting )
                    {
                    [newMeeting setMyServer:[(BMLT_Parser *)parser getMyServer]];
                    [parser setDelegate:newMeeting];
                    [(BMLT_Parser *)parser setCurrentElement:newMeeting];
                    }
                }
            }
        }
}

@end
