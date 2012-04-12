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
#import "BMLTFormatDetailViewController.h"
#import "BMLT_Format.h"
#import "BMLTAppDelegate.h"

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
 \brief Called when the "Action Item" in the NavBar is clicked.
 *****************************************************************/
- (IBAction)actionItemClicked:(id)sender
{
#ifdef DEBUG
    NSLog(@"A_BMLTSearchResultsViewController::actionItemClicked:");
#endif
    [self printView];
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
    
    myModalView = [[BMLTFormatDetailViewController alloc] initWithFormat:myFormat andController:self];
    
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
    if (actionPopover)
        {
        [actionPopover dismissPopoverAnimated:YES];
        }

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
    actionPopover = nil;
    printModal = nil;
}

/**************************************************************//**
 \brief Prints the view displayed on the screen.
 *****************************************************************/
- (void)printView
{
#ifdef DEBUG
    NSLog(@"A_BMLTSearchResultsViewController::printView");
#endif
    printModal = [UIPrintInteractionController sharedPrintController];
    
    if ( printModal )
        {
        [printModal setPrintFormatter:[[self view] viewPrintFormatter]];
        if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad )
            {
            [printModal presentFromBarButtonItem:[[self navigationItem] rightBarButtonItem] animated:YES completionHandler:
#ifdef DEBUG
             ^(UIPrintInteractionController *printInteractionController, BOOL completed, NSError *error) {
                 if (!completed)
                     {
                     NSLog(@"A_BMLTSearchResultsViewController::printView completionHandler: Print FAIL");
                     }
                 else
                     {
                     NSLog(@"A_BMLTSearchResultsViewController::printView completionHandler: Print WIN");
                     }
             }
#else
             nil
#endif
             ];
            }
        else
            {
            [printModal presentAnimated:YES completionHandler:
#ifdef DEBUG
            ^(UIPrintInteractionController *printInteractionController, BOOL completed, NSError *error) {
                if (!completed)
                    {
                    NSLog(@"BMLTMeetingDetailViewController::printView completionHandler: Print FAIL");
                    }
                else
                    {
                    NSLog(@"BMLTMeetingDetailViewController::printView completionHandler: Print WIN");
                    }
            }
#else
            nil
#endif
            ];
            }
        }
}

/**************************************************************//**
 \brief This is called when the "Clear Search" button is pressed.
 *****************************************************************/
- (IBAction)clearSearch:(id)sender
{
    [[BMLTAppDelegate getBMLTAppDelegate] clearAllSearchResultsYes];
}

@end
