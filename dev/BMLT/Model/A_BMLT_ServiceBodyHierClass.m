//
//  A_BMLT_ServiceBodyHierClass.m
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

#import "A_BMLT_ServiceBodyHierClass.h"

@implementation A_BMLT_ServiceBodyHierClass

#pragma mark - Override Functions -

/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
- (id)init
{
    return [self initWithURI:nil andParent:nil andName:nil andDescription:nil];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)dealloc
{
    [uri release];
    [bmlt_name release];
    [bmlt_description release];
    [cachedServiceBodies release];
    [super dealloc];
}

#pragma mark - Class-Specific Functions -

/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
- (id)initWithURI:(NSString *)inURI
        andParent:(NSObject *)inParentObject
          andName:(NSString *)inName
   andDescription:(NSString *)inDescription
{
    self = [super initWithParent:inParentObject];
    
    if (self)
        {
        [self setURI:inURI];
        [self setBMLTName:inName];
        [self setBMLTDescription:inDescription];
        }
    
    return self;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setURI:(NSString *)inURI
{
    [inURI  retain];
    [uri release];
    
    uri = nil;
    
    if ( inURI )
        {
        uri = inURI;
        }
}

/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
- (NSString *)getURI
{
    return uri;
}

#pragma mark - Protocol Functions
#pragma mark - BMLT_ParentProtocol
/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
- (NSArray *)getChildObjects
{
    return cachedServiceBodies;
}

#pragma mark - BMLT_NameDescProtocol
/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setBMLTName:(NSString *)inName
{
    [inName retain];
    [bmlt_name release];
    
    bmlt_name = nil;
    
    if ( inName )
        {
        bmlt_name = inName;
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setBMLTDescription:(NSString *)inDescription
{
    [inDescription retain];
    [bmlt_description release];
    
    bmlt_description = nil;
    
    if ( inDescription )
        {
        bmlt_description = inDescription;
        }
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

@end
