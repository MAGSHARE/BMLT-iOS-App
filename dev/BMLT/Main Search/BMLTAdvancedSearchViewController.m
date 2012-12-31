//
//  BMLTAdvancedSearchViewController.m
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

#import "BMLTAdvancedSearchViewController.h"
#import "BMLTAppDelegate.h"
#import "BMLT_Prefs.h"
#import "BMLT_Parser.h"

static BOOL geocodeInProgress = NO;     ///< Used to look for a successful geocode.
static BOOL searchAfterLookup = NO;     ///< Used for the iPhone to make sure a search happens after the lookup for the return key (Handled differently for the iPad).

/******************************************************************/
/**
 \class  BMLTAdvancedSearchViewController    -Private Interface
 \brief  This class will present the user with a powerful search specification interface.
 *****************************************************************/
@interface BMLTAdvancedSearchViewController ()
{
    BOOL dontLookup;
}
@end

/******************************************************************/
/**
 \class  BMLTAdvancedSearchViewController    -Implementation
 \brief  This class will present the user with a powerful search specification interface.
 *****************************************************************/
@implementation BMLTAdvancedSearchViewController
@synthesize myParams, currentElement;
@synthesize weekdaysLabel, weekdaysSelector, sunLabel, sunButton = _sunButton, monLabel, monButton = _monButton, tueLabel, tueButton = _tueButton, wedLabel, wedButton = _wedButton, thuLabel, thuButton = _thuButton, friLabel, friButton = _friButton, satLabel, satButton = _satButton;
@synthesize searchLocationLabel, searchSpecSegmentedControl, searchSpecAddressTextEntry;
@synthesize goButton;

/******************************************************************/
/**
 \brief Initializer -allocates our parameter dictionary.
 \returns self
 *****************************************************************/
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if ( self )
        {
        myParams = [[NSMutableDictionary alloc] init];
        dontLookup = NO;
        }
    
    return self;
}

/******************************************************************/
/**
 \brief The only reason we intercept this, is to stop lookups.
 *****************************************************************/
- (void)viewWillDisappear:(BOOL)animated    ///< YES, if this is an animated disappearance (we don't care).
{
    dontLookup = YES;   // We set this to avoid lookups when we close.
}

/******************************************************************/
/**
 \brief Make sure that the text box is shown, if there is no choice.
 *****************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    dontLookup = NO;
    
    if ( ![BMLTAppDelegate locationServicesAvailable] && ![self mapSearchView] )
        {
        [searchSpecSegmentedControl setEnabled:NO forSegmentAtIndex:0];
        [searchSpecSegmentedControl setSelectedSegmentIndex:1];
        [searchSpecAddressTextEntry setAlpha:1.0];
        [searchSpecAddressTextEntry setEnabled:YES];
        dontLookup = NO;
        [searchSpecAddressTextEntry becomeFirstResponder];
        [goButton setEnabled:NO];
        }
    
    [self addToggleMapButton];
    
    [super viewWillAppear:animated];
}

/******************************************************************/
/**
 \brief Sets up all the localized strings and whatnot.
 *****************************************************************/
- (void)viewDidLoad
{
    [weekdaysLabel setText:NSLocalizedString([weekdaysLabel text], nil)];
    
    for ( NSUInteger i = 0; i < [weekdaysSelector numberOfSegments]; i++ )
        {
        [weekdaysSelector setTitle:NSLocalizedString([weekdaysSelector titleForSegmentAtIndex:i], nil) forSegmentAtIndex:i];
        }
    
    [sunLabel setText:NSLocalizedString([sunLabel text], nil)];
    [monLabel setText:NSLocalizedString([monLabel text], nil)];
    [tueLabel setText:NSLocalizedString([tueLabel text], nil)];
    [wedLabel setText:NSLocalizedString([wedLabel text], nil)];
    [thuLabel setText:NSLocalizedString([thuLabel text], nil)];
    [friLabel setText:NSLocalizedString([friLabel text], nil)];
    [satLabel setText:NSLocalizedString([satLabel text], nil)];
    
    [searchLocationLabel setText:NSLocalizedString([searchLocationLabel text], nil)];
    
    for ( NSUInteger i = 0; i < [searchSpecSegmentedControl numberOfSegments]; i++ )
        {
        [searchSpecSegmentedControl setTitle:NSLocalizedString([searchSpecSegmentedControl titleForSegmentAtIndex:i], nil) forSegmentAtIndex:i];
        }
    
    [searchSpecAddressTextEntry setPlaceholder:NSLocalizedString([searchSpecAddressTextEntry placeholder], nil)];
    
    [goButton setTitle:NSLocalizedString([goButton titleForState:UIControlStateNormal], nil) forState:UIControlStateNormal];
    
    [super viewDidLoad];
    
    [self setParamsForWeekdaySelection];
}

