//
//  BMLT_Model_Protocols.h
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

#import <Foundation/Foundation.h>

@class BMLT_Server;

@protocol BMLT_ParentProtocol
- (NSArray *)getChildObjects;
@end

@protocol BMLT_NameDescProtocol
- (void)setBMLTName:(NSString *)inName;
- (void)setBMLTDescription:(NSString *)inDescription;
- (NSString *)getBMLTName;
- (NSString *)getBMLTDescription;
@end

@protocol BMLT_ServerDelegateProtocol
- (void)serverLockedAndLoaded:(BMLT_Server *)inServer;
- (void)serverFAIL:(BMLT_Server *)inServer;
@end
