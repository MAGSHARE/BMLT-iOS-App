//
//  BMLT_Server.h
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

#import "A_BMLT_ServiceBodyHierClass.h"
#import "BMLT_Format.h"
#import "BMLT_Parser.h"

#define initial_query_timeout_in_seconds    10
#define format_query_timeout_in_seconds     20

@interface BMLT_Server : A_BMLT_ServiceBodyHierClass <NSXMLParserDelegate>
{
    NSMutableArray      *cachedFormats;
    NSMutableArray      *languages;
    NSString            *version;
    int                 parsingVersion;
    BOOL                versionCheck;
    BOOL                versionSuccess;
    BOOL                loading_formats;
    BOOL                loadFormats;
    NSString            *current_element;
    NSObject            *delegate;
}
- (id)initWithURI:(NSString *)inURI andParent:(NSObject *)inParentObject andName:(NSString *)inName andDescription:(NSString *)inDescription andDelegate:(NSObject *)inDelegate;
- (void)setDelegate:(NSObject *)inDelegate;
- (NSObject *)getDelegate;
- (NSArray *)getFormats;
- (NSArray *)getLanguages;
- (NSString *)getVersion;
- (void)verifyServer;
- (void)loadFormatsAndForce:(BOOL)inForce;
- (void)verifyServerAndAddToParent;
- (BOOL)serverValid;
- (BOOL)addFormat:(BMLT_Format *)inFormat;
- (void)timeoutHandler;
- (void)showTimeoutAlert;
@end
