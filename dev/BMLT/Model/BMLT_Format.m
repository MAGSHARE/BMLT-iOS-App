//
//  BMLT_Format.m
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
/***************************************************************\**
 \file  BMLT_Format.m
 \brief This class describes a format code (used to display meeting
        formats). It is "owned" by a BMLT_Server instance.
 *****************************************************************/

#import "BMLT_Format.h"
#import "BMLT_Server.h"
#import <UIKit/UIKit.h>

@implementation BMLT_Format

#pragma mark - Static Functions -

/***************************************************************\**
 \brief Static function to return the indicator color and image for the format.
 \returns a FormatUIElements object, containing the display options
 for the format.
    - imageName2x This is the image to display
    - textColor This is the color of the key text, displayed over the image.
    - title This is the string to be displayed
 *****************************************************************/
+ (FormatUIElements)getFormatColor:(BMLT_Format *)inFormat  ///< The format object
{
    FormatUIElements    ret;
    
        // Default is yellow, with black text.
    ret.imageName2x = @"FormatCircleYellow@2x.png";
    ret.textColor = [UIColor blackColor];
    ret.title = [inFormat getKey];
    
        // Open meetings get a green circle with white text.
    if ( [ret.title isEqualToString:NSLocalizedString(@"FORMAT-KEY-OPEN", nil)] )
        {
        ret.imageName2x = @"FormatCircleGreen@2x.png";
        ret.textColor = [UIColor whiteColor];
        }
    else
        {   // Closed meetings get a red circle with white text.
        if ( [ret.title isEqualToString:NSLocalizedString(@"FORMAT-KEY-CLOSED", nil)] )
            {
            ret.imageName2x = @"FormatCircleRed@2x.png";
            ret.textColor = [UIColor whiteColor];
            }
        else
            {   // WC accessible meetings get the handicapped logo with no text.
            if ( [ret.title isEqualToString:NSLocalizedString(@"FORMAT-KEY-WHEELCHAIR", nil)] )
                {
                ret.imageName2x = @"FormatCircleWC@2x.png";
                ret.title = @"";
                }
            }
        }
    
    return ret;
}

#pragma mark - Override Functions -

/***************************************************************\**
 \brief Initializer
 \returns self
 *****************************************************************/
- (id)init
{
    return [self initWithParent:nil andKey:nil andName:nil andDescription:nil];
}

/***************************************************************\**
 \brief un-initializer
 *****************************************************************/
- (void)dealloc
{
    [key release];
    [bmlt_name release];
    [bmlt_description release];
    [currentElement release];
    [super dealloc];
}

#pragma mark - Class-Specific Functions -

/***************************************************************\**
 \brief Initializes with various initial setup data
 \returns self
 *****************************************************************/
- (id)initWithParent:(NSObject *)inParentObject ///< The BMLT_Server object that "owns" this format.
              andKey:(NSString *)inKey          ///< The format "key" string.
             andName:(NSString *)inName         ///< The short name of the format.
      andDescription:(NSString *)inDescription  ///< The longer description for display in the popover.
{
    self = [super initWithParent:inParentObject];
    if (self)
        {
        [self setKey:inKey];
        [self setBMLTName:inName];
        [self setBMLTDescription:inDescription];
        }
    
    return self;
}

/***************************************************************\**
 \brief Sets the format key string.
 *****************************************************************/
- (void)setKey:(NSString *)inKey    ///< The format key string
{
    [inKey retain];
    [key release];
    
    key = nil;
    
    if ( inKey )
        {
        key = inKey;
        }
}

/***************************************************************\**
 \brief Accessor -get the key string
 \returns a string, containing the key.
 *****************************************************************/
- (NSString *)getKey
{
    return key;
}

/***************************************************************\**
 \brief Set the language code for this format
 *****************************************************************/
- (void)setLang:(NSString *)inLang  ///< The format language
{
    [inLang retain];
    [lang release];
    lang = inLang;
}

/***************************************************************\**
 \brief Accessor -get the format language
 \returns a string, containing the format language code
 *****************************************************************/
- (NSString *)getLang
{
    return lang;
}

/***************************************************************\**
 \brief Set the format ID
 *****************************************************************/
- (void)setFormatID:(NSString *)inID    ///< The format ID string.
{
    [inID retain];
    [formatID release];
    formatID = inID;
}

/***************************************************************\**
 \brief Accessor -get the format ID string
 \returns a string, containing the format ID
 *****************************************************************/
