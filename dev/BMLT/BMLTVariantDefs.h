//
//  BMLTVariantDefs.h
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

#import <UIKit/UIKit.h>

#ifndef _VARIANT_DEFS_  // This kludge just keeps the compiler from yelling at us for duplicating the class definition (because this is in the precompiled header).
#define _VARIANT_DEFS_ 1

@class CLLocation;

/**************************************************************//**
 \class  BMLTVariantDefs
 \brief  This class will be a static class that provides various
         definitions and macros for use by each variant.
 *****************************************************************/
@interface BMLTVariantDefs : NSObject
{

}

/**************************************************************//**
 \brief     This returns the color (or texture) to use for the main window background.
 \returns   The color to be used.
 *****************************************************************/
+ (UIColor *)windowBackgroundColor;

/**************************************************************//**
 \brief     This returns the color to be used as the background for the search windows.
 \returns   The color to be used.
 *****************************************************************/
+ (UIColor *)searchBackgroundColor;

/**************************************************************//**
 \brief     This returns the color to be used as the main view background for the list results (seldom seen).
 \returns   The color to be used.
 *****************************************************************/
+ (UIColor *)listResultsBackgroundColor;

/**************************************************************//**
 \brief     This returns the color to be used as the main view background for the map results (seldom seen).
 \returns   The color to be used.
 *****************************************************************/
+ (UIColor *)mapResultsBackgroundColor;

/**************************************************************//**
 \brief     This returns the color to be used as the view background for the single meeting details page.
 \returns   The color to be used.
 *****************************************************************/
+ (UIColor *)meetingDetailBackgroundColor;

/**************************************************************//**
 \brief     This is the background to be used for iPhone modal dialogs.
 \returns   The color to be used.
 *****************************************************************/
+ (UIColor *)modalBackgroundColor;

/**************************************************************//**
 \brief    This is the background for popover windows on the iPad
 \returns  The color to be used. 
 *****************************************************************/
+ (UIColor *)popoverBackgroundColor;

/**************************************************************//**
 \brief     This is the background for the Settings screen.
 \returns   The color to be used.
 *****************************************************************/
+ (UIColor *)settingsBackgroundColor;

/**************************************************************//**
 \brief     This is the background for odd rows in the list results.
 \returns   The color to be used.
 *****************************************************************/
+ (UIColor *)getSortOddColor;

/**************************************************************//**
 \brief     This is the background for even rows in the list results.
 \returns   The color to be used.
 *****************************************************************/
+ (UIColor *)getSortEvenColor;

/**************************************************************//**
 \brief     Returns the root server URI for this variant.
 \returns   The URI of the Root Server.
 *****************************************************************/
+ (NSURL *)rootServerURI;

/**************************************************************//**
 \brief     Returns the URI for Web-based directions to the given
            location (long/lat) from the given location.
 \returns   The URI of the directins call.
 *****************************************************************/
+ (NSURL *)directionsURITo:(CLLocation *)inTo from:(CLLocation *)inFrom;

@end
#endif
