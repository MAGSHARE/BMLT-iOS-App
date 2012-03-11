//
//  BMLT_Format.h
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

#import "A_BMLT_ChildClass.h"

@class UIColor;

@interface FormatUIElements : NSObject
{
    UIColor     *textColor;
    NSString    *imageName2x;
    NSString    *title;
}

@property (atomic, strong) UIColor     *textColor;
@property (atomic, strong) NSString    *imageName2x;
@property (atomic, strong) NSString    *title;

@end

@interface BMLT_Format : A_BMLT_ChildClass <BMLT_NameDescProtocol, NSXMLParserDelegate>
{
    NSString    *bmlt_name;
    NSString    *bmlt_description;
}

@property (atomic, strong) NSString    *formatID;
@property (atomic, strong) NSString    *key;
@property (atomic, strong) NSString    *lang;
@property (atomic, strong) NSString    *currentElement;

+ (FormatUIElements *)getFormatColor:(BMLT_Format *)inFormat;

- (id)initWithParent:(NSObject *)inParentObject andKey:(NSString *)inKey andName:(NSString *)inName andDescription:(NSString *)inDescription;
@end
