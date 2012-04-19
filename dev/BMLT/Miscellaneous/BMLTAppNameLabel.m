//
//  BMLTAppNameLabel.m
//  BMLT
//
//  Created by MAGSHARE
//  Copyright MAGSHARE. All rights reserved.
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

#import "BMLTAppNameLabel.h"

/**************************************************************//**
 \class BMLTAppNameLabel
 \brief This class implements a label that displays the app name.
        This allows a transparent name display that can be easily
        formatted.
 *****************************************************************/
@implementation BMLTAppNameLabel

/**************************************************************//**
 \brief Initializer -Grabs the app name, and sets it as the display.
 \returns self
 *****************************************************************/
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        {
        NSString    *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        NSString    *appInfo = [[NSDictionary dictionaryWithContentsOfFile:plistPath] valueForKey:@"CFBundleName"];
        [self setText:appInfo];
        }
    return self;
}
@end