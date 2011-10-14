//
//  A_BMLT_ChildClass.m
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

@implementation A_BMLT_ChildClass

#pragma mark - Override Functions -

/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
- (id)init
{
    return [self initWithParent:nil];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
-(void)dealloc
{
    [parentObject release];
    [super dealloc];
}

#pragma mark - Class-Specific Functions -

/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
- (id)initWithParent:(id)inParent
{
    self = [super init];
    
    if (self)
        {
        [self setParentObject:inParent];
        }
    
    return self;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setParentObject:(id)inParentObject
{
    [inParentObject retain];
    [parentObject release];
    
    parentObject = inParentObject;
}

/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
- (NSObject *)getParentObject
{
    return parentObject;
}

@end
