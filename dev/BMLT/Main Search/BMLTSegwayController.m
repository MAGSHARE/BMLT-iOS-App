//
//  BMLTSegwayViewController.m
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

#import "BMLTSegwayController.h"

/**********************************************************************************/
/**
 *  \class  BMLTSegwayController -Private interface
 *  \brief  This class will control the segues between the various search specification dialogs.
 */
@interface BMLTSegwayController ()
@end

/**********************************************************************************/
/**
 *  \class  BMLTSegwayController -Implementation
 *  \brief  This class will control the segues between the various search specification dialogs.
*/
@implementation BMLTSegwayController

/**********************************************************************************/
/**
 *  \brief  Actually do the dirty deed.
 */
- (void)perform
{
#if DEBUG
    NSLog(@"BMLTSegwayController:perform, going %@, from %@, to %@.", [self identifier], [self sourceViewController], [self destinationViewController]);
#endif
}
@end
