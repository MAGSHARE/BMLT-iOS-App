//
//  BMLTMeetingDetailViewController.h
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

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BMLTActionButtonViewController.h"

@class BMLT_Meeting;
@class BMLT_Results_MapPointAnnotation;

#define List_Meeting_Format_Circle_Size_Big 30

@interface BMLTMeetingDetailViewController : UIViewController <MKMapViewDelegate, UIPopoverControllerDelegate, BMLTCloseModalProtocol>
{
    BMLTActionButtonViewController  *actionModal;
    UIPopoverController             *actionPopover;
}
@property (weak, nonatomic, readwrite)  UIViewController    *myModalController;
@property (weak, nonatomic, readwrite)  BMLT_Meeting        *myMeeting;
@property (weak, nonatomic) IBOutlet    MKMapView           *meetingMapView;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UITextView *commentsTextView;
@property (weak, nonatomic) IBOutlet UITextView *frequencyTextView;
@property (weak, nonatomic) IBOutlet UIView *formatsContainerView;
@property (weak, nonatomic) IBOutlet UIButton *selectSatelliteButton;
@property (weak, nonatomic) IBOutlet UIButton *selectMapButton;

- (void)setFormats;
- (void)setMeetingFrequencyText;
- (void)setMeetingCommentsText;
- (void)setMeetingLocationText;
- (void)setMapLocation;
- (void)actionItemPressed;
- (void)closeModal;

- (IBAction)callForDirections:(id)sender;
- (IBAction)selectMapView:(id)sender;
- (IBAction)selectSatelliteView:(id)sender;

@end
