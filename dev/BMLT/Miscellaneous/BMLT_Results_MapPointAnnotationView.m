//
//  BMLT_Results_MapPointAnnotationView.m
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

#import "BMLT_Results_MapPointAnnotationView.h"

/**************************************************************//**
 \class BMLT_Results_MapPointAnnotationView
 \brief This is the base class for the standard meetings pins.
 *****************************************************************/
@implementation BMLT_Results_MapPointAnnotationView
/**************************************************************//**
 \brief Initializes the annotation in the standard MapKiot manner.
 \returns self
 *****************************************************************/
- (id)initWithAnnotation:(id<MKAnnotation>)annotation
         reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if ( self )
        {
        [self setCenterOffset:CGPointMake(kRegularAnnotationOffsetRight, -kRegularAnnotationOffsetUp)];
        [self selectImage];
        }
    
    return self;
}

/**************************************************************//**
 \brief This tells the annotation to figure out which image it will use.
        In this class, it will choose a blue marker for just one
        meeting, or go all Neo with a red one, for multiple meetings.
 *****************************************************************/
- (void)selectImage
{
    if ( [[self annotation] isKindOfClass:[BMLT_Results_MapPointAnnotation class]] )
        {
        BOOL    isMulti = [(BMLT_Results_MapPointAnnotation *)[self annotation] getNumberOfMeetings] > 1;
        BOOL    isSelected = [(BMLT_Results_MapPointAnnotation *)[self annotation] isSelected]; 
        [self setImage:[UIImage imageNamed:(isSelected ? @"MapMarkerGreen.png" : isMulti ? @"MapMarkerRed.png" : @"MapMarkerBlue.png")]];
        [self setNeedsDisplay];
        }
}

@end

/**************************************************************//**
 \class BMLT_Results_BlackAnnotationView
 \brief This class replaces the red/blue choice with a black marker,
        representing the user's location. It will have a popup title.
 *****************************************************************/
@implementation BMLT_Results_BlackAnnotationView

/**************************************************************//**
 \brief We choose black.
 *****************************************************************/
- (void)selectImage
{
    [self setImage:[UIImage imageNamed:@"MapMarkerBlack.png"]];
}

@end

/**************************************************************//**
 \class BMLT_Results_MapPointAnnotation
 \brief This is the annotation controller class that we use to manage
        the markers.
 *****************************************************************/
@implementation BMLT_Results_MapPointAnnotation

@synthesize isSelected = _selected, coordinate = _coordinate, title, subtitle;

/**************************************************************//**
 \brief Initialize with a coordinate, and a list of meetings.
 \returns self.
 *****************************************************************/
- (id)initWithCoordinate:(CLLocationCoordinate2D)coords ///< The coordinates of this marker.
             andMeetings:(NSArray *)inMeetings          ///< A list of BMLT_Meeting objects, represented by this marker (it may be 1 meeting).
{
    self = [super init];
    
    if (self)
        {
        _coordinate = coords;
        myMeetings = [[NSMutableArray alloc] initWithArray:inMeetings];
        }
    
    return self;
}

/**************************************************************//**
 \brief Sets the selected property, and triggers a redraw.
 *****************************************************************/
- (void)setIsSelected:(BOOL)isSelected
{
    _selected = isSelected;
}

/**************************************************************//**
 \brief Returns the number of meetings represented by this marker.
 \returns an integer. The number of meetings represented by the marker.
 *****************************************************************/
- (NSInteger)getNumberOfMeetings
{
    if ( [self getMyMeetings] )
        {
        return [[self getMyMeetings] count];
        }
    
    return 0;
}

/**************************************************************//**
 \brief Gets a particular meeting from a list.
 \returns a BMLT_Meeting object for the selected meeting.
 *****************************************************************/
- (BMLT_Meeting *)getMeetingAtIndex:(NSInteger)index    ///< The index of the desired meeting.
{
    return [[self getMyMeetings] objectAtIndex:index];
}

/**************************************************************//**
 \brief Adds a meeting to the list.
 *****************************************************************/
- (void)addMeeting:(BMLT_Meeting *)inMeeting    ///< The meeting object to be added.
{
    if ( !myMeetings )
        {
        myMeetings = [[NSMutableArray alloc] init];
        }
    
    [myMeetings addObject:inMeeting];
}

/**************************************************************//**
 \brief Get the raw list of meetings.
 \returns an array of BMLT_Meeting objects.
 *****************************************************************/
- (NSArray *)getMyMeetings
{
    return myMeetings;
}

@end

