//
//  AdvancedSearchViewController.m
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

#import "AdvancedSearchViewController.h"
#import "SpecifyNewSearchViewController.h"
#import "BMLTAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation AdvancedSearchViewController

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (id)initWithSearchSpecController:(SpecifyNewSearchViewController *)inController
{
    self = [self init];
    if (self)
        {
        [self setMyController:inController];
        UISwipeGestureRecognizer    *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:( [[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad ) ? self : mySpecController action:@selector(backSwipe:)];
        [gestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
        [[self view] addGestureRecognizer:gestureRecognizer];
        [gestureRecognizer release];
        }
    return self;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (id)init
{
    return [super initWithNibName:nil bundle:nil];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setMyController:(SpecifyNewSearchViewController *)inController
{
    [mySpecController release];
    [inController retain];
    mySpecController = inController;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)dealloc
{
    [mySpecController release];
    [weekdaysLabel release];
    [weekdaysSelector release];
    [sunButton release];
    [sunLabel release];
    [monLabel release];
    [monButton release];
    [tueLabel release];
    [tueButton release];
    [wedLabel release];
    [wedButton release];
    [thuLabel release];
    [thuButton release];
    [friLabel release];
    [friButton release];
    [satLabel release];
    [satButton release];
    [doSearchButton release];
    [findNearMeCheckbox release];
    [findNearMeLabel release];
    [addressEntryText release];
    [super dealloc];
}

#pragma mark - View lifecycle

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)viewDidLoad
{
    UIScrollView    *myScroller = (UIScrollView *)[self view];
    
    CGRect  bounds = [containerView bounds];
    
    bounds.origin = CGPointZero;
    
    CGRect  lowestFrame = [doSearchButton frame];
    
    bounds.size.height = lowestFrame.origin.y + lowestFrame.size.height + kBMLT_AdvancedItemsBottomPaddingInPixels;
    
    [myScroller setContentOffset:CGPointZero animated:YES];
    
    [containerView setBounds:bounds];
    [containerView setFrame:bounds];
    
    [myScroller setContentSize:bounds.size];
    
    [weekdaysLabel setText:NSLocalizedString(@"SEARCH-SPEC-SELECTED-WEEKDAYS", nil)];
    [addressEntryText setPlaceholder:NSLocalizedString(@"DEFAULT-ADDRESS-STRING", nil)];
    
    [weekdaysSelector setTitle:NSLocalizedString(@"SEARCH-SPEC-SELECTED-WEEKDAYS-0", nil) forSegmentAtIndex:0];
    [weekdaysSelector setTitle:NSLocalizedString(@"SEARCH-SPEC-SELECTED-WEEKDAYS-1", nil) forSegmentAtIndex:1];
    [weekdaysSelector setTitle:NSLocalizedString(@"SEARCH-SPEC-SELECTED-WEEKDAYS-2", nil) forSegmentAtIndex:2];
    [weekdaysSelector setTitle:NSLocalizedString(@"SEARCH-SPEC-SELECTED-WEEKDAYS-3", nil) forSegmentAtIndex:3];
    
    [sunLabel setText:NSLocalizedString(@"WEEKDAY-SHORT-NAME-0", nil)];
    [monLabel setText:NSLocalizedString(@"WEEKDAY-SHORT-NAME-1", nil)];
    [tueLabel setText:NSLocalizedString(@"WEEKDAY-SHORT-NAME-2", nil)];
    [wedLabel setText:NSLocalizedString(@"WEEKDAY-SHORT-NAME-3", nil)];
    [thuLabel setText:NSLocalizedString(@"WEEKDAY-SHORT-NAME-4", nil)];
    [friLabel setText:NSLocalizedString(@"WEEKDAY-SHORT-NAME-5", nil)];
    [satLabel setText:NSLocalizedString(@"WEEKDAY-SHORT-NAME-6", nil)];
    
    [findNearMeLabel setTitle:NSLocalizedString(@"FIND-NEAR-ME", nil) forState:UIControlStateNormal];
    
    [doSearchButton setTitle:NSLocalizedString(@"DO-SEARCH-BUTTON", nil) forState:UIControlStateNormal];
    
    [self setBeanieBackground];
    [super viewDidLoad];
    if ( ![[BMLT_Prefs getBMLT_Prefs] lookupMyLocation] )
        {
        [findNearMeCheckbox setIsOn:NO];
        [findNearMeCheckbox setEnabled:NO];
        [findNearMeLabel setAlpha:0];
        [findNearMeCheckbox setAlpha:0];
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)viewDidUnload
{
    [weekdaysLabel release];
    weekdaysLabel = nil;
    [weekdaysSelector release];
    weekdaysSelector = nil;
    [sunButton release];
    sunButton = nil;
    [sunLabel release];
    sunLabel = nil;
    [monLabel release];
    monLabel = nil;
    [monButton release];
    monButton = nil;
    [tueLabel release];
    tueLabel = nil;
    [tueButton release];
    tueButton = nil;
    [wedLabel release];
    wedLabel = nil;
    [wedButton release];
    wedButton = nil;
    [thuLabel release];
    thuLabel = nil;
    [thuButton release];
    thuButton = nil;
    [friLabel release];
    friLabel = nil;
    [friButton release];
    friButton = nil;
    [satLabel release];
    satLabel = nil;
    [satButton release];
    satButton = nil;
    [doSearchButton release];
    doSearchButton = nil;
    [findNearMeCheckbox release];
    findNearMeCheckbox = nil;
    [findNearMeLabel release];
    findNearMeLabel = nil;
    [addressEntryText release];
    addressEntryText = nil;
    [super viewDidUnload];
        // Release any retained subviews of the main view.
        // e.g. self.myOutlet = nil;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    BOOL    ret = ((io == UIInterfaceOrientationPortrait) || (io == UIInterfaceOrientationLandscapeLeft) || (io == UIInterfaceOrientationLandscapeRight));
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
        ret = YES;
        }
    return ret;
}

#pragma mark - Quick Search Responses

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)findMeetingsLaterToday:(BOOL)inLocal
{
        // We have a "grace period," so that you can be a bit late for meetings.
    NSInteger       grace_period = [[BMLT_Prefs getBMLT_Prefs] gracePeriod] * 60;
    NSDate          *date = [NSDate dateWithTimeIntervalSinceNow:-grace_period];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"c"];
    NSString *weekday = [dateFormatter stringFromDate:date];
    [dateFormatter setDateFormat:@"H"];
    NSString *hours = [dateFormatter stringFromDate:date];
    [dateFormatter setDateFormat:@"m"];
    NSString *minutes = [dateFormatter stringFromDate:date];
    
    NSMutableDictionary *myParams = [[NSMutableDictionary alloc] init];
    
    [myParams setObject:weekday forKey:@"weekdays"];
    [myParams setObject:hours forKey:@"StartsAfterH"];
    [myParams setObject:minutes forKey:@"StartsAfterM"];
    [myParams setObject:@"time" forKey:@"sort_key"]; // Sort by time for this search.
    
    [mySpecController setMySearchParams:myParams];
    [myParams release];
    [dateFormatter release];
    if ( inLocal )
        {
        [mySpecController searchForMeetingsAroundHere];
        }
    else
        {
        [mySpecController searchForMeetings];
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
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
    [mySpecController setMySearchParams:myParams];
    [myParams release];
}

#pragma mark - Custom Funtions

/***************************************************************\**
 \brief This applies the "Beanie Background" to the results view.
 *****************************************************************/
- (void)setBeanieBackground
{
    [[[self view] layer] setContentsGravity:kCAGravityResizeAspectFill];
    [[[self view] layer] setBackgroundColor:[[UIColor colorWithWhite:0 alpha:0] CGColor]];
    [[[self view] layer] setContents:(id)[[UIImage imageNamed:@"BeanieBack.png"] CGImage]];
}

/***************************************************************\**
 \brief
 *****************************************************************/
- (IBAction)findMeLabelClicked:(id)sender
{
    [findNearMeCheckbox toggleState];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (IBAction)findNearMeChanged:(id)sender
{
    if ([findNearMeCheckbox isOn])
        {
        [addressEntryText setText:nil];
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
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
        NSInteger       grace_period = [[BMLT_Prefs getBMLT_Prefs] gracePeriod] * 60;
        if ( [theControl selectedSegmentIndex] == kWeekdaySelectTomorrow )
            {
            grace_period = 0;
            }
        
        NSDate          *date = [NSDate dateWithTimeIntervalSinceNow:-grace_period];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"c"];
        NSInteger   wd = [[dateFormatter stringFromDate:date] intValue];
        
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
            [dateFormatter setDateFormat:@"H"];
            NSString *hours = [dateFormatter stringFromDate:date];
            [dateFormatter setDateFormat:@"m"];
            NSString *minutes = [dateFormatter stringFromDate:date];
            [myParams setObject:hours forKey:@"StartsAfterH"];
            [myParams setObject:minutes forKey:@"StartsAfterM"];
            }
        
        [myParams setObject:[NSString stringWithFormat:@"%d",wd] forKey:@"weekdays"];
        [myParams setObject:@"time" forKey:@"sort_key"]; // Sort by time for this search.
        [mySpecController setMySearchParams:myParams];
        [myParams release];
        [dateFormatter release];
        
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
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (IBAction)doSearchButtonPressed:(id)sender
{
    if ( [[addressEntryText text] length] && ([addressEntryText isEditing] || ![findNearMeCheckbox isOn]) )
        {
        NSMutableDictionary *myParams = [[NSMutableDictionary alloc] init];
        [myParams setObject:[addressEntryText text] forKey:@"SearchString"];
        [myParams setObject:@"1" forKey:@"StringSearchIsAnAddress"];
        [myParams setObject:@"time" forKey:@"sort_key"]; // Sort by time for this search.
        [mySpecController setMySearchParams:myParams];
        [[mySpecController mySearchController] setMySearchQueueLocationString:[addressEntryText text]];
        [BMLTAppDelegate lookupLocationFromAddressString:[addressEntryText text]];
        [myParams release];
        }
    
    switch ( [weekdaysSelector selectedSegmentIndex] )
    {
        case 2:
        [self findMeetingsLaterToday:[findNearMeCheckbox isOn]];
        break;
        
        case 1:
        [self setParamsForWeekdaySelection];
        default:
        if ( [findNearMeCheckbox isOn] )
            {
            [mySpecController searchForMeetingsAroundHere];
            }
        else
            {
            [mySpecController searchForMeetings];
            }
        break;
    }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (IBAction)backgroundClicked:(id)sender
{
    [self textFieldShouldReturn:addressEntryText];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (IBAction)backSwipe:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate Functions -

/***************************************************************\**
 \brief 
 \returns a BOOL -always YES
 *****************************************************************/
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [textField endEditing:YES];
    return YES;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    oldOrigin = [(UIScrollView *)[self view] contentOffset];
    
    CGRect  tFrame = [textField frame];
    tFrame.origin.x = 0;
    tFrame.origin.y -= kBMLT_AdvancedItemsBottomPaddingInPixels;
    
    [(UIScrollView *)[self view] setContentOffset:tFrame.origin animated:YES];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ( [[textField text] length] )
        {
        [findNearMeCheckbox setIsOn:NO];
        }
    
    [(UIScrollView *)[self view] setContentOffset:oldOrigin animated:YES];
}
@end
