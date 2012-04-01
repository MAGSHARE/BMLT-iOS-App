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

/**************************************************************//**
 \class  BMLTAdvancedSearchViewController    -Implementation
 \brief  This class will present the user with a powerful search specification interface.
 *****************************************************************/
@implementation BMLTAdvancedSearchViewController
@synthesize myParams;
@synthesize weekdaysLabel, weekdaysSelector, sunLabel, sunButton, monLabel, monButton, tueLabel, tueButton, wedLabel, wedButton, thuLabel, thuButton, friLabel, friButton, satLabel, satButton;
@synthesize searchLocationLabel, searchSpecSegmentedControl, searchSpecAddressTextEntry;
@synthesize goButton;

/**************************************************************//**
 \brief Initializer -allocates our parameter dictionary.
 \returns self
 *****************************************************************/
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if ( self )
        {
        myParams = [[NSMutableDictionary alloc] init];
        }
    
    return self;
}

/**************************************************************//**
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
    
    [self searchSpecChanged:searchSpecSegmentedControl];
    
    [goButton setTitle:NSLocalizedString([goButton titleForState:UIControlStateNormal], nil) forState:UIControlStateNormal];
    
    [super viewDidLoad];
}

/**************************************************************//**
 \brief Called when the weekday selection segmented control is changed.
 *****************************************************************/
- (IBAction)weekdaySelectionChanged:(id)sender  ///< The segmented control.
{
    UISegmentedControl  *theControl = (UISegmentedControl*)sender;
    
    [sunButton setImage:[UIImage imageNamed:@"RedXConcave.png"] forState:UIControlStateDisabled];
    [monButton setImage:[UIImage imageNamed:@"RedXConcave.png"] forState:UIControlStateDisabled];
    [tueButton setImage:[UIImage imageNamed:@"RedXConcave.png"] forState:UIControlStateDisabled];
    [wedButton setImage:[UIImage imageNamed:@"RedXConcave.png"] forState:UIControlStateDisabled];
    [thuButton setImage:[UIImage imageNamed:@"RedXConcave.png"] forState:UIControlStateDisabled];
    [friButton setImage:[UIImage imageNamed:@"RedXConcave.png"] forState:UIControlStateDisabled];
    [satButton setImage:[UIImage imageNamed:@"RedXConcave.png"] forState:UIControlStateDisabled];
    
    if ( [theControl selectedSegmentIndex] == kWeekdaySelectWeekdays )
        {
        [sunButton setEnabled:YES];
        [monButton setEnabled:YES];
        [tueButton setEnabled:YES];
        [wedButton setEnabled:YES];
        [thuButton setEnabled:YES];
        [friButton setEnabled:YES];
        [satButton setEnabled:YES];
        }
    else
        {
        [sunButton setEnabled:NO];
        [monButton setEnabled:NO];
        [monButton setEnabled:NO];
        [tueButton setEnabled:NO];
        [wedButton setEnabled:NO];
        [thuButton setEnabled:NO];
        [friButton setEnabled:NO];
        [satButton setEnabled:NO];
        }
    
    if ( ([theControl selectedSegmentIndex] == kWeekdaySelectToday) || ([theControl selectedSegmentIndex] == kWeekdaySelectTomorrow) )
        {
        NSDate              *date = [BMLTAppDelegate getLocalDateAutoreleaseWithGracePeriod:YES];
        NSCalendar          *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents    *weekdayComponents = [gregorian components:(NSWeekdayCalendarUnit) fromDate:date];
        NSInteger           wd = [weekdayComponents weekday];
        weekdayComponents = [gregorian components:(NSHourCalendarUnit) fromDate:date];
        NSInteger           hr = [weekdayComponents hour];
        weekdayComponents = [gregorian components:(NSMinuteCalendarUnit) fromDate:date];
        NSInteger           mn = [weekdayComponents minute];
        
        if ( [theControl selectedSegmentIndex] == kWeekdaySelectTomorrow )
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
        
        [myParams setObject:[NSString stringWithFormat:@"%d",wd] forKey:@"weekdays"];
        [myParams setObject:@"time" forKey:@"sort_key"]; // Sort by time for this search.
        
        switch ( wd )
            {
                case kWeekdaySelectValue_Sun:
                [sunButton setImage:[UIImage imageNamed:@"GreenCheckConcave.png"] forState:UIControlStateDisabled];
                break;
                
                case kWeekdaySelectValue_Mon:
                [monButton setImage:[UIImage imageNamed:@"GreenCheckConcave.png"] forState:UIControlStateDisabled];
                break;
                
                case kWeekdaySelectValue_Tue:
                [tueButton setImage:[UIImage imageNamed:@"GreenCheckConcave.png"] forState:UIControlStateDisabled];
                break;
                
                case kWeekdaySelectValue_Wed:
                [wedButton setImage:[UIImage imageNamed:@"GreenCheckConcave.png"] forState:UIControlStateDisabled];
                break;
                
                case kWeekdaySelectValue_Thu:
                [thuButton setImage:[UIImage imageNamed:@"GreenCheckConcave.png"] forState:UIControlStateDisabled];
                break;
                
                case kWeekdaySelectValue_Fri:
                [friButton setImage:[UIImage imageNamed:@"GreenCheckConcave.png"] forState:UIControlStateDisabled];
                break;
                
                case kWeekdaySelectValue_Sat:
                [satButton setImage:[UIImage imageNamed:@"GreenCheckConcave.png"] forState:UIControlStateDisabled];
                break;
            }
        }
    [self setParamsForWeekdaySelection];
}

