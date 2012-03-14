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
 *          What this segue does, is manage a transition between two navigation views,
 *          so that the direction of the switch approximates the navbar button that was hit.
 *          Additionally, it make sure that we don't keep "piling" views on the nav controller.
 *          since we're using two buttons on the navbar for each view, and are expressing a linked
 *          affordance, we need to reset the nav controller each time, as we would otherwise
 *          just keep piling views on top of each other.
 */
- (void)perform
{
#if DEBUG
    NSLog(@"BMLTSegwayController:perform, going %@, from %@, to %@.", [self identifier], [self sourceViewController], [self destinationViewController]);
#endif
    UIViewController        *src = (UIViewController *)[self sourceViewController];
    UIViewController        *dest = (UIViewController *)[self destinationViewController];
    UINavigationController  *navCtl = [src navigationController];
    UIViewAnimationOptions  options = [[self identifier] isEqualToString:@"left"] ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight;
    
    // What we do here, is ensure that we don't overstack the nav controller. We pop to root, then stack the new view controller.
    [navCtl popToRootViewControllerAnimated:NO];
    [navCtl pushViewController:dest animated:NO];
    
    [UIView transitionFromView:[src view]
                        toView:[dest view]
                      duration:0.25
                       options: options
                    completion:nil];
}
@end
