//
//  Animated_BMLT_Logo.m
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
/***************************************************************\**
 \file Animated_BMLT_Logo.m
 \brief This UIView implements an animated "steampunk spinning globe."
 *****************************************************************/

#import "Animated_BMLT_Logo.h"
#import <QuartzCore/QuartzCore.h>

/***************************************************************\**
 \class Animated_BMLT_Logo
 \brief This UIView implements an animated "steampunk spinning globe."
 *****************************************************************/
@implementation Animated_BMLT_Logo
/***************************************************************\**
 \brief Initializer -Sets up the image array of the globe contents.
 \returns self
 *****************************************************************/
- (id)init
{
    self = [super init];
    
    if ( self )
        {
        imageArray = [[NSMutableArray alloc] init];
            
        // Build array of images, cycling through image names.
        // The images are actually in reverse order, so we go through it backwards.
        for (int i = AnimatedGlobeViewController_image_frame_count; i > 0;)
            {
            [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Globe_%02d.png", --i]]];
            }
        
            // We use 3 layers. The bottom is the "base" of the "compass," including the blue background and the "brass" ring.
            // The middle is the spinning globe.
            // The top layer is the band around the globe, the compass face and the "wooden" rim.
        bottomLayerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BottomLayer.png"]];
        
        topLayerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TopLayer.png"]];
        
        CGRect imageFrame = [bottomLayerImage bounds];
                
        [bottomLayerImage setFrame:imageFrame];
        [topLayerImage setFrame:imageFrame];
        
            // We use the built-in animation handler to show the animation.
        animatedImages = [[UIImageView alloc] initWithFrame:imageFrame];
        [animatedImages setAnimationImages:imageArray];
        
        animatedImages.animationDuration = 2.0;
        animatedImages.animationRepeatCount = 0;
        
        [self addSubview:bottomLayerImage];
        [self addSubview:animatedImages];
        [self addSubview:topLayerImage];
        [self setBounds:imageFrame];
        }
    
    return self;
}

/***************************************************************\**
 \brief Here is the responder, where we lay out the view layers.
 *****************************************************************/
- (void)layoutSubviews
{
    CGRect  myBounds = [self bounds];
    CGRect  globeBounds = myBounds;
    
    double mySize = myBounds.size.height = myBounds.size.width;
    
    // The globe is about half the size of the frame.
    globeBounds = CGRectInset ( globeBounds, (mySize / 3.8), (mySize / 3.8) );
    // Because of the drop shadow, the center is 1/44th off.
    globeBounds = CGRectOffset ( globeBounds, -(mySize / 44), -(mySize / 44) );
    
    [bottomLayerImage setFrame:myBounds];
    [topLayerImage setFrame:myBounds];
    [animatedImages setFrame:globeBounds];
}

/***************************************************************\**
 \brief Call this to start the world turning.
 *****************************************************************/
- (void)startTurning
{
    [animatedImages startAnimating];
}

/***************************************************************\**
 \brief Call this to stop the world turning.
 *****************************************************************/
- (void)stopTurning
{
    [animatedImages stopAnimating];
}
@end
