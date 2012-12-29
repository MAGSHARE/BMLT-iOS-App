//
//  BMLT_AnimationView.m
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

#import "BMLT_AnimationView.h"
#import <QuartzCore/QuartzCore.h>

// Conversion from degrees to radians.
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

@interface BMLT_AnimationView ()
{
    UIImageView *_transparencyImage;
}
@end;

@implementation BMLT_AnimationView
/***************************************************************\**
 \brief This simply sets a very simple animation, in which a "radar" screen
        is displayed over a map of Australia.
 \returns self
 *****************************************************************/
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if ( self )
        {
        UIImageView *bottomLayerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Anim-Back.png"]];
        [bottomLayerImage setFrame:[self bounds]];
        [self addSubview:bottomLayerImage];
        
        _transparencyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Anim-Transparency.png"]];
        [_transparencyImage setFrame:[self bounds]];
        CABasicAnimation    *fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        [fullRotation setFromValue:[NSNumber numberWithFloat:0]];
        [fullRotation setToValue:[NSNumber numberWithFloat:((360*M_PI)/180)]];
        [fullRotation setDuration:3.5f];
        [fullRotation setRepeatCount:MAXFLOAT];
        
        [[_transparencyImage layer] addAnimation:fullRotation
                                          forKey:@"360"];
        
        [self addSubview:_transparencyImage];
        }
    
    return self;
}

/***************************************************************\**
 \brief This starts the animation.
 *****************************************************************/
- (void)startAnimating
{
    [_transparencyImage startAnimating];
}

/***************************************************************\**
 \brief This stops the animation.
 *****************************************************************/
- (void)stopAnimating
{
    [_transparencyImage stopAnimating];
}
@end