/******************************************************************/
/**
 \brief Called when the view is unloaded.
 *****************************************************************/
- (void)viewDidUnload
{
    [self setSunLabel:nil];
    [self setSunButton:nil];
    [self setMonLabel:nil];
    [self setMonButton:nil];
    [self setTueLabel:nil];
    [self setTueButton:nil];
    [self setWedLabel:nil];
    [self setWedButton:nil];
    [self setThuLabel:nil];
    [self setThuButton:nil];
    [self setFriLabel:nil];
    [self setFriButton:nil];
    [self setSatLabel:nil];
    [self setSatButton:nil];
    [super viewDidUnload];
}

/******************************************************************/
/**
 \brief Called when the weekday selection segmented control is changed.
 *****************************************************************/
- (IBAction)weekdaySelectionChanged:(id)sender  ///< The segmented control.
{
    BOOL    isEnabled = [weekdaysSelector selectedSegmentIndex] == kWeekdaySelectWeekdays;
    
    [[self sunButton] setEnabled:isEnabled];
    [[self monButton] setEnabled:isEnabled];
    [[self tueButton] setEnabled:isEnabled];
    [[self wedButton] setEnabled:isEnabled];
    [[self thuButton] setEnabled:isEnabled];
    [[self friButton] setEnabled:isEnabled];
    [[self satButton] setEnabled:isEnabled];
    
    [self setParamsForWeekdaySelection];
}

/******************************************************************/
/**
 \brief Called when the search button is pressed.
 *****************************************************************/
- (IBAction)doSearchButtonPressed:(id)sender    ///< The search button.
{
#ifdef DEBUG
    NSLog(@"BMLTAdvancedSearchViewController doSearchButtonPressed");
#endif
    [searchSpecAddressTextEntry resignFirstResponder];
    [[BMLTAppDelegate getBMLTAppDelegate] clearAllSearchResultsNo];
    
    [[BMLTAppDelegate getBMLTAppDelegate] searchForMeetingsNearMe:[[BMLTAppDelegate getBMLTAppDelegate] searchMapMarkerLoc] withParams:myParams];
}

/******************************************************************/
/**
 \brief Called when there is a click in the background.
 *****************************************************************/
- (IBAction)backgroundClicked:(id)sender
{
#ifdef DEBUG
    NSLog(@"BMLTAdvancedSearchViewController backgroundClicked");
#endif
    geocodeInProgress = NO;
    dontLookup = YES;
    [searchSpecAddressTextEntry resignFirstResponder];
}

/******************************************************************/
/**
 \brief Called when one of the weekday checkboxes is selected.
 *****************************************************************/
- (IBAction)weekdayChanged:(id)sender   //< The checkbox
{
    [self setParamsForWeekdaySelection];
}

/******************************************************************/
/**
 \brief Called when the search spec segmented control changes.
 *****************************************************************/
