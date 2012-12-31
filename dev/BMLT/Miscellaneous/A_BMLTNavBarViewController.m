//
//  A_BMLTNavBarViewController.m
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

#import "A_BMLTNavBarViewController.h"
#import "BMLTAppDelegate.h"

/*****************************************************************/
/**
 \class A_BMLTNavBarViewController - Private Interface
 \brief This class acts as a base class for the nav controllers.
        Its purpose is to assign the correct strings to everything.
 *****************************************************************/
@interface A_BMLTNavBarViewController ()

@end

/*****************************************************************/
/**
 \class A_BMLTNavBarViewController
 \brief This class acts as a base class for the nav controllers.
        Its purpose is to assign the correct strings to everything.
 *****************************************************************/
@implementation A_BMLTNavBarViewController

/*****************************************************************/
/**
 \brief  This adds a "Clear Search" button to the navbar left.
 *****************************************************************/
- (void)addClearSearchButton
{
    UIBarButtonItem     *clearButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"CLEAR-SEARCH-BUTTON", nil) style:UIBarButtonItemStyleBordered target:[BMLTAppDelegate getBMLTAppDelegate] action:@selector(clearAllSearchResultsYes)];
    
    UINavigationItem    *navItem = [self navigationItem];
    
    if ( ![navItem leftBarButtonItem] && ([[self navigationController] topViewController] == [[[self navigationController] viewControllers] objectAtIndex:0]) )
        {
#ifdef DEBUG
        NSLog(@"A_BMLTNavBarViewController addClearSearchButton: Adding a Clear Search Button to the %@ screen", [navItem title] );
#endif
        [navItem setLeftBarButtonItem:clearButton animated:NO];
        }
#ifdef DEBUG
    else
        {
        NSLog(@"A_BMLTNavBarViewController addClearSearchButton: Clear Search Button NOT ADDED to the %@ screen.", [navItem title] );
        if ( [navItem leftBarButtonItem] )
            {
            NSLog(@"A_BMLTNavBarViewController addClearSearchButton: This is because there is already a Left Button." );
            }
        
        if ( ([[self navigationController] topViewController] != [[[self navigationController] viewControllers] objectAtIndex:0]) )
            {
            NSLog(@"A_BMLTNavBarViewController addClearSearchButton: This is because this is not the top controller." );
            }
        }
#endif
}

/*****************************************************************/
/**
 \brief  Called to validate the autorotation.
 \returns    a BOOL. YES if the rotation is approved.
 *****************************************************************/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    BOOL    ret = interfaceOrientation == UIInterfaceOrientationPortrait;   // iPhone is portrait-only.
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)   // iPad is any which way.
        {
        ret = YES;
        }
    
    return ret;
}

/*****************************************************************/
/**
 \brief  This just makes sure that the print popover goes away.
 *****************************************************************/
- (void)viewWillDisappear:(BOOL)animated
{
    [[UIPrintInteractionController sharedPrintController] dismissAnimated:YES];    
}

/*****************************************************************/
/**
 \brief We read in the current string, and do a localized lookup on
        it. We do this for the nav title, as well as the button on
        each side. If the string has already been changed, no prob.
 *****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    UINavigationItem *myItem = [self navigationItem];
    
    NSString    *itemTitle = [myItem title];
    
    [myItem setTitle:NSLocalizedString(itemTitle, nil)];
    
    NSArray *leftBarButtonItems = [myItem leftBarButtonItems];
    NSArray *rightBarButtonItems = [myItem rightBarButtonItems];
    
    if ( [leftBarButtonItems count] )
        {
        for ( NSInteger i = 0; i < [leftBarButtonItems count]; i++ )
            {
            UIBarButtonItem *item = (UIBarButtonItem*)[leftBarButtonItems objectAtIndex:i];
            [item setTitle:NSLocalizedString([item title], nil)];
            }
        }
    
    if ( [rightBarButtonItems count] )
        {
        for ( NSInteger i = 0; i < [rightBarButtonItems count]; i++ )
            {
            UIBarButtonItem *item = (UIBarButtonItem*)[rightBarButtonItems objectAtIndex:i];
            [item setTitle:NSLocalizedString([item title], nil)];
            }
        }
}

@end
