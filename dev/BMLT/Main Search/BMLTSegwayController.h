//
//  BMLTSegwayController.h
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

/**************************************************************//**
 \class  BMLTSegwayController
 \brief  This class will control the segues between the various search specification dialogs.
 *****************************************************************/
@interface BMLTSegwayController : UIStoryboardSegue
/**
 *          What this segue does, is manage a transition between two navigation views,
 *          so that the direction of the switch approximates the navbar button that was hit.
 *          Additionally, it make sure that we don't keep "piling" views on the nav controller.
 *          since we're using two buttons on the navbar for each view, and are expressing a linked
 *          affordance, we need to reset the nav controller each time, as we would otherwise
 *          just keep piling views on top of each other.
 */
- (void)perform;
@end
