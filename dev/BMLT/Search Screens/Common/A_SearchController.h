//
//  A_SearchController.h
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
#import "SearchDelegate.h"
#import "Animated_BMLT_Logo.h"
#import "FormatDetailView.h"
#import <CoreLocation/CoreLocation.h>

/**
 This represents a semaphore.
 */
typedef struct SearchQueueElement_struct
{
    NSDictionary        *params;
    NSString            *locationText;
    BOOL                findLocationFirst;
    BOOL                startSearch;
} SearchQueueElement, *SearchQueueElementPtr;

@class SpecifyNewSearchViewController;
@class BMLT_Meeting;

/***************************************************************\**
 \class BeanieButton
 \brief This class implements the main "search button" UIView.
 *****************************************************************/
@interface BeanieButton : UIButton
{
}
- (id)initAsList:(BOOL)inIsList;
@end

/***************************************************************\**
 \class A_SearchController
 \brief This is the main base UIViewController class for the searches.
        This class is meant to be an abstract class, with concrete
        and focused implementations.
 *****************************************************************/
@interface A_SearchController : UIViewController <SearchDelegate, UIPopoverControllerDelegate>
{
    NSArray                             *displayedMeetings;
    Animated_BMLT_Logo                  *animatedImage;
    SpecifyNewSearchViewController      *mySearchSetup;
    FormatDetailView                    *myModalView;
    UIPopoverController                 *formatPopover;
    UIButton                            *mainButton;
    SearchQueueElement                  myQueue;
}

- (void)setSearchResults:(NSArray *)inResults;
- (NSArray *)getSearchResults;
- (void)setVisualElementsForSearch;
- (void)checkForSearch;
- (void)initSearchQueue;
- (void)setMySearchQueueParams:(NSDictionary *)inParams;
- (void)setMySearchQueueLocationString:(NSString *)inString;
- (void)setMySearchQueueFindLocationFirst:(BOOL)inFindLocation;
- (void)setMySearchQueueStartSearch:(BOOL)inStart;
- (SearchQueueElement *)getMySearchQueue;
- (NSDictionary *)getMySearchQueueParams;
- (NSString *)getMySearchQueueLocationString;
- (BOOL)getMySearchQueueFindLocationFirst;
- (BOOL)getMySearchQueueStartSearch;
- (void)setMySearchSetup:(SpecifyNewSearchViewController *)inSetup;
- (void)setBlueBackground;
- (void)startAnimation;
- (void)stopAnimation;
- (void)displayFormatDetail:(id)inSender;
- (void)setBarButton:(BOOL)show;
- (void)enableCenterButton:(BOOL)isEnabled;
- (void)closeModal;
- (void)viewMeetingDetails:(BMLT_Meeting *)inMeeting;
- (void)viewMeetingList:(NSArray *)inList;
- (void)beanieButtonHit:(id)sender;
- (void)specifyNewSearch:(id)sender;
- (void)findLocation;
- (void)searchAtLocation:(CLLocationCoordinate2D)inCoords;
- (void)displaySearchResults:(NSArray *)inResults;
- (void)displaySearchError:(NSError *)inError;
- (void)clearSearch;
- (void)clearSearchResults;
- (void)newSearch;
- (IBAction)swipeBack:(UIGestureRecognizer *)sender;
@end
