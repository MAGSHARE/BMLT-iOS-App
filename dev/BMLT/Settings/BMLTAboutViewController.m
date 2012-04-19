//
//  BMLTAboutViewController.m
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

#import "BMLTAboutViewController.h"

/**************************************************************//**
 \class  BMLTAboutViewController -Private Interface
 \brief  Simply displays information about the app.
 *****************************************************************/
@interface BMLTAboutViewController ()

@end

/**************************************************************//**
 \class  BMLTAboutViewController -Implementation
 \brief  Simply displays information about the app.
 *****************************************************************/
@implementation BMLTAboutViewController

/**************************************************************//**
 \brief  Initialize the objectfrom a xib/bundle (used by storyboard)
 \returns    self
 *****************************************************************/
@synthesize versionLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
        {
        }
    return self;
}

/**************************************************************//**
 \brief  Called after the controller's view object has loaded.
 *****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self versionLabel] setText:NSLocalizedString([[self versionLabel] text], nil)];
}

/**************************************************************//**
 \brief  Called after the controller's view object has unloaded.
 *****************************************************************/
- (void)viewDidUnload
{
    [self setVersionLabel:nil];
    [super viewDidUnload];
}
@end
