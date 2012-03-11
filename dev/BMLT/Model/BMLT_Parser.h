//
//  BMLT_Parser.h
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
#import "BMLT_Server.h"

@interface BMLT_Parser : NSXMLParser <NSXMLParserDelegate>
{
    BMLT_Server                     *myServer;
    NSObject                        *currentElement;
    NSObject<NSXMLParserDelegate>   *myFirstDelegate;
    NSObject<NSXMLParserDelegate>   *myCurrentDelegate;
}
- (void)setCurrentElement:(NSObject *)inObject;
- (void)setMyServer:(BMLT_Server *)inServerObject;
- (BMLT_Server *)getMyServer;
- (NSObject<NSXMLParserDelegate> *)getMyFirstDelegate;
- (void)setBMLTDelegate:(NSObject<NSXMLParserDelegate> *)inDelegate;
- (void)cancelTimeout;
- (void)timeoutHandler;
- (void)parseAsync:(BOOL)isAsync WithTimeout:(int)inSeconds;
@end
