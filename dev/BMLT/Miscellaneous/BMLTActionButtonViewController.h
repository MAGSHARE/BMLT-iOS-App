//
//  BMLTActionButtonViewController.h
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

#import <UIKit/UIKit.h>

@class BMLT_Meeting;
@class MKMapView;

/**************************************************************//**
 \class BMLTCloseModalProtocol
 \brief Simply ensures that the classes will have a proper "closeModal" method.
 *****************************************************************/
@protocol BMLTCloseModalProtocol
    - (void)closeModal;
@end

/**************************************************************//**
 \class BMLTActionButtonViewController
 \brief This implements the popver (iPad) or modal dialog (iPhone)
        that allows a user to create a PDF and send by email, or
        print the search/meeting details.
 *****************************************************************/
@interface BMLTActionButtonViewController : UIViewController
{
    IBOutlet UINavigationBar    *navBar;    ///< This is our navbar item.
}
    @property (weak, nonatomic) BMLT_Meeting        *singleMeeting; ///< This is set to a meeting object, if this is for a meeting details page.
    @property (weak, nonatomic) IBOutlet UIButton   *emailButton;   ///< If the user presses this button, they will email a PDF
    @property (weak, nonatomic) IBOutlet UIButton   *printButton;   ///< If the user presses this button, they will print the current view.
    @property (weak, nonatomic) IBOutlet UIView     *containerView; ///< This is a container, used to "size" the dialog for a popover.
    @property (weak, nonatomic, readwrite) UIViewController<BMLTCloseModalProtocol>    *myModalController;  ///< This will hold our modal controller (where we can send "close me" messages.
    @property (weak, nonatomic, readwrite) MKMapView *myMapView;    ///< This will be used for drawing the maps in the PDFs.

    - (void)drawPrintableSearchMap;
    - (void)drawPrintableSearchList;
    - (void)drawPrintableMeetingDetails;

    - (void)displayMapAnnotations:(NSArray *)inResults;
    - (NSArray *)mapMeetingAnnotations:(NSArray *)inResults;
    - (void)determineMapSize:(NSArray *)inResults;

    - (IBAction)doneButtonPressed:(id)sender;
    - (IBAction)emailPDFPressed:(id)sender;
    - (IBAction)printButtonPressed:(id)sender;
@end
