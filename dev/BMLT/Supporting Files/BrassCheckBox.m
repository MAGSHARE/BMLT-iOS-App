//
//  BrassCheckBox.m
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

#import "BrassCheckBox.h"

@implementation BrassCheckBox

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
        {
        [self setIsOn:NO];
        [self addTarget:self action:@selector(buttonClickedInside:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *logoImage = [UIImage imageNamed:@"Convex.png"];
        CGSize  imageSize = [logoImage size]; 
        [self setBounds:CGRectMake(0, 0, imageSize.width, imageSize.height)];
        }
    
    return self;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self)
        {
        [self setIsOn:NO];
        [self addTarget:self action:@selector(buttonClickedInside:) forControlEvents:UIControlEventTouchUpInside];
        }
    
    return self;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (BOOL)isOn
{
    return isOn;
}
    
/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setIsOn:(BOOL)inIsOn
{
    BOOL    oldIsOn = isOn;
    isOn = inIsOn;
    
    if ( [self isOn] )
        {
        [self setBackgroundImage:[UIImage imageNamed:@"GreenCheck.png"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"GreenCheckConcave.png"] forState:UIControlStateHighlighted];
        }
    else
        {
        [self setBackgroundImage:[UIImage imageNamed:@"Convex.png"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"Concave.png"] forState:UIControlStateHighlighted];
        }
    
    [self setBackgroundImage:[UIImage imageNamed:@"RedXConcave.png"] forState:UIControlStateDisabled];

    if ( oldIsOn != isOn )
        {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (BOOL)toggleState
{
    [self setIsOn:![self isOn]];
    
    return isOn;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)buttonClickedInside:(id)sender
{
    [self toggleState];
}
@end
