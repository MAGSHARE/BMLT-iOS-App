//
//  BMLT_Results_MapPointAnnotationView.h
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
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

extern int kRegularAnnotationOffsetRight;   /**< This is how many pixels to shift the annotation view right. */
@class BMLT_Meeting;

/*****************************************************************/
/**
 \class BMLT_Results_MapPointAnnotationView
 \brief We add a a red or blue marker to the annotation. Each marker
        can trigger a handler.
 *****************************************************************/
@interface BMLT_Results_MapPointAnnotationView : MKAnnotationView
- (void)selectImage;
@end

/*****************************************************************/
/**
 \class BMLT_Results_MapPointAnnotationView
 \brief We make the annotation a black marker with a simple callout.
 *****************************************************************/
@interface BMLT_Results_BlackAnnotationView : BMLT_Results_MapPointAnnotationView
@end

/*****************************************************************/
/**
 \class BMLT_Results_MapPointAnnotation
 \brief Handles annotations in the results map.
 *****************************************************************/
@interface BMLT_Results_MapPointAnnotation : NSObject <MKAnnotation>
{
    NSString        *title;
    NSString        *subtitle;
    NSInteger       displayIndex;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coords andMeetings:(NSArray *)inMeetings andIndex:(NSInteger)inIndex;

@property (nonatomic, readwrite, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite, copy) NSString                 *title;
@property (nonatomic, readwrite, copy) NSString                 *subtitle;
@property (nonatomic, readwrite) BOOL                           isSelected;
@property (nonatomic, readwrite) NSInteger                      displayIndex;
@property (retain, nonatomic)   NSMutableArray                  *myMeetings;

- (NSArray *)getMyMeetings;
- (NSInteger)getNumberOfMeetings;
- (BMLT_Meeting *)getMeetingAtIndex:(NSInteger)index;
- (void)addMeeting:(BMLT_Meeting *)inMeeting;
@end
