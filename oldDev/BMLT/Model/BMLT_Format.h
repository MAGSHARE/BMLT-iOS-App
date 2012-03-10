//
//  BMLT_Format.h
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

#import "A_BMLT_ChildClass.h"

@class UIColor;

typedef struct FormatUIElements_Struct
{
    UIColor     *textColor;
    NSString    *imageName2x;
    NSString    *title;
} FormatUIElements, *FormatUIElementsPtr;

@interface BMLT_Format : A_BMLT_ChildClass <BMLT_NameDescProtocol, NSXMLParserDelegate>
{
    NSString    *bmlt_name;
    NSString    *bmlt_description;
    NSString    *formatID;
    NSString    *key;
    NSString    *lang;
    NSString    *currentElement;
}

+ (FormatUIElements)getFormatColor:(BMLT_Format *)inFormat;

- (id)initWithParent:(NSObject *)inParentObject andKey:(NSString *)inKey andName:(NSString *)inName andDescription:(NSString *)inDescription;
- (void)setKey:(NSString *)inKey;
- (NSString *)getKey;
- (void)setLang:(NSString *)inLang;
- (NSString *)getLang;
- (void)setFormatID:(NSString *)inID;
- (NSString *)getFormatID;
@end
