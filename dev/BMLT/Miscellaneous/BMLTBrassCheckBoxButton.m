//
//  BrassCheckBox.m
//  BMLT
//
//  Created by MAGSHARE.
//  Copyright 2012 MAGSHARE. All rights reserved.
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
/**************************************************************//**
                                                                 \file BrassCheckBox.m
                                                                 \brief This class extends the standard UIButton class, to implement
                                                                 a boolean checkbox that displays an image that simulates a
                                                                 "steampunk"-style "brass" button that displays on/off states
                                                                 and implements a "toggle" behavior. It can also display a clear
                                                                 "disabled" state, in which it is unresponsive to user input.
                                                                 *****************************************************************/

#import "BMLTBrassCheckBoxButton.h"

/**************************************************************//**
                                                                 \class BrassCheckBox
                                                                 \brief This implements a special "checkbox" interface element.
                                                                 *****************************************************************/
@implementation BMLTBrassCheckBoxButton

/**************************************************************//**
                                                                 \brief Overload of the inherited initWith Frame, to read in the image.
                                                                 \returns self
                                                                 *****************************************************************/
- (id)initWithFrame:(CGRect)frame   ///< The display frame.
{
    self = [super initWithFrame:frame];
    if (self)
        {
        [self setIsOn:NO];
        // We need to catch this selector, so we can toggle the state.
        [self addTarget:self action:@selector(buttonClickedInside:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *logoImage = [UIImage imageNamed:@"CheckBoxNormal.png"];
        CGSize  imageSize = [logoImage size];
        [self setBounds:CGRectMake(0, 0, imageSize.width, imageSize.height)];
        }
    
    return self;
}

/**************************************************************//**
                                                                 \brief Overload of the initWithCoder, so that the selector can be caught.
                                                                 \returns self
                                                                 *****************************************************************/
- (id)initWithCoder:(NSCoder *)decoder  ///< The decoder that contains the button state.
{
    self = [super initWithCoder:decoder];
    if (self)
        {
        [self setIsOn:NO];
        // We need to catch this selector, so we can toggle the state.
        [self addTarget:self action:@selector(buttonClickedInside:) forControlEvents:UIControlEventTouchUpInside];
        }
    
    return self;
}

/**************************************************************//**
                                                                 \brief Accessor -Is Dis Ting ON?
                                                                 \returns YES, if the state is ON. NO, if OFF.
                                                                 *****************************************************************/
- (BOOL)isOn
{
    return isOn;
}

/**************************************************************//**
                                                                 \brief Set the state.
                                                                 *****************************************************************/
- (void)setIsOn:(BOOL)inIsOn    ///< YES, if the state is to be ON.
{
    BOOL    oldIsOn = isOn;
    isOn = inIsOn;
    
    // Green check means ON
    if ( [self isOn] )
        {
        [self setBackgroundImage:[UIImage imageNamed:@"CheckBoxNormal-Check.png"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"CheckBoxHighlight-Check.png"] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageNamed:@"CheckBoxDisabled-Check.png"] forState:UIControlStateDisabled];
        }
    else
        {
        [self setBackgroundImage:[UIImage imageNamed:@"CheckBoxNormal.png"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"CheckBoxHighlight.png"] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageNamed:@"CheckBoxDisabled.png"] forState:UIControlStateDisabled];
        }
    
    if ( oldIsOn != isOn )  // Spread the word.
        {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
}

/**************************************************************//**
                                                                 \brief Toggles the state.
                                                                 *****************************************************************/
- (BOOL)toggleState
{
    [self setIsOn:![self isOn]];
    
    return isOn;
}

/**************************************************************//**
                                                                 \brief This is a responder. It toggles if the user clicked inside.
                                                                 *****************************************************************/
- (void)buttonClickedInside:(id)sender  ///< The Control event sender.
{
    [self toggleState];
}
@end
