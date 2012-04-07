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
static BOOL dontLookup = NO;            ///< This is used to keep the text editor from triggering a search when it is dismissed prematurely (kludge).
static BOOL searchAfterLookup = NO;     ///< Used for the iPhone to make sure a search happens after the lookup for the return key (Handled differently for the iPad).

/**************************************************************//**
 \class  BMLTAdvancedSearchViewController    -Implementation
 \brief  This class will present the user with a powerful search specification interface.
 *****************************************************************/
@implementation BMLTAdvancedSearchViewController
@synthesize myParams, currentElement;
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
    
    [goButton setTitle:NSLocalizedString([goButton titleForState:UIControlStateNormal], nil) forState:UIControlStateNormal];
    
    [super viewDidLoad];
}

/**************************************************************//**
 \brief Called when the weekday selection segmented control is changed.
 *****************************************************************/
- (IBAction)weekdaySelectionChanged:(id)sender  ///< The segmented control.
{
    [sunButton setImage:[UIImage imageNamed:@"RedXConcave.png"] forState:UIControlStateDisabled];
    [monButton setImage:[UIImage imageNamed:@"RedXConcave.png"] forState:UIControlStateDisabled];
    [tueButton setImage:[UIImage imageNamed:@"RedXConcave.png"] forState:UIControlStateDisabled];
    [wedButton setImage:[UIImage imageNamed:@"RedXConcave.png"] forState:UIControlStateDisabled];
    [thuButton setImage:[UIImage imageNamed:@"RedXConcave.png"] forState:UIControlStateDisabled];
    [friButton setImage:[UIImage imageNamed:@"RedXConcave.png"] forState:UIControlStateDisabled];
    [satButton setImage:[UIImage imageNamed:@"RedXConcave.png"] forState:UIControlStateDisabled];
    
    if ( [weekdaysSelector selectedSegmentIndex] == kWeekdaySelectWeekdays )
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
    
    if ( ([weekdaysSelector selectedSegmentIndex] == kWeekdaySelectToday) || ([weekdaysSelector selectedSegmentIndex] == kWeekdaySelectTomorrow) )
        {
        NSDate              *date = [BMLTAppDelegate getLocalDateAutoreleaseWithGracePeriod:YES];
        NSCalendar          *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents    *weekdayComponents = [gregorian components:(NSWeekdayCalendarUnit) fromDate:date];
        NSInteger           wd = [weekdayComponents weekday];
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
#ifdef DEBUG
    NSLog(@"BMLTAdvancedSearchViewController doSearchButtonPressed");
#endif
    [searchSpecAddressTextEntry resignFirstResponder];
    
    [[BMLTAppDelegate getBMLTAppDelegate] searchForMeetingsNearMe:[[BMLTAppDelegate getBMLTAppDelegate] searchMapMarkerLoc] withParams:myParams]; 
}

/**************************************************************//**
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
            [[BMLTAppDelegate getBMLTAppDelegate] lookupMyLocation:YES];
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

/**************************************************************//**
 \brief Called when the user has entered an address.
 *****************************************************************/
- (IBAction)addressTextEntered:(id)sender   ///< The text entry field.
{
#ifdef DEBUG
    NSLog(@"BMLTAdvancedSearchViewController addressTextEntered: \"%@\".", [searchSpecAddressTextEntry text] );
#endif
    if ( !dontLookup && [searchSpecAddressTextEntry text] && ([searchSpecSegmentedControl selectedSegmentIndex] == 1) )
        {
        [self lookupLocationFromAddressString:[searchSpecAddressTextEntry text]];
        }
    dontLookup = NO;
}

/**************************************************************//**
 \brief Sets up the parameters for the search, based on the state of the checkboxes.
 *****************************************************************/
- (void)setParamsForWeekdaySelection
{
    NSString *weekday = @"";
    
    if ( (([weekdaysSelector selectedSegmentIndex] == kWeekdaySelectToday) || ([weekdaysSelector selectedSegmentIndex] == kWeekdaySelectTomorrow) || [sunButton isEnabled]) && [sunButton isOn] )
        {
        weekday = [weekday stringByAppendingString:@"1"];
        }
    
    if ( (([weekdaysSelector selectedSegmentIndex] == kWeekdaySelectToday) || ([weekdaysSelector selectedSegmentIndex] == kWeekdaySelectTomorrow) || [monButton isEnabled]) && [monButton isOn] )
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
    
    if ( (([weekdaysSelector selectedSegmentIndex] == kWeekdaySelectToday) || ([weekdaysSelector selectedSegmentIndex] == kWeekdaySelectTomorrow) || [tueButton isEnabled]) && [tueButton isOn] )
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
    
    if ( (([weekdaysSelector selectedSegmentIndex] == kWeekdaySelectToday) || ([weekdaysSelector selectedSegmentIndex] == kWeekdaySelectTomorrow) || [wedButton isEnabled]) && [wedButton isOn] )
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
    
    if ( (([weekdaysSelector selectedSegmentIndex] == kWeekdaySelectToday) || ([weekdaysSelector selectedSegmentIndex] == kWeekdaySelectTomorrow) || [thuButton isEnabled]) && [thuButton isOn] )
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
    
    if ( (([weekdaysSelector selectedSegmentIndex] == kWeekdaySelectToday) || ([weekdaysSelector selectedSegmentIndex] == kWeekdaySelectTomorrow) || [friButton isEnabled]) && [friButton isOn] )
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
    
    if ( (([weekdaysSelector selectedSegmentIndex] == kWeekdaySelectToday) || ([weekdaysSelector selectedSegmentIndex] == kWeekdaySelectTomorrow) || [satButton isEnabled]) && [satButton isOn] )
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
    
    if ( [weekday length] )
        {
        [myParams setObject:weekday forKey:@"weekdays"];
        }
}

/**************************************************************//**
 \brief Starts an asynchronous geocode from a given address string.
 *****************************************************************/
- (void)lookupLocationFromAddressString:(NSString *)inLocationString    ///< The location, as a readable address string.
{
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    
    inLocationString = [inLocationString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    inLocationString = [inLocationString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString    *uriString = [NSString stringWithFormat:kGoogleReverseLooupURI_Format, inLocationString];
    
#ifdef DEBUG
    NSLog(@"BMLTAdvancedSearchViewController lookupLocationFromAddressString: \"%@\", and the URI is \"%@\".", inLocationString, uriString );
#endif

    BMLT_Parser *myParser = [[BMLT_Parser alloc] initWithContentsOfURL:[NSURL URLWithString:uriString]];
    
    [myParser setDelegate:self];
    
    geocodeInProgress = YES;

    [myParser parseAsync:NO WithTimeout:kAddressLookupTimeoutPeriod_in_seconds];
}

/**************************************************************//**
 \brief Displays an error, indicating geocode failure.
 *****************************************************************/
- (void)cantGeocode
{
#ifdef DEBUG
    NSLog(@"BMLTAdvancedSearchViewController cantGeocode. Alert displayed." );
#endif
    searchAfterLookup = NO;
    geocodeInProgress = NO;
    dontLookup = NO;
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GEOCODE-FAILURE",nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK-BUTTON",nil) otherButtonTitles:nil];
    [myAlert show];    
}

#pragma mark - UITextFieldDelegate Functions -
/**************************************************************//**
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
    [self lookupLocationFromAddressString:[textField text]];
    return NO;
}

/**************************************************************//**
 \brief When the text is done editing, we do the same thing, but
        without the subsequent search.
 *****************************************************************/
- (void)textFieldDidEndEditing:(UITextField *)textField ///< The text field object.
{
    searchAfterLookup = NO;
    [self lookupLocationFromAddressString:[textField text]];
}

#pragma mark - NSXMLParserDelegate Functions -
/**************************************************************//**
 \brief Called when the parser starts on an element.
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser            ///< The parser in question.
didStartElement:(NSString *)elementName         ///< The XML name of the element.
  namespaceURI:(NSString *)namespaceURI         ///< The namespace of the element.
 qualifiedName:(NSString *)qName                ///< The XML q-name of the element.
    attributes:(NSDictionary *)attributeDict    ///< The element's attributes.
{
    currentElement = elementName;
#ifdef DEBUG
    NSLog(@"BMLTAdvancedSearchViewController Parser Start %@ element", elementName );
#endif
}

/**************************************************************//**
 \brief Called when the parser finds characters in an element.
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser        ///< The parser in question.
foundCharacters:(NSString *)string          ///< The character data.
{
#ifdef DEBUG
    NSLog(@"BMLTAdvancedSearchViewController Parser foundCharacters: \"%@\"", string );
#endif
    if ( [currentElement isEqualToString:@"coordinates"] )
        {
        NSArray *coords = [string componentsSeparatedByString:@","];
        if ( coords && ([coords count] > 1) )
            {
            CLLocationCoordinate2D  lastLookup;
            
            lastLookup.longitude = [(NSString *)[coords objectAtIndex:0] doubleValue];
            lastLookup.latitude = [(NSString *)[coords objectAtIndex:1] doubleValue];
            
            if ( lastLookup.longitude != 0 && lastLookup.latitude != 0 )
                {
#ifdef DEBUG
                NSLog(@"BMLTAdvancedSearchViewController::parser: foundCharacters: Setting the marker location to (%f, %f).", lastLookup.longitude, lastLookup.latitude);
#endif
                [[BMLTAppDelegate getBMLTAppDelegate] setSearchMapMarkerLoc:lastLookup];
            
                geocodeInProgress = NO;
#ifdef DEBUG
                NSLog(@"BMLTAdvancedSearchViewController::parser: foundCharacters: set location to: %f, %f", lastLookup.longitude, lastLookup.latitude );
#endif
                }
#ifdef DEBUG
            else
                {
                NSLog(@"BMLTAdvancedSearchViewController::parser: foundCharacters: NULL location!");
                }
#endif
            }
        }
}

/**************************************************************//**
 \brief Called when the parser is done with an element.
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser        ///< The parser in question.
didStartElement:(NSString *)elementName     ///< The XML name of the element.
  namespaceURI:(NSString *)namespaceURI     ///< The namespace of the element.
 qualifiedName:(NSString *)qName            ///< The XML q-name of the element.
{
#ifdef DEBUG
    NSLog(@"BMLTAdvancedSearchViewController Parser Stop %@ element", elementName );
#endif
    currentElement = nil;
}

/**************************************************************//**
 \brief Called if the parser encounters an error.
 *****************************************************************/
- (void)parser:(NSXMLParser *)parser        ///< The parser in question.
parseErrorOccurred:(NSError *)parseError    ///< The error.
{
#ifdef DEBUG
    NSLog(@"BMLTAdvancedSearchViewController Parser Error: %@", [parseError localizedDescription] );
#endif
    if ( geocodeInProgress )
        {
        [self performSelectorOnMainThread:@selector(cantGeocode) withObject:nil waitUntilDone:YES];
        }
    
    geocodeInProgress = NO;
    searchAfterLookup = NO;
}

/**************************************************************//**
 \brief Called when the parser starts on the returned XML document.
 *****************************************************************/
- (void)parserDidStartDocument:(NSXMLParser *)parser  ///< The parser in question
{
#ifdef DEBUG
    NSLog(@"BMLTAdvancedSearchViewController Parser Starting" );
#endif
    currentElement = nil;
}

/**************************************************************//**
 \brief Called when the parser is done with the document. If we could
        not get a geocode, we flag an error.
 *****************************************************************/
- (void)parserDidEndDocument:(NSXMLParser *)parser  ///< The parser in question
{
#ifdef DEBUG
    NSLog(@"BMLTAdvancedSearchViewController Parser Complete" );
#endif
    
    [(BMLT_Parser *)parser cancelTimeout];
    currentElement = nil;
    if ( geocodeInProgress )
        {
#ifdef DEBUG
        NSLog(@"BMLTAdvancedSearchViewController parserDidEndDocument. Error. Nothing returned. Pitch a fit." );
#endif
        [self performSelectorOnMainThread:@selector(cantGeocode) withObject:nil waitUntilDone:NO];
        }
    else
        {
        [self performSelectorOnMainThread:@selector(updateMap) withObject:nil waitUntilDone:NO];
        
        if ( searchAfterLookup )
            {
#ifdef DEBUG
            NSLog(@"BMLTAdvancedSearchViewController parserDidEndDocument. Starting a Search." );
#endif
            searchAfterLookup = NO;
            [self performSelectorOnMainThread:@selector(doSearchButtonPressed:) withObject:goButton waitUntilDone:NO];
            }
        }
    
    geocodeInProgress = NO;
    dontLookup = NO;
}
@end
