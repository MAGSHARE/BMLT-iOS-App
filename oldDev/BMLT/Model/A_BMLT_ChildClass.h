//
//  A_BMLT_ChildClass.h
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

#import <Foundation/Foundation.h>

// \brief   This class simply gives subclasses the ability to have a single "owner" or "parent" object.
//          It is designed to be an abstract class.
@interface A_BMLT_ChildClass : NSObject
{
    NSObject  *parentObject;   ///< This will hold a reference to the parent. It will be retained.
}

- (id)initWithParent:(id)inParent;
- (void)setParentObject:(id)inParentObject;
- (id)getParentObject;

@end