- (IBAction)searchSpecChanged:(id)sender    ///< The segmented control
{
#ifdef DEBUG
    NSLog(@"BMLTAdvancedSearchViewController searchSpecChanged: %d.", [(UISegmentedControl *)sender selectedSegmentIndex] );
#endif
    geocodeInProgress = NO;
    dontLookup = YES;
    searchAfterLookup = NO;
    if ( [(UISegmentedControl *)sender selectedSegmentIndex] == 0 ) // Near Me/Marker?
        {
        if ( ![self myMarker] )
            {
            [[BMLTAppDelegate getBMLTAppDelegate] lookupMyLocationWithAccuracy:kCLLocationAccuracyBest];
            }
        [searchSpecAddressTextEntry setAlpha:0.0];
        [searchSpecAddressTextEntry setEnabled:NO];
        }
    else
        {
        [searchSpecAddressTextEntry setAlpha:1.0];
        [searchSpecAddressTextEntry setEnabled:YES];
        dontLookup = NO;
        [searchSpecAddressTextEntry becomeFirstResponder];
        }
}

/******************************************************************/
/**
 \brief Called when the user has entered an address.
 *****************************************************************/
- (IBAction)addressTextEntered:(id)sender   ///< The text entry field.
{
#ifdef DEBUG
    NSLog(@"BMLTAdvancedSearchViewController addressTextEntered: \"%@\".", [searchSpecAddressTextEntry text] );
#endif
    if ( !dontLookup && [searchSpecAddressTextEntry text] && ([searchSpecSegmentedControl selectedSegmentIndex] == 1) )
        {
        [self geocodeLocationFromAddressString:[searchSpecAddressTextEntry text]];
        }
    else if ( ![BMLTAppDelegate locationServicesAvailable] && ![self mapSearchView] )
        {
        [goButton setEnabled:NO];
        }
    dontLookup = NO;
}

/******************************************************************/
/**
 \brief Sets up the parameters for the search, based on the state of the checkboxes.
 *****************************************************************/
