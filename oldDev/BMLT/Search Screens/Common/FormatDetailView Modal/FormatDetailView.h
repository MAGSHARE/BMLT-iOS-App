//
//  FormatDetailView.h
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

#import <UIKit/UIKit.h>
#import "BMLT_Format.h"

@class A_SearchController;

@interface FormatDetailView : UIViewController
{
    A_SearchController          *myModalController;
    BMLT_Format                 *myFormat;
    IBOutlet UINavigationBar    *navBar;
    IBOutlet UILabel            *formatKeyLabel;
    IBOutlet UIImageView        *formatKeyImage;
    IBOutlet UITextView         *formatDescription;
}
- (id)initWithFormat:(BMLT_Format *)inFormat andController:(A_SearchController *)inController;
- (IBAction)donePressed:(id)sender;
- (void)setMyFormat:(BMLT_Format *)inFormat;
- (void)setUpKey;
- (void)setTitle;
- (void)setDescription;
- (BMLT_Format *)getMyFormat;
- (void)setBeanieBackground;
- (void)setMyModalController:(A_SearchController *)inController;
- (A_SearchController *)getMyModalController;
@end
