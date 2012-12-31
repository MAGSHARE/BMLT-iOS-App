//
//  BMLTMainBackgroundView.m
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

#import "A_BMLTMainBackgroundView.h"

/*****************************************************************/
/**
 \class  A_BMLTMainBackgroundView    -Implementation
 \brief  This class will apply the main background color/pattern to a view.
 *****************************************************************/
@implementation A_BMLTMainBackgroundView

/*****************************************************************/
/**
 \brief  Set the view backgound to the appropriate color.
 \returns   self
 *****************************************************************/
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
        {
        if ( [BMLTVariantDefs windowBackgroundColor] )
            {
            UIColor *myBGColor = [[UIColor alloc] initWithCGColor:[[BMLTVariantDefs windowBackgroundColor] CGColor]];
            [self setBackgroundColor:myBGColor];
            myBGColor = nil;
            }
        }
    return self;
}
@end