- (NSString *)getFormatID
{
    return formatID;
}

#pragma mark - Protocol Functions
#pragma mark - BMLT_NameDescProtocol
/***************************************************************\**
 \brief Set the format short name
 *****************************************************************/
- (void)setBMLTName:(NSString *)inName  ///< A string, containing the format name
{
    [inName retain];
    [bmlt_name release];
    bmlt_name = inName;
}

/***************************************************************\**
 \brief Set the format longer description
 *****************************************************************/
- (void)setBMLTDescription:(NSString *)inDescription    ///< A string, containing the format longer description
{
    [inDescription retain];
    [bmlt_description release];
    bmlt_description = inDescription;
}


/***************************************************************\**
 \brief Accessor -get the short format name.
 \returns a string with the short format name.
 *****************************************************************/
- (NSString *)getBMLTName
{
    return bmlt_name;
}

/***************************************************************\**
 \brief Accessor -get the longer format description
 \returns a string, with the longer format description.
 *****************************************************************/
- (NSString *)getBMLTDescription
{
    return bmlt_description;
}

#pragma mark - NSXMLParserDelegate
/***************************************************************\**
 \brief Called when the parser starts on one of the format element's
 eclosed data elements.
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser            ///< The parser object
didStartElement:(NSString *)elementName         ///< The name of the element
  namespaceURI:(NSString *)namespaceURI         ///< The XML namespace
 qualifiedName:(NSString *)qName                ///< The XML qName
    attributes:(NSDictionary *)attributeDict    ///< The attributes
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"\tBMLT_Format Parser Start %@ element", elementName );
#endif
    [elementName retain];
    [currentElement release];
    currentElement = elementName;
}

/***************************************************************\**
 \brief Called when the XML parser is reading element characters.
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser    ///< The parser object
foundCharacters:(NSString *)string      ///< The characters
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"\t\tCharacters \"%@\" Received for the Element: \"%@\"", string, currentElement);
#endif
    if ( [currentElement isEqual:@"id"] )
        {
        [self setFormatID:string];
        }
    else
        {
        if ( [currentElement isEqual:@"name_string"] )
            {
            [self setBMLTName:string];
            }
        else
            {
            if ( [currentElement isEqual:@"description_string"] )
                {
                [self setBMLTDescription:string];
                }
            else
                {
                if ( [currentElement isEqual:@"key_string"] )
                    {
                    [self setKey:string];
                    }
                else
                    {
                    if ( [currentElement isEqual:@"lang"] )
                        {
                        [self setLang:string];
                        }
#ifdef DEBUG
                    else
                        {
                        NSLog(@"\t\tERROR: Characters \"%@\" Received for Unknown Element: \"%@\"", string, currentElement);
                        }
#endif
                    }
                }
            }
        }
}

/***************************************************************\**
 \brief Called when the XML parser is done with the element.
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser    ///< The parser object
 didEndElement:(NSString *)elementName  ///< The name of the element being ended
  namespaceURI:(NSString *)namespaceURI ///< The XML namespace
 qualifiedName:(NSString *)qName        ///< The XML qName
{
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"\tBMLT_Format Parser Stop %@ element", elementName );
#endif
    if ( [elementName isEqual:@"row"] )
        {
#ifdef _CONNECTION_PARSE_TRACE_
        NSLog(@"\tAdding Format named \"%@\" to Server.", bmlt_name );
#endif
        BMLT_Server *my_server = (BMLT_Server *)[self getParentObject];
        
        [my_server addFormat:self];
        [parser setDelegate:my_server];
        
#ifdef _CONNECTION_PARSE_TRACE_
        NSLog(@"<-- Format Complete, handing back to the server object" );
#endif
        }
    [currentElement release];
    currentElement = nil;
}

    // We only use these for debug. Otherwise, we ignore errors and premature endings.
#ifdef _CONNECTION_PARSE_TRACE_
/***************************************************************\**
 \brief Called when the parser receives an error.
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser        ///< The parser object
parseErrorOccurred:(NSError *)parseError    ///< The error object
{
    NSLog(@"\tERROR: BMLT_Meeting Parser Error:%@", [parseError localizedDescription] );
}

/***************************************************************\**
 \brief Called when the parser ends the document (should never happen).
 *****************************************************************/
- (void)parserDidEndDocument:(NSXMLParser *)parser  ///< The parser object
{
    NSLog(@"\tERROR: Parser Complete, But Too Early!" );
}
#endif

@end
