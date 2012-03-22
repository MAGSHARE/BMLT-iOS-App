//
//  BMLTListResultsViewController.m
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

#import "BMLTListResultsViewController.h"
#import "BMLTDisplayListResultsViewController.h"
#import "BMLTAppDelegate.h"

/**************************************************************//**
 \class  BMLTListResultsViewController -Private Interface
 \brief  This class will control display of listed results.
 *****************************************************************/
@interface BMLTListResultsViewController ()
{
    BMLTDisplayListResultsViewController    *myController;
}
@end

/**************************************************************//**
 \class  BMLTListResultsViewController -Private Interface
 \brief  This class will control display of listed results.
 *****************************************************************/
@implementation BMLTListResultsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ( !myController )
        {
        myController = [[BMLTDisplayListResultsViewController alloc] initWithNibName:nil bundle:nil];
        }
    
    [myController setDataArrayFromData:[[BMLTAppDelegate getBMLTAppDelegate] searchResults]];
}
@end
