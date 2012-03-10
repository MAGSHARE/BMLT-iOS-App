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

@implementation BMLT_Results_MapPointAnnotationView
/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (id)initWithAnnotation:(id<MKAnnotation>)annotation
         reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if ( self )
        {
        [self selectImage];
        [self setCenterOffset:CGPointMake(-8, -20)];
        }
    
    return self;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)selectImage
{
    if ( [[self annotation] isKindOfClass:[BMLT_Results_MapPointAnnotation class]] )
        {
        BOOL    isMulti = [(BMLT_Results_MapPointAnnotation *)[self annotation] getNumberOfMeetings] > 1;
        
        [self setImage:[UIImage imageNamed:(isMulti ? @"MapMarkerRed.png" : @"MapMarkerBlue.png")]];
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)drawRect:(CGRect)rect
{
    [self selectImage];
    [super drawRect:rect];
}

@end

@implementation BMLT_Results_BlackAnnotationView

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)selectImage
{
    [self setImage:[UIImage imageNamed:@"MapMarkerBlack.png"]];
}
@end

@implementation BMLT_Results_MapPointAnnotation

@synthesize coordinate, title, subtitle;

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (id)initWithCoordinate:(CLLocationCoordinate2D)coords
             andMeetings:(NSArray *)inMeetings
{
    self = [super init];
    
    if (self)
        {
        coordinate = coords;
        myMeetings = [[NSMutableArray alloc] initWithArray:inMeetings];
        }
    
    return self;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setIsSelected:(BOOL)inSelected
{
    isSelected = inSelected;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (BOOL)isSelected
{
    return isSelected;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)dealloc
{
    [title release];
    [subtitle release];
    [myMeetings release];
    [super dealloc];
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (NSInteger)getNumberOfMeetings
{
    if ( [self getMyMeetings] )
        {
        return [[self getMyMeetings] count];
        }
    
    return 0;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (BMLT_Meeting *)getMeetingAtIndex:(NSInteger)index
{
    return [[self getMyMeetings] objectAtIndex:index];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)addMeeting:(BMLT_Meeting *)inMeeting
{
    if ( !myMeetings )
        {
        myMeetings = [[NSMutableArray alloc] init];
        }
    
    [myMeetings addObject:inMeeting];
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (NSArray *)getMyMeetings
{
    return myMeetings;
}

@end

