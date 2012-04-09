//
//  FormatDetailView.m
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

#import "BMLTFormatDetailViewController.h"
#import "BMLT_Format.h"
#import "A_BMLTSearchResultsViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation BMLTFormatDetailViewController

/**************************************************************//**
 \brief We set up the popover size, here.
 \returns self
 *****************************************************************/
- (id)initWithFormat:(BMLT_Format *)inFormat            ///< The format object for the display.
       andController:(UIViewController *)inController   ///< The modal controller for the display.
{
    self = [super init];
    
    if ( self )
        {
        [self setMyFormat:inFormat];
        [self setMyModalController:inController];
        CGRect  myBounds = [[self view] bounds];
        CGRect  lowestFrame = [formatDescription frame];
        
        myBounds.size.height = lowestFrame.origin.y + lowestFrame.size.height + 8;
        
        [self setContentSizeForViewInPopover:myBounds.size];    // Make sure our popover isn't too big.
        }
    
    return self;
}

#pragma mark - View lifecycle -

/**************************************************************//**
 \brief Set up all the various dialog items
 *****************************************************************/
- (void)viewDidLoad
{
    [self setTitle];
    [self setDescription];
    [self setUpKey];
    // With a popover, we don't need the "Done" button.
    if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad )
        {
        if ( [BMLTVariantDefs popoverBackgroundColor] )
            {
            UIColor *myBGColor = [[UIColor alloc] initWithCGColor:[[BMLTVariantDefs popoverBackgroundColor] CGColor]];
            [[self view] setBackgroundColor:myBGColor];
            myBGColor = nil;
            }
        [(UINavigationItem *)[navBar topItem] setRightBarButtonItem:nil animated:NO];
        }
    else
        {
        if ( [BMLTVariantDefs modalBackgroundColor] )
            {
            UIColor *myBGColor = [[UIColor alloc] initWithCGColor:[[BMLTVariantDefs modalBackgroundColor] CGColor]];
            [[self view] setBackgroundColor:myBGColor];
            myBGColor = nil;
            }
        }
    [super viewDidLoad];
}

/**************************************************************//**
 \brief Just cleaning up.
 *****************************************************************/
- (void)viewDidUnload
{
//    [(A_BMLTSearchResultsViewController *)myModalController closeModal];
    navBar = nil;
    formatKeyLabel = nil;
    formatKeyImage = nil;
    formatDescription = nil;
    [super viewDidUnload];
}

#pragma mark - Custom Functions -

/**************************************************************//**
 \brief Set up the format key display.
 *****************************************************************/
- (void)setUpKey
{
    FormatUIElements    *fmtEl = [BMLT_Format getFormatColor:myFormat];

    [formatKeyImage setImage:[UIImage imageNamed:fmtEl.imageName2x]];
    [formatKeyLabel setText:fmtEl.title];
    [formatKeyLabel setTextColor:fmtEl.textColor];
}

/**************************************************************//**
 \brief Set the format title in the navbar.
 *****************************************************************/
- (void)setTitle
{
    [[navBar topItem] setTitle:[myFormat getBMLTName]];
}

/**************************************************************//**
 \brief Set the format description.
 *****************************************************************/
- (void)setDescription
{
    [formatDescription setText:[myFormat getBMLTDescription]];
}

/**************************************************************//**
 \brief We follow the same rules as all the other views.
 \returns YES, if the autorotation is approved.
 *****************************************************************/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    BOOL    ret = (io == UIInterfaceOrientationPortrait);   // iPhone is portrait-only.
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)   // iPad is any which way.
        {
        ret = YES;
        }
    
    return ret;
}

/**************************************************************//**
 \brief Set the modal controller data member.
 *****************************************************************/
- (void)setMyModalController:(UIViewController *)inController   ///< The modal controller for this view.
{
    myModalController = inController;
}

/**************************************************************//**
 \brief   Accessor -return the view's modal controller.
 \returns the modal controller for the view.
 *****************************************************************/
- (UIViewController *)getMyModalController
{
    return myModalController;
}

/**************************************************************//**
 \brief Called when the user presses the "Done" button.
 *****************************************************************/
- (IBAction)donePressed:(id)sender  ///< The done button object.
{
    [(A_BMLTSearchResultsViewController *)myModalController closeModal];
    myModalController = nil;
}

/**************************************************************//**
 \brief Set the format object for this display.
 *****************************************************************/
- (void)setMyFormat:(BMLT_Format *)inFormat
{
    myFormat = inFormat;
}

/**************************************************************//**
 \brief Accessor -return the format object for this display.
 \returns the display's format object.
 *****************************************************************/
- (BMLT_Format *)getMyFormat
{
    return myFormat;
}

@end
