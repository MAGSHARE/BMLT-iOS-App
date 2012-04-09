//
//  BMLTActionButtonViewController.m
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

#import "BMLTActionButtonViewController.h"

/**************************************************************//**
 \class BMLTActionButtonViewController
 \brief This implements the popver (iPad) or modal dialog (iPhone)
 that allows a user to create a PDF and send by email, or
 print the search/meeting details.
 *****************************************************************/
@implementation BMLTActionButtonViewController
@synthesize containerView;
@synthesize emailButton;
@synthesize printButton;
@synthesize myModalController;

/**************************************************************//**
 \brief We set up the background colors and whatnot, here.
 *****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set all the localized strings.
    [[navBar topItem] setTitle:NSLocalizedString([[navBar topItem] title], nil)];
    [[self emailButton] setTitle:NSLocalizedString([[self emailButton] titleForState:UIControlStateNormal], nil) forState:UIControlStateNormal];
    [[self printButton] setTitle:NSLocalizedString([[self printButton] titleForState:UIControlStateNormal], nil) forState:UIControlStateNormal];
    
    CGRect  frame = [[self containerView] frame];
    frame.size.height += frame.origin.y;
    
    [self setContentSizeForViewInPopover:frame.size];
    // With a popover, we don't need the "Done" button.
    if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad )
        {
        if ( [BMLTVariantDefs popoverBackgroundColor] )
            {
            [[self view] setBackgroundColor:[BMLTVariantDefs popoverBackgroundColor]];
            }
        [(UINavigationItem *)[navBar topItem] setRightBarButtonItem:nil animated:NO];
        }
    else
        {
        if ( [BMLTVariantDefs modalBackgroundColor] )
            {
            [[self view] setBackgroundColor:[BMLTVariantDefs modalBackgroundColor]];
            }
        }
}

/**************************************************************//**
 \brief Just cleaning up.
 *****************************************************************/
- (void)viewDidUnload
{
    [self setEmailButton:nil];
    [self setPrintButton:nil];
    [self setContainerView:nil];
    [super viewDidUnload];
}

/**************************************************************//**
 \brief We follow the same rules as all the other views.
 \returns YES, if the autorotation is approved.
 *****************************************************************/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io   ///< The desired orientation
{
    BOOL    ret = (io == UIInterfaceOrientationPortrait);   // iPhone is portrait-only.
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)   // iPad is any which way.
        {
        ret = YES;
        }
    
    return ret;
}

/**************************************************************//**
 \brief This is called to close the dialog.
 *****************************************************************/
- (IBAction)doneButtonPressed:(id)sender
{
    [[self myModalController] closeModal];
}

/**************************************************************//**
 \brief This is called if the user presses the email button.
 *****************************************************************/
- (IBAction)emailPDFPressed:(id)sender  ///< The email button object
{
#ifdef DEBUG
    NSLog(@"BMLTActionButtonViewController::emailPDFPressed:");
#endif
}

/**************************************************************//**
 \brief This is called if the user presses the print button.
 *****************************************************************/
- (IBAction)printButtonPressed:(id)sender   ///< The print button object
{
#ifdef DEBUG
    NSLog(@"BMLTActionButtonViewController::printButtonPressed:");
#endif
}
@end
