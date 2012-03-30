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

/**************************************************************//**
 \class  BMLTAdvancedSearchViewController    -Private Interface
 \brief  This class will present the user with a powerful search specification interface.
 *****************************************************************/
@interface BMLTAdvancedSearchViewController ()

@end

/**************************************************************//**
 \class  BMLTAdvancedSearchViewController    -Implementation
 \brief  This class will present the user with a powerful search specification interface.
 *****************************************************************/
@implementation BMLTAdvancedSearchViewController
@synthesize weekdaysLabel, weekdaysSelector, sunLabel, sunButton, monLabel, monButton, tueLabel, tueButton, wedLabel, wedButton, thuLabel, thuButton, friLabel, friButton, satLabel, satButton, doSearchButton, findNearMeLabel, findNearMeCheckbox, containerView, addressEntryText;

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
    
    [findNearMeLabel setTitle:NSLocalizedString(@"FIND-NEAR-ME", nil) forState:UIControlStateNormal];
    [addressEntryText setPlaceholder:NSLocalizedString(@"DEFAULT-ADDRESS-STRING", nil)];
    [doSearchButton setTitle:NSLocalizedString(@"DO-SEARCH-BUTTON", nil) forState:UIControlStateNormal];
    
    [super viewDidLoad];
}

- (IBAction)weekdaySelectionChanged:(id)sender
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
        
        NSMutableDictionary *myParams = [[NSMutableDictionary alloc] init];
        
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

- (IBAction)doSearchButtonPressed:(id)sender
{
    
}

- (IBAction)backgroundClicked:(id)sender
{

}

- (IBAction)findMeLabelClicked:(id)sender
{
    
}

- (IBAction)findNearMeChanged:(id)sender
{

}

- (IBAction)weekdayChanged:(id)sender
{
    [self setParamsForWeekdaySelection];
}

- (void)setParamsForWeekdaySelection
{
    NSString *weekday = @"";
    
    if ( [sunButton isEnabled] && [sunButton isOn] )
        {
        weekday = [weekday stringByAppendingFormat:@"1"];
        }
    
    if ( [monButton isEnabled] && [monButton isOn] )
        {
        if ( [weekday length] )
            {
            weekday = [weekday stringByAppendingFormat:@",2"];
            }
        else
            {
            weekday = [weekday stringByAppendingFormat:@"2"];
            }
        }
    
    if ( [tueButton isEnabled] && [tueButton isOn] )
        {
        if ( [weekday length] )
            {
            weekday = [weekday stringByAppendingFormat:@",3"];
            }
        else
            {
            weekday = [weekday stringByAppendingFormat:@"3"];
            }
        }
    
    if ( [wedButton isEnabled] && [wedButton isOn] )
        {
        if ( [weekday length] )
            {
            weekday = [weekday stringByAppendingFormat:@",4"];
            }
        else
            {
            weekday = [weekday stringByAppendingFormat:@"4"];
            }
        }
    
    if ( [thuButton isEnabled] && [thuButton isOn] )
        {
        if ( [weekday length] )
            {
            weekday = [weekday stringByAppendingFormat:@",5"];
            }
        else
            {
            weekday = [weekday stringByAppendingFormat:@"5"];
            }
        }
    
    if ( [friButton isEnabled] && [friButton isOn] )
        {
        if ( [weekday length] )
            {
            weekday = [weekday stringByAppendingFormat:@",6"];
            }
        else
            {
            weekday = [weekday stringByAppendingFormat:@"6"];
            }
        }
    
    if ( [satButton isEnabled] && [satButton isOn] )
        {
        if ( [weekday length] )
            {
            weekday = [weekday stringByAppendingFormat:@",7"];
            }
        else
            {
            weekday = [weekday stringByAppendingFormat:@"7"];
            }
        }
    
    NSMutableDictionary *myParams = [[NSMutableDictionary alloc] init];
    [myParams setObject:weekday forKey:@"weekdays"];
}
@end
