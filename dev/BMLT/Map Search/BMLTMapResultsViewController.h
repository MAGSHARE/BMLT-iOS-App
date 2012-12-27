//
//  BMLTMapResultsViewController.h
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

#import <UIKit/UIKit.h>
#import "A_BMLTSearchResultsViewController.h"
#import <MapKit/MapKit.h>

@class BMLT_Meeting;

/**************************************************************//**
 \class  BMLTMapResultsViewController
 \brief  This class will control display of mapped results.
 *****************************************************************/
@interface BMLTMapResultsViewController : A_BMLTSearchResultsViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView  *myMapView;

- (void)setMapInit:(BOOL)isInit;
- (BOOL)isMapInitialized;
- (void)viewMeetingList:(NSArray *)inList atRect:(CGRect)selectRect inView:(UIView *)inContext;
- (void)dismissListPopover;
- (void)clearLastRegion;
- (void)clearMapCompletely;
- (void)displayMapAnnotations:(NSArray *)inResults;
- (NSArray *)mapMeetingAnnotations:(NSArray *)inResults;
- (void)determineMapSize:(NSArray *)inResults;
- (void)displayAllMarkersIfNeeded;
- (IBAction)toggleMapView:(id)sender;

@end
