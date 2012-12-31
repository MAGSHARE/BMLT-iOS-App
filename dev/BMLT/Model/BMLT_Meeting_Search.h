//
//  BMLT_Meeting_Search.h
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

#import "A_BMLT_Search.h"

/*****************************************************************/
/**
 \class BMLT_Meeting_Search
 \brief A concrete implementation of the search, based on meetings.
 *****************************************************************/
@interface BMLT_Meeting_Search : A_BMLT_Search
{
    BOOL    firstElement;   ///< Used during parsing.
}
@end
