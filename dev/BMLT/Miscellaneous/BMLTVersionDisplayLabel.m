//
//  BMLTVersionDisplayView.m
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

#import "BMLTVersionDisplayLabel.h"

/**************************************************************//**
 \class BMLTVersionDisplayLabel
 \brief This class implements a label that displays the short
        version string. This allows a transparent version display
        that can be easily formatted.
 *****************************************************************/
@implementation BMLTVersionDisplayLabel

/**************************************************************//**
 \brief Initializer -Grabs the version, and sets it as the display.
 \returns self
 *****************************************************************/
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        {
        NSString    *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        NSString    *versionInfo = [[NSDictionary dictionaryWithContentsOfFile:plistPath] valueForKey:@"CFBundleVersion"];
        [self setText:versionInfo];
        }
    return self;
}

@end