/**************************************************************//**
 \brief Called when the search button is pressed.
 *****************************************************************/
- (IBAction)doSearchButtonPressed:(id)sender    ///< The search button.
{
    CLLocationCoordinate2D  myLocation = [self getMapCoordinates];
    
    [myParams setObject:[NSString stringWithFormat:@"%d", -[[BMLT_Prefs getBMLT_Prefs] resultCount]] forKey:@"geo_width"];
    [myParams setObject:[NSString stringWithFormat:@"%f", myLocation.longitude] forKey:@"long_val"];
    [myParams setObject:[NSString stringWithFormat:@"%f", myLocation.latitude] forKey:@"lat_val"];
    [[BMLTAppDelegate getBMLTAppDelegate] setLastLookupLoc:myLocation];
    
    [[BMLTAppDelegate getBMLTAppDelegate] executeSearchWithParams:myParams];    // Start the search.
}

/**************************************************************//**
 \brief Called when there is a click in the background.
 *****************************************************************/
- (IBAction)backgroundClicked:(id)sender
{

}

/**************************************************************//**
 \brief Called when one of the weekday checkboxes is selected.
 *****************************************************************/
- (IBAction)weekdayChanged:(id)sender   //< The checkbox
{
    [self setParamsForWeekdaySelection];
}

/**************************************************************//**
 \brief Called when the search spec segmented control changes.
 *****************************************************************/
- (IBAction)searchSpecChanged:(id)sender    ///< The segmented control
{
    if ( [(UISegmentedControl *)sender selectedSegmentIndex] == 0 )
        {
        [searchSpecAddressTextEntry setAlpha:0.0];
        [searchSpecAddressTextEntry setEnabled:NO];
        }
    else
        {
        [searchSpecAddressTextEntry setAlpha:1.0];
        [searchSpecAddressTextEntry setEnabled:YES];
        }
}

/**************************************************************//**
 \brief Called when the user has entered an address.
 *****************************************************************/
- (IBAction)addressTextEntered:(id)sender   ///< The text entry field.
{
}

/**************************************************************//**
 \brief Sets up the parameters for the search, based on the state of the checkboxes.
 *****************************************************************/
- (void)setParamsForWeekdaySelection
{
    NSString *weekday = @"";
    
    if ( [sunButton isEnabled] && [sunButton isOn] )
        {
        weekday = [weekday stringByAppendingString:@"1"];
        }
    
    if ( [monButton isEnabled] && [monButton isOn] )
        {
        if ( [weekday length] )
            {
            weekday = [weekday stringByAppendingString:@",2"];
            }
        else
            {
            weekday = [weekday stringByAppendingString:@"2"];
            }
        }
    
    if ( [tueButton isEnabled] && [tueButton isOn] )
        {
        if ( [weekday length] )
            {
            weekday = [weekday stringByAppendingString:@",3"];
            }
        else
            {
            weekday = [weekday stringByAppendingString:@"3"];
            }
        }
    
    if ( [wedButton isEnabled] && [wedButton isOn] )
        {
        if ( [weekday length] )
            {
            weekday = [weekday stringByAppendingString:@",4"];
            }
        else
            {
            weekday = [weekday stringByAppendingString:@"4"];
            }
        }
    
    if ( [thuButton isEnabled] && [thuButton isOn] )
        {
        if ( [weekday length] )
            {
            weekday = [weekday stringByAppendingString:@",5"];
            }
        else
            {
            weekday = [weekday stringByAppendingString:@"5"];
            }
        }
    
    if ( [friButton isEnabled] && [friButton isOn] )
        {
        if ( [weekday length] )
            {
            weekday = [weekday stringByAppendingString:@",6"];
            }
        else
            {
            weekday = [weekday stringByAppendingString:@"6"];
            }
        }
    
    if ( [satButton isEnabled] && [satButton isOn] )
        {
        if ( [weekday length] )
            {
            weekday = [weekday stringByAppendingString:@",7"];
            }
        else
            {
            weekday = [weekday stringByAppendingString:@"7"];
            }
        }
    
    [myParams setObject:weekday forKey:@"weekdays"];
}
@end
