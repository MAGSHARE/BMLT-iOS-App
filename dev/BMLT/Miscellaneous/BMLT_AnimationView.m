//
//  Animated_BMLT_Logo.m
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

static int kBMLT_Animation_frame_count = 30; ///< This is how many frames we have to display.

@interface BMLT_AnimationView ()
{
    NSMutableArray      *imageArray;
    UIImageView         *bottomLayerImage;
    UIImageView         *topLayerImage;
    UIImageView         *animatedImages;
    double              center_ratio;
}
@end;

@implementation BMLT_AnimationView
/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if ( self )
        {
        imageArray = [[NSMutableArray alloc] init];
        
        // Build array of images, cycling through image names.
        // We intercept the first one, to get its size.
        UIImage *theImage = [UIImage imageNamed:@"Globe_00.png"];
        CGSize  centerSize = [theImage size];
        
        [imageArray addObject:theImage];
        
        for (int i = 1; i < kBMLT_Animation_frame_count; i++ )
            {
            [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Globe_%02d.png", i]]];
            }
        
        theImage = [UIImage imageNamed:@"BottomLayer.png"];
        CGSize  bottomSize = [theImage size];
        bottomLayerImage = [[UIImageView alloc] initWithImage:theImage];
        
        theImage = [UIImage imageNamed:@"TopLayer.png"];
        topLayerImage = [[UIImageView alloc] initWithImage:theImage];
        
        center_ratio = centerSize.width / bottomSize.width;
        
        CGRect imageFrame = [bottomLayerImage bounds];
                
        [bottomLayerImage setFrame:imageFrame];
        [topLayerImage setFrame:imageFrame];
        [self setBounds:imageFrame];
        
        imageFrame.size.width *= center_ratio;
        imageFrame.size.height *= center_ratio;
        imageFrame.origin.x = (bottomSize.width - centerSize.width) / 2 - (bottomSize.width / 44.0);    // The 44 is because of the drop shadow. The center needs to be offset 1/44th up and left.
        imageFrame.origin.y = (bottomSize.height - centerSize.height) / 2 - (bottomSize.height / 44.0);
        
        animatedImages = [[UIImageView alloc] initWithFrame:imageFrame];
        [animatedImages setAnimationImages:imageArray];
        
        animatedImages.animationDuration = 1.5;
        animatedImages.animationRepeatCount = 0;
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:bottomLayerImage];
        [self addSubview:animatedImages];
        [self addSubview:topLayerImage];
        [animatedImages startAnimating];
        }
    
    return self;
}

/***************************************************************\**
 \brief This starts the animation.
 *****************************************************************/
- (void)startAnimating
{
}

/***************************************************************\**
 \brief This stops the animation.
 *****************************************************************/
- (void)stopAnimating
{
}
@end
