//
//  PrefsWindowViewController.h
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
#import "PreferencesSubViewController.h"

@class  BMLT_ServerTableViewController;

@interface PrefsViewController : UIViewController
{
    IBOutlet UINavigationBar        *navBar;
    IBOutlet UILabel                *productNameLabel;
    IBOutlet UILabel                *byLineLabel;
    IBOutlet UILabel                *blurbLabel;
    IBOutlet UILabel                *versionLabel;
    IBOutlet UILabel                *versionDisplayLabel;
    IBOutlet UIScrollView           *settingsScrollView;
    IBOutlet UILabel                *sourceURIBlurbLabel;
    IBOutlet UIButton               *sourceURIButton;
    PreferencesSubViewController    *prefsController;
}
- (IBAction)beanieButtonPressed:(id)sender;
- (IBAction)sourceURIPressed:(id)sender;

- (void)setBeanieBackground;
- (void)loadSettingsView;
- (void)displayVersion;
@end
