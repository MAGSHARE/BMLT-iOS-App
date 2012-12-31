//
//  SearchDelegate.h
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

@class A_BMLT_Search;

/*****************************************************************/
/**
 \class SearchDelegate
 \brief Template for classes that want to be delegates of a search.
 *****************************************************************/
@protocol SearchDelegate <NSObject>

- (void)abortSearch;
- (void)executeSearchWithParams:(NSDictionary *)inSearchParams;
- (void)searchCompleteWithError:(NSError *)inError;
- (A_BMLT_Search *)getSearch;
@end