- (void)setParamsForWeekdaySelection
{
    [myParams removeObjectForKey:@"weekdays"];  // Start with a clean slate.
    [myParams removeObjectForKey:@"StartsAfterH"];
    [myParams removeObjectForKey:@"StartsAfterM"];
    
    NSString    *button_asset = ([weekdaysSelector selectedSegmentIndex] == kWeekdaySelectAllDays) ? @"CheckBoxDisabled-Check.png" : @"CheckBoxDisabled.png";
    
    [[self sunButton] setImage:[UIImage imageNamed:button_asset] forState:UIControlStateDisabled];
    [[self monButton] setImage:[UIImage imageNamed:button_asset] forState:UIControlStateDisabled];
    [[self tueButton] setImage:[UIImage imageNamed:button_asset] forState:UIControlStateDisabled];
    [[self wedButton] setImage:[UIImage imageNamed:button_asset] forState:UIControlStateDisabled];
    [[self thuButton] setImage:[UIImage imageNamed:button_asset] forState:UIControlStateDisabled];
    [[self friButton] setImage:[UIImage imageNamed:button_asset] forState:UIControlStateDisabled];
    [[self satButton] setImage:[UIImage imageNamed:button_asset] forState:UIControlStateDisabled];
    
    NSInteger   wd = 0;
    
    // What we're doing here, is seeing if either the "Later Today" or "Tomorrow" checkboxes are selected. If so, we then set the wd variable to the chosen weekday. Otherwise, it is 0.
    if ( ([weekdaysSelector selectedSegmentIndex] == kWeekdaySelectTomorrow) || ([weekdaysSelector selectedSegmentIndex] == kWeekdaySelectToday) )
        {
        NSDate              *date = [BMLTAppDelegate getLocalDateAutoreleaseWithGracePeriod:YES];
        NSCalendar          *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents    *weekdayComponents = [gregorian components:(NSWeekdayCalendarUnit) fromDate:date];
        wd = [weekdayComponents weekday];
        weekdayComponents = [gregorian components:(NSHourCalendarUnit) fromDate:date];
        NSInteger           hr = [weekdayComponents hour];
        weekdayComponents = [gregorian components:(NSMinuteCalendarUnit) fromDate:date];
        NSInteger           mn = [weekdayComponents minute];
        
        if ( [weekdaysSelector selectedSegmentIndex] == kWeekdaySelectTomorrow )
            {
            wd++;
            if ( wd > kWeekdaySelectValue_Sat )
                {
                wd = kWeekdaySelectValue_Sun;
                }
            }
        else
            {
            [myParams setObject:[NSString stringWithFormat:@"%d",hr] forKey:@"StartsAfterH"];
            [myParams setObject:[NSString stringWithFormat:@"%d",mn] forKey:@"StartsAfterM"];
            }
        }
    
    NSString *weekday = @"";
    
    // If we are on the chosen weekday, or our button is enabled, and our buttin is on, then add this day to the list.
    if ( ((wd == kWeekdaySelectValue_Sun) || [[self sunButton] isEnabled]) && [[self sunButton] isChecked] )
        {
        [[self sunButton] setImage:[UIImage imageNamed:@"CheckBoxDisabled-Check.png"] forState:UIControlStateDisabled];
        weekday = @"1";
        }
    
    if ( (wd == kWeekdaySelectValue_Mon) || ([[self monButton] isEnabled] && [[self monButton] isChecked]) )
        {
        [[self monButton] setImage:[UIImage imageNamed:@"CheckBoxDisabled-Check.png"] forState:UIControlStateDisabled];
        weekday = [weekday stringByAppendingString:[weekday length] > 0 ? @",2" : @"2"];
        }
    
    if ( (wd == kWeekdaySelectValue_Tue) || ([[self tueButton] isEnabled] && [[self tueButton] isChecked]) )
        {
        [[self tueButton] setImage:[UIImage imageNamed:@"CheckBoxDisabled-Check.png"] forState:UIControlStateDisabled];
        weekday = [weekday stringByAppendingString:[weekday length] > 0 ? @",3" : @"3"];
        }
    
    if ( (wd == kWeekdaySelectValue_Wed) || ([[self wedButton] isEnabled] && [[self wedButton] isChecked]) )
        {
        [[self wedButton] setImage:[UIImage imageNamed:@"CheckBoxDisabled-Check.png"] forState:UIControlStateDisabled];
        weekday = [weekday stringByAppendingString:[weekday length] > 0 ? @",4" : @"4"];
        }
    
    if ( (wd == kWeekdaySelectValue_Thu) || ([[self thuButton] isEnabled] && [[self thuButton] isChecked]) )
        {
        [[self thuButton] setImage:[UIImage imageNamed:@"CheckBoxDisabled-Check.png"] forState:UIControlStateDisabled];
        weekday = [weekday stringByAppendingString:[weekday length] > 0 ? @",5" : @"5"];
        }
    
    if ( (wd == kWeekdaySelectValue_Fri) || ([[self friButton] isEnabled] && [[self friButton] isChecked]) )
        {
        [[self friButton] setImage:[UIImage imageNamed:@"CheckBoxDisabled-Check.png"] forState:UIControlStateDisabled];
        weekday = [weekday stringByAppendingString:[weekday length] > 0 ? @",6" : @"6"];
        }
    
    if ( (wd == kWeekdaySelectValue_Sat) || ([[self satButton] isEnabled] && [[self satButton] isChecked]) )
        {
        [[self satButton] setImage:[UIImage imageNamed:@"CheckBoxDisabled-Check.png"] forState:UIControlStateDisabled];
        weekday = [weekday stringByAppendingString:[weekday length] > 0 ? @",7" : @"7"];
        }
    
    // We have an array of chosen weekdays (integers). Set them to the parameter.
    if ( [weekday length] )
        {
        [myParams setObject:weekday forKey:@"weekdays"];
        }
}

/******************************************************************/
/**
 \brief Starts an asynchronous geocode from a given address string.
 *****************************************************************/
