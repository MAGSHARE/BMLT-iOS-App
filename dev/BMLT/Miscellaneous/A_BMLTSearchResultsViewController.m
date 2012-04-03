//
//  A_BMLTSearchResultsViewController.m
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

#import "A_BMLTSearchResultsViewController.h"
#import "FormatDetailView.h"
#import "BMLT_Format.h"
#import "BMLTAppDelegate.h"

/**************************************************************//**
 \class  A_BMLTSearchResultsViewController -Private Interface
 \brief  This class will control display of listed results.
 *****************************************************************/
@interface A_BMLTSearchResultsViewController ()

@end

/**************************************************************//**
 \class  A_BMLTSearchResultsViewController
 \brief  This class will control display of listed results.
 *****************************************************************/
@implementation A_BMLTSearchResultsViewController

@synthesize dataArray = _dataArray, myModalController;

/**************************************************************//**
 \brief Specialize the implicit call, because we trigger a redraw, and
 we want to be able to use a regular array, not a mutable one.
 *****************************************************************/
- (void)setDataArrayFromData:(NSArray *)dataArray   ///< The array of data to be used for this view.
{
    _dataArray = nil;
    _dataArray = [[NSMutableArray alloc] init];
    [_dataArray setArray:dataArray];
    [[self view] setNeedsDisplay];
}

/**************************************************************//**
 \brief G'night...
 *****************************************************************/
- (void)dealloc
{
    [_dataArray removeAllObjects];
    _dataArray = nil;
}

/**************************************************************//**
 \brief This pushes a meeting detail screen into view.
 *****************************************************************/
- (void)viewMeetingDetails:(BMLT_Meeting *)inMeeting    ///< The meeting being displayed.
{
    // The app delegate takes care of pushing the details window onto the stack.
    [BMLTAppDelegate viewMeetingDetails:inMeeting inContext:[self myModalController]];
}

/**************************************************************//**
 \brief This is called when someone clicks on a format button.
 *****************************************************************/
- (void)displayFormatDetail:(id)inSender
{
    BMLT_FormatButton   *myButton = (BMLT_FormatButton *)inSender;
    BMLT_Format         *myFormat = [myButton getMyFormat];
    CGRect              selectRect = [myButton frame];
#ifdef DEBUG
    NSLog(@"Format Button Pressed for %@", [myFormat key]);
#endif
    
    myModalView = [[FormatDetailView alloc] initWithFormat:myFormat andController:self];
    
    if ( myModalView )
        {
        if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) && !CGRectIsEmpty(selectRect))
            {
            UIView  *myContext = [myButton superview];
            formatPopover = [[UIPopoverController alloc] initWithContentViewController:myModalView];
            
            [formatPopover setDelegate:self];
            
            [formatPopover presentPopoverFromRect:selectRect
                                           inView:myContext
                         permittedArrowDirections:UIPopoverArrowDirectionAny
                                         animated:YES];
            }
        else
            {
            [self presentModalViewController:myModalView animated:YES];
            }
        }
}

/**************************************************************//**
 \brief This is called to dismiss the modal dialog or popover.
 *****************************************************************/
- (void)closeModal
{
    if (formatPopover)
        {
        [formatPopover dismissPopoverAnimated:YES];
        }
    else
        {
        [self dismissModalViewControllerAnimated:YES];
        }
    
    formatPopover = nil;
    myModalView = nil;
}

/**************************************************************//**
 \brief This is called when the "Clear Search" button is pressed.
 *****************************************************************/
- (IBAction)clearSearch:(id)sender
{
    [[BMLTAppDelegate getBMLTAppDelegate] clearAllSearchResultsYes];
}

@end
