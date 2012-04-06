//
//  FormatDetailView.m
//  BMLT
//
//  Created by MAGSHARE on 8/13/11.
//  Copyright 2011 MAGSHARE. All rights reserved.
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

#import "FormatDetailView.h"
#import "BMLT_Format.h"
#import "A_BMLTSearchResultsViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation FormatDetailView

/**************************************************************//**
 \brief 
 \returns 
 *****************************************************************/
- (id)initWithFormat:(BMLT_Format *)inFormat
       andController:(UIViewController *)inController
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
 \brief 
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
 \brief 
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
 \brief 
 *****************************************************************/
- (void)setUpKey
{
    FormatUIElements    *fmtEl = [BMLT_Format getFormatColor:myFormat];

    [formatKeyImage setImage:[UIImage imageNamed:fmtEl.imageName2x]];
    [formatKeyLabel setText:fmtEl.title];
    [formatKeyLabel setTextColor:fmtEl.textColor];
}

/**************************************************************//**
 \brief 
 *****************************************************************/
- (void)setTitle
{
    [[navBar topItem] setTitle:[myFormat getBMLTName]];
}

/**************************************************************//**
 \brief 
 *****************************************************************/
- (void)setDescription
{
    [formatDescription setText:[myFormat getBMLTDescription]];
}

/**************************************************************//**
 \brief 
 \returns 
 *****************************************************************/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    BOOL    ret = ((io == UIInterfaceOrientationPortrait) || (io == UIInterfaceOrientationLandscapeLeft) || (io == UIInterfaceOrientationLandscapeRight));
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
        ret = YES;
        }
    return ret;
}

/**************************************************************//**
 \brief 
 *****************************************************************/
- (void)setMyModalController:(UIViewController *)inController
{
    myModalController = inController;
}

/**************************************************************//**
 \brief 
 \returns 
 *****************************************************************/
- (UIViewController *)getMyModalController
{
    return myModalController;
}

/**************************************************************//**
 \brief 
 *****************************************************************/
- (IBAction)donePressed:(id)sender
{
    [(A_BMLTSearchResultsViewController *)myModalController closeModal];
    myModalController = nil;
}

/**************************************************************//**
 \brief 
 *****************************************************************/
- (void)setMyFormat:(BMLT_Format *)inFormat
{
    myFormat = inFormat;
}

/**************************************************************//**
 \brief 
 \returns 
 *****************************************************************/
- (BMLT_Format *)getMyFormat
{
    return myFormat;
}

@end
