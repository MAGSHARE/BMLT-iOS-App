//
//  BMLTGetInfoLabel.m
//  BMLT
//
//  Created by Chris Marshall on 4/19/12.
//  Copyright (c) 2012 Nikon Inc. All rights reserved.
//

#import "BMLTBundleResourceLabel.h"

/**************************************************************//**
 \class BMLTGetInfoLabel
 \brief This class implements a label that displays the Get Info String.
        This allows a transparent name display that can be easily
        formatted.
 *****************************************************************/
@implementation BMLTBundleResourceLabel

/**************************************************************//**
 \brief Initializer -Grabs the string, and sets it as the display.
 \returns self
 *****************************************************************/
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        {
        NSString    *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        NSString    *appInfo = [[NSDictionary dictionaryWithContentsOfFile:plistPath] valueForKey:[self text]];
        [self setText:appInfo];
        }
    return self;
}
@end