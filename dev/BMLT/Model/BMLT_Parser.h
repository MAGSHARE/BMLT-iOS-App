//
//  BMLT_Parser.h
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
#import "BMLT_Server.h"

/*****************************************************************/
/**
 \class BMLT_Parser
 \brief This is a special overload of the NSXMLParser class that is
 designed specifically for use as a background thread parser.
 
 This is necessary, because NSXMLParser leaks like a rusty bucket,
 and needs NSAutoReleasePools to be set up in the executing thread.
 Since NSXMLParser doesn't let you overload a whole lot, I set this
 class up as a "proxy" for the delegate, and intercept the various
 NSXMLParserDelegate calls. I use these to start a pool and to take
 it down. I also add a timeout, and do all the stuff that is necessary
 to manage a separate timer thread.
 
 NOTE: This does not switch any calls to the main thread! All callbacks
 occur in the parser thread, so it is up to the delegate to switch
 UI calls to the main thread.
 *****************************************************************/
@interface BMLT_Parser : NSXMLParser <NSXMLParserDelegate>
{
    BMLT_Server                     *myServer;          ///< The server using this parser.
    NSObject                        *currentElement;    ///< The current XML element being parsed.
    NSObject<NSXMLParserDelegate>   *myFirstDelegate;   ///< The "principal" delegate for the parser.
    NSObject<NSXMLParserDelegate>   *myCurrentDelegate; ///< The current delegate (the parser works by passing the delegate around).
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
