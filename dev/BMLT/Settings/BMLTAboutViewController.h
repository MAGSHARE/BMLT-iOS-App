//
//  BMLTAboutViewController.h
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
#import "A_BMLTNavBarViewController.h"

/*****************************************************************/
/**
 \class  BMLTAboutViewController
 \brief  Simply displays information about the app.
 *****************************************************************/
@interface BMLTAboutViewController : A_BMLTNavBarViewController
@property (weak, nonatomic) IBOutlet UILabel        *versionLabel;
@property (weak, nonatomic) IBOutlet UIImageView    *logoImageView;

@end
