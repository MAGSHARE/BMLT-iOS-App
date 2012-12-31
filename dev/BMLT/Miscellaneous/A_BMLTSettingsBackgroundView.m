//
//  A_BMLTSettingsBackgroundView.m
//  BMLT
//
//  Created by MAGSHARE.
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

#import "A_BMLTSettingsBackgroundView.h"

/*****************************************************************/
/**
 \class  A_BMLTSettingsBackgroundView    -Implementation
 \brief  This class will simply apply the settings background to a view.
 *****************************************************************/
@implementation A_BMLTSettingsBackgroundView

/*****************************************************************/
/**
 \brief  Set the view backgound to the standard light linen color.
 \returns   self
 *****************************************************************/
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
        {
        if ( [BMLTVariantDefs settingsBackgroundColor] )
            {
            [self setBackgroundColor:[BMLTVariantDefs settingsBackgroundColor]];
            }
        }
    return self;
}
@end
