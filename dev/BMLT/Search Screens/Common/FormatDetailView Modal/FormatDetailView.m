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
#import <QuartzCore/QuartzCore.h>
#import "A_SearchController.h"

@implementation FormatDetailView

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (id)initWithFormat:(BMLT_Format *)inFormat
       andController:(A_SearchController *)inController
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
        UIGestureRecognizer    *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(donePressed:)];
        [(UISwipeGestureRecognizer*)gestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight];
        [[self view] addGestureRecognizer:gestureRecognizer];
        [gestureRecognizer release];
        gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(donePressed:)];
        [[self view] addGestureRecognizer:gestureRecognizer];
        [gestureRecognizer release];
        }
    
    return self;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)dealloc
{
    [myModalController closeModal];
    [myFormat release];
    [formatKeyLabel release];
    [formatKeyImage release];
    [formatDescription release];
    [navBar release];
    [super dealloc];
}

#pragma mark - View lifecycle

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)viewDidLoad
{
    [self setBeanieBackground];
    [self setTitle];
    [self setDescription];
    [self setUpKey];
    [super viewDidLoad];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setUpKey
{
    FormatUIElements    fmtEl = [BMLT_Format getFormatColor:myFormat];

    [formatKeyImage setImage:[UIImage imageNamed:fmtEl.imageName2x]];
    [formatKeyLabel setText:fmtEl.title];
    [formatKeyLabel setTextColor:fmtEl.textColor];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setTitle
{
    [[navBar topItem] setTitle:[myFormat getBMLTName]];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setDescription
{
    [formatDescription setText:[myFormat getBMLTDescription]];
}

/***************************************************************\**
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

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)viewDidUnload
{
    [navBar release];
    navBar = nil;
    [formatKeyLabel release];
    formatKeyLabel = nil;
    [formatKeyImage release];
    formatKeyImage = nil;
    [formatDescription release];
    formatDescription = nil;
    [super viewDidUnload];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setMyModalController:(A_SearchController *)inController
{
    [inController retain];
    [myModalController release];
    myModalController = inController;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (A_SearchController *)getMyModalController
{
    return myModalController;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (IBAction)donePressed:(id)sender
{
    [myModalController closeModal];
    myModalController = nil;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setMyFormat:(BMLT_Format *)inFormat
{
    [inFormat retain];
    [myFormat release];
    myFormat = inFormat;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (BMLT_Format *)getMyFormat
{
    return myFormat;
}

/***************************************************************\**
 \brief This applies the "Beanie Background" to the results view.
 *****************************************************************/
- (void)setBeanieBackground
{
    [[[self view] layer] setContentsGravity:kCAGravityResizeAspectFill];
    [[[self view] layer] setBackgroundColor:[[UIColor colorWithWhite:0 alpha:0] CGColor]];
    [[[self view] layer] setContents:(id)[[UIImage imageNamed:@"BeanieBack.png"] CGImage]];
}

@end
