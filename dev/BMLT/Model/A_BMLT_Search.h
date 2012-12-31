//
//  A_BMLT_Search.h
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
#import "A_BMLT_ChildClass.h"
#import "SearchDelegate.h"

/*****************************************************************/
/**
 \class  A_BMLT_Search
 \brief  This class contains a search instance, with criteria and
         results. The search will run an XML parse.
 *****************************************************************/
@interface A_BMLT_Search : A_BMLT_ChildClass <BMLT_ParentProtocol, BMLT_NameDescProtocol, NSXMLParserDelegate>
{
    NSString                    *bmlt_name;         ///< The name assigned to the search.
    NSString                    *bmlt_description;  ///< A textual description.
    NSMutableDictionary         *searchCriteria;    ///< A dictionary of search criteria.
    NSMutableArray              *searchResults;     ///< Once a search has been run, the results are stored here.
    NSObject<SearchDelegate>    *myDelegate;        ///< The search delegate, that receives status updates from the search.
    BOOL                        searchInProgress;
}

- (BOOL)searchInProgress;
- (id)initWithCriteria:(NSDictionary *)inSearchCriteria andName:(NSString *)inName andDescription:(NSString *)inDescription;
- (void)addSearchCriteriaData:(NSString *)inValue atKey:(NSString *)inKey;
- (NSDictionary *)getCriteria;
- (void)setDelegate:(NSObject<SearchDelegate> *)inDelegate;
- (NSObject<SearchDelegate> *)getDelegate;
- (void)addSearchResult:(NSObject<BMLT_NameDescProtocol> *)inResult;
- (void)doSearch;
- (void)clearSearch;
- (NSArray *)getSearchResults;
@end
