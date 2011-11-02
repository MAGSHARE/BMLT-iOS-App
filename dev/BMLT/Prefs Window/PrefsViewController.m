//
//  PrefsWindowViewController.m
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

#import "PrefsViewController.h"
#import "BMLT_Driver.h"
#import <QuartzCore/QuartzCore.h>
#import "BMLTAppDelegate.h"

@implementation PrefsViewController

/***************************************************************\**
 \brief 
 *****************************************************************/
- (id)init
{
    self = [super init];
    
    if ( self )
        {
        UISwipeGestureRecognizer    *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:[BMLTAppDelegate getBMLTAppDelegate] action:@selector(swipeFromPrefs:)];
        [gestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
        [[self view] addGestureRecognizer:gestureRecognizer];
        [gestureRecognizer release];
        [productNameLabel setText:NSLocalizedString(@"SETTINGS-PRODUCT-NAME", nil)];
        [byLineLabel setText:NSLocalizedString(@"SETTINGS-BYLINE", nil)];
        [blurbLabel setText:NSLocalizedString(@"SETTINGS-BLURB", nil)];
        [versionLabel setText:NSLocalizedString(@"SETTINGS-VERSION-LABEL", nil)];
        [sourceURIBlurbLabel setText:NSLocalizedString(@"SETTINGS-URI-BLURB", nil)];
        [sourceURIButton setTitle:NSLocalizedString(@"SETTINGS-URI", nil) forState:UIControlStateNormal];
        [self displayVersion];
        }
    
    return self;
}

/***************************************************************\**
 \brief This is called when the app is running low on memory. We
        will flush the allocated view elements.
 *****************************************************************/
- (void)didReceiveMemoryWarning
{
    [navBar release];
    navBar = nil;
    [super didReceiveMemoryWarning];
}

/***************************************************************\**
 \brief Called when the instance is being deleted.
 *****************************************************************/
- (void)dealloc
{
    [navBar release];
    [productNameLabel release];
    [byLineLabel release];
    [blurbLabel release];
    [versionLabel release];
    [versionDisplayLabel release];
    [settingsScrollView release];
    [prefsController release];
    [sourceURIBlurbLabel release];
    [sourceURIButton release];
    [super dealloc];
}

#pragma mark - View lifecycle

/***************************************************************\**
 \brief Called when the view is loaded. We take the opportunity to
        set up our controller.
 *****************************************************************/
- (void)viewDidLoad
{
    [self setBeanieBackground];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadSettingsView];
}

/***************************************************************\**
 \brief Called after the view is unloaded.
 *****************************************************************/
- (void)viewDidUnload
{
    [navBar release];
    navBar = nil;
    [productNameLabel release];
    productNameLabel = nil;
    [byLineLabel release];
    byLineLabel = nil;
    [blurbLabel release];
    blurbLabel = nil;
    [versionLabel release];
    versionLabel = nil;
    [versionDisplayLabel release];
    versionDisplayLabel = nil;
    [settingsScrollView release];
    settingsScrollView = nil;
    [sourceURIBlurbLabel release];
    sourceURIBlurbLabel = nil;
    [sourceURIButton release];
    sourceURIButton = nil;
    [super viewDidUnload];
}

/***************************************************************\**
 \brief We only want portrait for this one.
 \returns a BOOL. YES if the orientation is correct.
 *****************************************************************/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    BOOL    ret = io == UIInterfaceOrientationPortrait;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
        ret = YES;
        }
    
    return ret;
}

#pragma mark - Event Handlers -

/***************************************************************\**
 \brief Let's go visit Mr. MAGSHARE!
 *****************************************************************/
- (IBAction)beanieButtonPressed:(id)sender
{
    [BMLTAppDelegate imVisitingMAGSHARE];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:NSLocalizedString(@"SETTINGS-BEANIE-BUTTON-URI", nil)]];
}

/***************************************************************\**
 \brief Let's go to the source...
 *****************************************************************/
- (IBAction)sourceURIPressed:(id)sender
{
    [BMLTAppDelegate imVisitingMAGSHARE];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:NSLocalizedString(@"SETTINGS-URI", nil)]];
}

/***************************************************************\**
 \brief This applies the "Beanie Background" to the results view.
 *****************************************************************/
- (void)setBeanieBackground
{
    [[[self view] layer] setContentsGravity:kCAGravityResizeAspectFill];
    [[[self view] layer] setBackgroundColor:[[UIColor colorWithWhite:0 alpha:0] CGColor]];
    
    UIImage *layerImage = [UIImage imageNamed:@"BeanieBack.png"];
    CGImageRef image = [layerImage CGImage];
    
    [[[self view] layer] setContents:(id)image];
}

/***************************************************************\**
 \brief Displays the short version string in the Settings pane.
 *****************************************************************/
- (void)displayVersion
{
    NSString        *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary    *plistFile = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSString        *versionInfo = [plistFile valueForKey:@"CFBundleVersion"];
    [versionDisplayLabel setText:versionInfo];
}

/***************************************************************\**
 \brief Sets up the scrolled settings area.
 *****************************************************************/
- (void)loadSettingsView
{
    if ( !prefsController )
        {
        prefsController = [[PreferencesSubViewController alloc] initWithNibName:nil bundle:nil];
        
        CGRect  frame = [settingsScrollView bounds];
        
        frame.origin = CGPointZero;
        frame.size.height = [[prefsController view] frame].size.height;
        frame.size.width = [settingsScrollView bounds].size.width;
        
        [[prefsController view] setFrame:frame];
        [settingsScrollView setContentSize:frame.size];
        [settingsScrollView setContentOffset:CGPointZero];
        [prefsController setSwitches];
        [settingsScrollView addSubview:[prefsController view]];
        }
}
@end