- (void)geocodeLocationFromAddressString:(NSString *)inLocationString    ///< The location, as a readable address string.
{
    if ( !dontLookup )  // Don't lookup if we are closing up shop.
        {
        CLLocationCoordinate2D centerLoc = [BMLTVariantDefs mapDefaultCenter];  // We center on the app's specified starting location
        
        // Create a bias region.
        CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:centerLoc radius:1.0 identifier:@"Default App Location"];
        
        CLGeocoder  *myGeocoder = [[CLGeocoder alloc] init];    // We temporarily create a geocoder for this.
        
        [myGeocoder geocodeAddressString:inLocationString
                                inRegion:region
                       completionHandler:^(NSArray* placemarks, NSError* error) // The completion handler deals with the result of the geocode.
                                        {
                                        // If we failed to geocode, we alert the user.
                                        if ( !placemarks || ![placemarks count] )
                                            {
                                            searchAfterLookup = NO;
                                            geocodeInProgress = NO;
                                            dontLookup = NO;
                                            UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GEOCODE-FAILURE",nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK-BUTTON",nil) otherButtonTitles:nil];
                                            [myAlert show];
                                            
                                            if ( ![BMLTAppDelegate locationServicesAvailable] && ![self mapSearchView] )
                                                {
                                                [goButton setEnabled:NO];
                                                }
                                            }
                                        else    // Otherwise, we find the nearest geocoded place, and use that.
                                            {
                                            CLLocation  *currentLoc = [[CLLocation alloc] initWithLatitude:centerLoc.latitude longitude:centerLoc.longitude];
                                            CLLocation  *centerLocation = currentLoc;
                                            
                                            float       lastDistance = MAXFLOAT;
                                            
                                            for (CLPlacemark* aPlacemark in placemarks)
                                                {
                                                CLLocationDistance meters = [[aPlacemark location] distanceFromLocation:centerLocation];
                                                
                                                if ( meters < lastDistance )
                                                    {
                                                    lastDistance = meters;
                                                    currentLoc = [aPlacemark location];

#ifdef DEBUG
                                                    NSLog(@"BMLTAdvancedSearchViewController::geocodeLocationFromAddressString: completionBlock: Setting the marker location to (%f, %f).", [currentLoc coordinate].longitude, [currentLoc coordinate].latitude);
#endif
                                                    }
                                                }
                                        
                                            [[BMLTAppDelegate getBMLTAppDelegate] setSearchMapMarkerLoc:[currentLoc coordinate]];
                                            
                                            [goButton setEnabled:YES];
                                            
                                            [self performSelectorOnMainThread:@selector(updateMap) withObject:nil waitUntilDone:NO];
                                            
                                            if ( searchAfterLookup )
                                                {
#ifdef DEBUG
                                                NSLog(@"BMLTAdvancedSearchViewController geocodeLocationFromAddressString completionBlock:. Starting a Search." );
#endif
                                                searchAfterLookup = NO;
                                                [goButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                                                }
                                            
                                            }
                                        }
         ];
        }
}

#pragma mark - UITextFieldDelegate Functions -
/******************************************************************/
/**
 \brief This is called when the user presses the "Enter" button on the text field editor.
 *****************************************************************/
- (BOOL)textFieldShouldReturn:(UITextField *)textField  ///< The text field object.
{
    geocodeInProgress = NO;
    if ( ![self mapSearchView] )
        {
        searchAfterLookup = YES;
        }
#ifdef DEBUG
    NSLog(@"BMLTAdvancedSearchViewController textFieldShouldReturn: searchAfterLookup = \"%@\".", searchAfterLookup ? @"YES" : @"NO");
#endif
    [self geocodeLocationFromAddressString:[textField text]];
    return NO;
}

/******************************************************************/
/**
 \brief When the text is done editing, we do the same thing, but
 without the subsequent search.
 *****************************************************************/
- (void)textFieldDidEndEditing:(UITextField *)textField ///< The text field object.
{
    searchAfterLookup = NO;
    if ( [[textField text] length] && ([searchSpecSegmentedControl selectedSegmentIndex] > 0) && !([[self view] isHidden]) )
        {
        [self geocodeLocationFromAddressString:[textField text]];
        }
}
@end
