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

/******************************************************************/
/**
 \class  BMLTAboutViewController -Private Interface
 \brief  Simply displays information about the app.
 *****************************************************************/
@interface BMLTAboutViewController ()

@end

/******************************************************************/
/**
 \class  BMLTAboutViewController -Implementation
 \brief  Simply displays information about the app.
 *****************************************************************/
@implementation BMLTAboutViewController
@synthesize versionLabel;

/******************************************************************/
/**
 \brief  Called after the controller's view object has loaded.
 *****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[BMLTVariantDefs infoBackgroundColor]];
    [[self versionLabel] setText:NSLocalizedString([[self versionLabel] text], nil)];
    
    // We may add a logo image. If so, we will use that, instead of the standard animation backing.
    UIImage *logo = [UIImage imageNamed:@"AboutLogo.png"];
    
    if ( logo )
        {
        [[self logoImageView] setImage:logo];
        }
}
/******************************************************************/
/**
 \brief  Called after the controller's view object has unloaded.
 *****************************************************************/
- (void)viewDidUnload
{
    [self setVersionLabel:nil];
    [self setLogoImageView:nil];
    [super viewDidUnload];
}
@end
