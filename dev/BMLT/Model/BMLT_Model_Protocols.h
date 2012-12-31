//
//  BMLT_Model_Protocols.h
//  BMLT
//
//  Created by MAGSHARE
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

#import <Foundation/Foundation.h>

@class BMLT_Server, BMLT_Driver;

/*****************************************************************/
/**
 \class BMLT_ParentProtocol
 \brief Makes the classes derived provide a "get my children" accessor.
 *****************************************************************/
@protocol BMLT_ParentProtocol
- (NSArray *)getChildObjects;
@end

/*****************************************************************/
/**
 \class BMLT_NameDescProtocol
 \brief Makes the classes derived provide a name and description.
 *****************************************************************/
@protocol BMLT_NameDescProtocol
- (void)setBMLTName:(NSString *)inName;
- (void)setBMLTDescription:(NSString *)inDescription;
- (NSString *)getBMLTName;
- (NSString *)getBMLTDescription;
@end

/*****************************************************************/
/**
 \class BMLT_ServerDelegateProtocol
 \brief Classes like meetings and formats get callbacks while parsing.
 *****************************************************************/
@protocol BMLT_ServerDelegateProtocol
- (void)serverLockedAndLoaded:(BMLT_Server *)inServer;
- (void)serverFAIL:(BMLT_Server *)inServer;
@end

/*****************************************************************/
/**
 \class BMLT_DriverDelegateProtocol
 \brief Classes like servers get callbacks while parsing.
 *****************************************************************/
@protocol BMLT_DriverDelegateProtocol
- (void)driverFAIL:(BMLT_Driver *)inDriver;
@end
