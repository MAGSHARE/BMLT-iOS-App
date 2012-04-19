//
//  BMLTGetInfoLabel.m
//  BMLT
//
//  Created by Chris Marshall on 4/19/12.
//  Copyright (c) 2012 Nikon Inc. All rights reserved.
//

#import "BMLTGetInfoLabel.h"

/**************************************************************//**
 \class BMLTGetInfoLabel
 \brief This class implements a label that displays the Get Info String.
        This allows a transparent name display that can be easily
        formatted.
 *****************************************************************/
@implementation BMLTGetInfoLabel

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
        NSString    *appInfo = [[NSDictionary dictionaryWithContentsOfFile:plistPath] valueForKey:@"CFBundleGetInfoString"];
        [self setText:appInfo];
        }
    return self;
}
@end