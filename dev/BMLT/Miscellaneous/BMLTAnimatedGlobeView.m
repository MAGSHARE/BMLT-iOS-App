//
//  BMLTBlueView.m
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

#import "BMLTAnimatedGlobeView.h"

/***************************************************************\**
 \class BMLTBlueView    -Private Interface
 \brief This class will simply apply a blue textured background to a view.
 It will also allow display of an animated spinning globe.
 *****************************************************************/
@interface BMLTAnimatedGlobeView ()
{
    Animated_BMLT_Logo  *animatedImage;
}
@end

/***************************************************************\**
 \class BMLTBlueView    -Implementation
 \brief This class will simply apply a blue textured background to a view.
        It will also allow display of an animated spinning globe.
 *****************************************************************/
@implementation BMLTAnimatedGlobeView

/***************************************************************\**
 \brief  Set the view backgound to the blue leather pattern color.
 \returns   self
 *****************************************************************/
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
        {
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BlueBackgroundPat.gif"]]];
        }
    return self;
}

/***************************************************************\**
 \brief This routine covers the center of the view with an animation.
 *****************************************************************/
- (void)startAnimation
{
    if ( !animatedImage )
        {
#ifdef DEBUG
        NSLog(@"BMLTBlueView startAnimation creating animation.");
#endif
        animatedImage = [[Animated_BMLT_Logo alloc] init];
        CGRect  myBounds = [self bounds];
        CGRect  animFrame = CGRectZero;
        
        animFrame.size.width = animFrame.size.height = 200;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            {
            animFrame.size.width = animFrame.size.height = 300;
            }
        
        double  newX = (myBounds.size.width - animFrame.size.width) / 2.0;
        double  newY = (myBounds.size.height - animFrame.size.height) / 2.0;
        
        animFrame.origin.x = newX;
        animFrame.origin.y = newY;
        
        animFrame = CGRectOffset ( animFrame, (animFrame.size.width / 36), (animFrame.size.width / 18) );
        
        [animatedImage setFrame:animFrame];
        
        [self addSubview:animatedImage];
        [animatedImage startTurning];
        }
}

/***************************************************************\**
 \brief This routine stops the animation.
 *****************************************************************/
- (void)stopAnimation
{
    if ( animatedImage )
        {
#ifdef DEBUG
        NSLog(@"BMLTBlueView stopAnimation stopping animation.");
#endif
        [animatedImage removeFromSuperview];
        animatedImage = nil;
        }
}
@end
