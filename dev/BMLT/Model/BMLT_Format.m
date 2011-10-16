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

#import "BMLT_Format.h"
#import "BMLT_Server.h"
#import <UIKit/UIKit.h>

@implementation BMLT_Format

#pragma mark - Static Functions -

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
+ (FormatUIElements)getFormatColor:(BMLT_Format *)inFormat
{
    FormatUIElements    ret;
    
    ret.imageName2x = @"FormatCircleYellow@2x.png";
    ret.textColor = [UIColor blackColor];
    ret.title = [inFormat getKey];
    
    if ( [ret.title isEqualToString:NSLocalizedString(@"FORMAT-KEY-OPEN", nil)] )
        {
        ret.imageName2x = @"FormatCircleGreen@2x.png";
        ret.textColor = [UIColor whiteColor];
        }
    else
        {
        if ( [ret.title isEqualToString:NSLocalizedString(@"FORMAT-KEY-CLOSED", nil)] )
            {
            ret.imageName2x = @"FormatCircleRed@2x.png";
            ret.textColor = [UIColor whiteColor];
            }
        else
            {
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
 \brief 
 \returns 
 *****************************************************************/
- (id)init
{
    return [self initWithParent:nil andKey:nil andName:nil andDescription:nil];
}

/***************************************************************\**
 \brief 
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
 \brief 
 \returns 
 *****************************************************************/
- (id)initWithParent:(NSObject *)inParentObject
              andKey:(NSString *)inKey
              andName:(NSString *)inName
      andDescription:(NSString *)inDescription
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
 \brief 
 *****************************************************************/
- (void)setKey:(NSString *)inKey
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
 \brief 
 \returns 
 *****************************************************************/
- (NSString *)getKey
{
    return key;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setLang:(NSString *)inLang
{
    [inLang retain];
    [lang release];
    lang = inLang;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (NSString *)getLang
{
    return lang;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setFormatID:(NSString *)inID
{
    [inID retain];
    [formatID release];
    formatID = inID;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (NSString *)getFormatID
{
    return formatID;
}

#pragma mark - Protocol Functions
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
#ifdef _CONNECTION_PARSE_TRACE_
    NSLog(@"\tBMLT_Format Parser Start %@ element", elementName );
#endif
    [elementName retain];
    [currentElement release];
    currentElement = elementName;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string
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
 \brief 
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
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

#ifdef _CONNECTION_PARSE_TRACE_
/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser
parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"\tERROR: BMLT_Meeting Parser Error:%@", [parseError localizedDescription] );
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"\tERROR: Parser Complete, But Too Early!" );
}
#endif

@end
