//
//  BMLTSimpleSearchViewController.m
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

#import "BMLTSimpleSearchViewController.h"

/***************************************************************\**
 \class  BMLTSimpleSearchViewController  -Private Interface
 \brief  This class will present the user with a simple "one-button" interface.
 *****************************************************************/
@interface BMLTSimpleSearchViewController ()

@end

/***************************************************************\**
 \class  BMLTSimpleSearchViewController  -Implementation
 \brief  This class will present the user with a simple "one-button" interface.
 *****************************************************************/
@implementation BMLTSimpleSearchViewController

/***************************************************************\**
 \brief  Initialize the objectfrom a xib/bundle (used by storyboard)
 \returns    self
 *****************************************************************/
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
        {
        }
    return self;
}

/***************************************************************\**
 \brief  Called after the controller's view object has loaded.
 *****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
}

/***************************************************************\**
 \brief  Called after the controller's view object has unloaded.
 *****************************************************************/
- (void)viewDidUnload
{
    [super viewDidUnload];
}

/***************************************************************\**
 \brief  Called to validate the autorotation.
 \returns    a BOOL. YES if the rotation is approved.
 *****************************************************************/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
@end
