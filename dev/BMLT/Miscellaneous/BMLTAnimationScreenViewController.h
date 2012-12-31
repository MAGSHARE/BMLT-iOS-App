//
//  BMLTAnimationScreenViewController.h
//  BMLT
//
//  Created by MAGSHARE.
//  Copyright 2012 MAGSHARE. All rights reserved.
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

#import <UIKit/UIKit.h>

@class BMLT_AnimationView;

/******************************************************************/
/**
 \class BMLTAnimationScreenViewController
 \brief This implements a view with the animated globe and, if necessary,
        a failure message. It is pushed onto the search stack.
 *****************************************************************/
@interface BMLTAnimationScreenViewController : UIViewController
    @property (weak, nonatomic)             IBOutlet BMLT_AnimationView *animationView;
    @property (weak, nonatomic, readonly)   IBOutlet UILabel            *messageLabel;   ///< This will contain the failure message.
@end
