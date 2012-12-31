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

extern int List_Meeting_Format_Circle_Size;   ///< These govern the display of the format code circles.
extern int List_Meeting_Format_Line_Padding;

@class BMLT_Format; ///< We'll define this class in just a bit.

/*****************************************************************/
/**
 \class BMLT_FormatButton
 \brief This class describes a format button to be displayed (I know,
        I know. It breaks MVC, but I wanted to bring over as much code
        as possible from the hurriedly-designed first version).
 *****************************************************************/
@interface BMLT_FormatButton : UIButton
{
    BMLT_Format         *myFormat;
}
- (id)initWithFrame:(CGRect)frame andFormat:(BMLT_Format *)theFormat;
- (void)setMyFormat:(BMLT_Format *)inFormat;
- (BMLT_Format *)getMyFormat;
@end

@class UIColor;

/*****************************************************************/
/**
 \class FormatUIElements
 \brief This class contains elements used to display a format.
 *****************************************************************/
@interface FormatUIElements : NSObject
{
    UIColor     *textColor;     ///< The color displayed behind the format.
    NSString    *imageName2x;   ///< Any image displayed behind the format.
    NSString    *title;         ///< The title of the format.
}

@property (atomic, strong) UIColor     *textColor;
@property (atomic, strong) NSString    *imageName2x;
@property (atomic, strong) NSString    *title;

@end

/*****************************************************************/
/**
 \class BMLT_Format
 \brief This class contains information about BMLT formats.
 *****************************************************************/
@interface BMLT_Format : A_BMLT_ChildClass <BMLT_NameDescProtocol, NSXMLParserDelegate>
{
    NSString    *bmlt_name;         ///< The name of the format.
    NSString    *bmlt_description;  ///< An extended textual description of the format.
}

@property (atomic, strong) NSString    *formatID;       ///< The shared ID of the format.
@property (atomic, strong) NSString    *key;            ///< The textual format key.
@property (atomic, strong) NSString    *lang;           ///< The language for the format display.
@property (atomic, strong) NSString    *currentElement; ///< Used during parsing.

+ (FormatUIElements *)getFormatColor:(BMLT_Format *)inFormat;

- (id)initWithParent:(NSObject *)inParentObject andKey:(NSString *)inKey andName:(NSString *)inName andDescription:(NSString *)inDescription;
@end
