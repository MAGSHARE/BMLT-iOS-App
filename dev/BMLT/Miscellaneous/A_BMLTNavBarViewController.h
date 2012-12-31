//
//  A_BMLTNavBarViewController.h
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

#import <UIKit/UIKit.h>

/*****************************************************************/
/**
 \class A_BMLTNavBarViewController
 \brief This class acts as a base class for the nav controllers.
        Its purpose is to assign the correct strings to everything.
 *****************************************************************/
@interface A_BMLTNavBarViewController : UIViewController
- (void)addClearSearchButton;
@end
