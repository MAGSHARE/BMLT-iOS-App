//
//  A_SearchController.m
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

#import "A_SearchController.h"
#import <QuartzCore/QuartzCore.h>
#import "MeetingDisplayCellView.h"
#import "BMLT_Meeting.h"
#import "BMLTAppDelegate.h"
#import "MeetingDetailViewController.h"

@implementation BeanieButton

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (id)initAsList:(BOOL)inIsList
{
    self = [super init];
    
    if ( self )
        {
        UIImage *logoImage = [UIImage imageNamed:inIsList ? @"BeanieLogoList.png" : @"BeanieLogoMap.png"];
        CGSize  imageSize = [logoImage size]; 
        [self setImage:logoImage forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"BeanieLogoHighlight.png"] forState:UIControlStateHighlighted];
        [self setImage:[UIImage imageNamed:@"BeanieLogoHighlight.png"] forState:UIControlStateSelected];

        [self setBounds:CGRectMake(0, 0, imageSize.width, imageSize.height)];
        }
    
    return self;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setEnabled:(BOOL)enabled
{
    [self setAlpha:enabled ? 1.0 : 0.0];
    [super setEnabled:enabled];
}

@end

@implementation A_SearchController

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (id)init
{
    self = [super init];
    
    if ( self )
        {
        myQueue.params = nil;
        [self initSearchQueue];
        }
    
    return self;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)initSearchQueue
{
    [myQueue.params release];
    myQueue.params = nil;
    [myQueue.locationText release];
    myQueue.locationText = nil;
    myQueue.findLocationFirst = NO;
    myQueue.startSearch = NO;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setMySearchQueueParams:(NSDictionary *)inParams
{
    [inParams retain];
    [myQueue.params release];
    myQueue.params = inParams;
}


/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setMySearchQueueLocationString:(NSString *)inString
{
    [inString retain];
    [myQueue.locationText release];
    myQueue.locationText = inString;
    if ( [inString length] )
        {
        myQueue.findLocationFirst = YES;
        myQueue.startSearch = NO;
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setMySearchQueueFindLocationFirst:(BOOL)inFindLocation
{
    myQueue.findLocationFirst = inFindLocation;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setMySearchQueueStartSearch:(BOOL)inStart
{
    myQueue.startSearch = inStart;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (SearchQueueElement *)getMySearchQueue
{
    return &myQueue;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (NSDictionary *)getMySearchQueueParams
{
    return myQueue.params;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (NSString *)getMySearchQueueLocationString
{
    return myQueue.locationText;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (BOOL)getMySearchQueueFindLocationFirst
{
    return myQueue.findLocationFirst;
}

/***************************************************************\**
 \brief 
 \returns 
 *****************************************************************/
- (BOOL)getMySearchQueueStartSearch
{
    return myQueue.startSearch;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)dealloc
{
    [myQueue.params release];
    [formatPopover release];
    [[BMLTAppDelegate getBMLTAppDelegate] deleteMeetingSearch];
    [myModalView release];
    [mainButton release];
    [super dealloc];
}

#pragma mark - View Lifecycle -

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)viewDidLoad
{
    [self setBlueBackground];
    [super viewDidLoad];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)didReceiveMemoryWarning
{
#ifdef DEBUG
    NSLog(@"A_SearchController didReceiveMemoryWarning -My brain is full");
#endif
    [self abortSearch];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)viewDidAppear:(BOOL)animated
{
    [self checkForSearch];
    [super viewDidAppear:animated];
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

#pragma mark - SearchDelegate Functions -

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)abortSearch
{
    [[BMLTAppDelegate getBMLTAppDelegate] deleteMeetingSearch];
    
    [self stopAnimation];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setUpSearch:(NSDictionary *)inSearchParams
{    
#ifdef DEBUG
    NSLog(@"Allocating A New Search");
#endif
    
    [[BMLTAppDelegate getBMLTAppDelegate] deleteMeetingSearch];
    [[BMLTAppDelegate getBMLTAppDelegate] getMeetingSearch:YES withParams:inSearchParams];
    
    if ( [[BMLTAppDelegate getBMLTAppDelegate] getMeetingSearch:NO withParams:nil] )
        {
        [[[BMLTAppDelegate getBMLTAppDelegate] getMeetingSearch:NO withParams:nil] setDelegate:self];
        }
#ifdef DEBUG
    else
        {
        NSLog(@"ERROR: No Current search allocated!");
        }
#endif
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)executeSearch
{
    [[BMLTAppDelegate getBMLTAppDelegate] resetNavigationControllers];
    [[[BMLTAppDelegate getBMLTAppDelegate] getMeetingSearch:NO withParams:nil] doSearch];
}

/***************************************************************\**
 \brief 
 *****************************************************************/

- (void)executeSearchWithParams:(NSDictionary *)inSearchParams
{
    [self setUpSearch:inSearchParams];
    [self executeSearch];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)searchCompleteWithError:(NSError *)inError
{
#ifdef DEBUG
    NSLog(@"A_SearchController searchCompleteWithError Search Complete With %@", (inError ? [inError description] : @"No Errors"));
#endif
    if ( inError )
        {
        [self displaySearchError:inError];
        [self clearSearch];
        }
    else
        {
        [[BMLTAppDelegate getBMLTAppDelegate] validateSearches];
        [self setSearchResults:[[[BMLTAppDelegate getBMLTAppDelegate] getMeetingSearch:NO withParams:nil] getSearchResults]];
        [[BMLTAppDelegate getBMLTAppDelegate] deleteMeetingSearch];
        [self displaySearchResults:[self getSearchResults]];
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setSearchResults:(NSArray *)inResults
{
    [[BMLTAppDelegate getBMLTAppDelegate] setSearchResults:inResults];
}

/***************************************************************\**
 \brief 
 \returns   
 *****************************************************************/
- (NSArray *)getSearchResults
{
    return [[BMLTAppDelegate getBMLTAppDelegate] getSearchResults];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (A_BMLT_Search *)getSearch
{
    return [[BMLTAppDelegate getBMLTAppDelegate] getMeetingSearch:NO withParams:nil];
}

#pragma mark - Custom Functions -

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setBarButton:(BOOL)show
{
    if ( [self getSearchResults] || show )
        {
        UIBarButtonItem *barButtonItem = [[self navigationItem] leftBarButtonItem];
        
        if ( !barButtonItem )
            {
            barButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"CLEAR-SEARCH-BUTTON", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clearSearch)];
            
            [[self navigationItem] setLeftBarButtonItem:barButtonItem];
            [barButtonItem release];
            }
        }
    else
        {
        [[self navigationItem] setLeftBarButtonItem:nil animated:YES];
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setVisualElementsForSearch
{
    if ( [self view] && !mainButton && ![self getSearchResults] )
        {
        mainButton = [[BeanieButton alloc] initAsList:[self isKindOfClass:[ListViewController class]]];
        CGRect  myFrame = [[self view] bounds];
        CGRect  buttonFrame = [mainButton bounds];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad)
            {
            buttonFrame.size.width = buttonFrame.size.height = (buttonFrame.size.width * 2) / 3;
            }
        
        buttonFrame.origin.x = (myFrame.size.width - buttonFrame.size.width)/2;
        buttonFrame.origin.y = (myFrame.size.height - buttonFrame.size.height)/2;
        
        [mainButton setFrame:buttonFrame];
        
        [mainButton addTarget:self action:@selector(beanieButtonHit:) forControlEvents:UIControlEventTouchUpInside];
        
        [mainButton setEnabled:NO];
        
        [mainButton setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleLeftMargin];
        
        [[self view] addSubview:mainButton];
        }
    
    [[BMLTAppDelegate getBMLTAppDelegate] validateSearches];
    
    [self setBarButton:NO];
    if ( [self getMySearchQueueFindLocationFirst] || [self getMySearchQueueStartSearch] )
        {
        [self startAnimation];
        [[BMLTAppDelegate getBMLTAppDelegate] disableMapNewSearch];
        [[BMLTAppDelegate getBMLTAppDelegate] disableListNewSearch];
        [self enableCenterButton:NO];
        }
    else
        {
        if ( [self getSearchResults] )
            {
            [self enableCenterButton:NO];
            }
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)checkForSearch
{
    if ( [self getMySearchQueueFindLocationFirst] )
        {
        [self setMySearchQueueFindLocationFirst:NO];
        [self setMySearchQueueStartSearch:NO];
        [self findLocation];
        }
    else
        {
        if ( [self getMySearchQueueStartSearch] )
            {
            [self setMySearchQueueFindLocationFirst:NO];
            [self setMySearchQueueStartSearch:NO];
            [self executeSearchWithParams:[self getMySearchQueueParams]];
            }
        }
}

/***************************************************************\**
 \brief This applies the "Beanie Background" to the results view.
 *****************************************************************/
- (void)setBlueBackground
{
    [[[self view] layer] setContentsGravity:kCAGravityResizeAspectFill];
    [[[self view] layer] setBackgroundColor:[[UIColor colorWithWhite:0 alpha:0] CGColor]];
    [[[self view] layer] setContents:(id)[[UIImage imageNamed:@"BlueBeanie.png"] CGImage]];
}

/***************************************************************\**
 \brief This routine covers the beanie with an animation.
 *****************************************************************/
- (void)startAnimation
{
    if ( !animatedImage )
        {
#ifdef DEBUG
        NSLog(@"A_SearchController startAnimation creating animation.");
#endif
        animatedImage = [[Animated_BMLT_Logo alloc] init];
        CGRect  myBounds = [[self view] bounds];
        CGRect  animFrame = CGRectZero;

        animFrame.size.width = animFrame.size.height = 200;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            {
            animFrame.size.width = animFrame.size.height = 300;
            }
        
        double  newX = (myBounds.size.width - animFrame.size.width) / 2.0;
        double  newY = (myBounds.size.height - animFrame.size.height) / 2.0;
        
        animFrame.origin.x = newX;
        animFrame.origin.y = newY;
        
        animFrame = CGRectOffset ( animFrame, (animFrame.size.width / 36), (animFrame.size.width / 18) );
        
        [animatedImage setFrame:animFrame];
        
        [[self view] addSubview:animatedImage];
        [animatedImage startTurning];
        }
}

/***************************************************************\**
 \brief This routine stops the animation.
 *****************************************************************/
- (void)stopAnimation
{
    if ( animatedImage )
        {
#ifdef DEBUG
        NSLog(@"A_SearchController stopAnimation stopping animation.");
#endif
        [animatedImage removeFromSuperview];
        animatedImage = nil;
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)findLocation
{
    [self searchAtLocation:[[BMLTAppDelegate getBMLTAppDelegate] getWhereImAt].coordinate];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)searchAtLocation:(CLLocationCoordinate2D)inCoords;
{
    NSMutableDictionary *myParams = [[NSMutableDictionary alloc] initWithDictionary:[self getMySearchQueueParams] copyItems:NO];
    
    if ( myParams )
        {
        [myParams setObject:[NSString stringWithFormat:@"%f", inCoords.longitude] forKey:@"long_val"];
        [myParams setObject:[NSString stringWithFormat:@"%f", inCoords.latitude] forKey:@"lat_val"];
        [myParams setObject:[NSString stringWithFormat:@"%d", -10] forKey:@"geo_width"];
        [self setMySearchQueueParams:myParams];
        [myParams release];
        }
    
    [self setMySearchQueueStartSearch:YES];
    [self checkForSearch];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)setMySearchSetup:(SpecifyNewSearchViewController *)inSetup
{
    mySearchSetup = inSetup;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)displayFormatDetail:(id)inSender
{
    BMLT_FormatButton   *myButton = (BMLT_FormatButton *)inSender;
    BMLT_Format         *myFormat = [myButton getMyFormat];
    CGRect              selectRect = [myButton frame];
#ifdef DEBUG
    NSLog(@"Format Button Pressed for %@", [myFormat getKey]);
#endif
    
    myModalView = [[FormatDetailView alloc] initWithFormat:myFormat andController:self];
    
    if ( myModalView )
        {
        if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) && !CGRectIsEmpty(selectRect))
            {
            UIView  *myContext = [myButton superview];
            formatPopover = [[UIPopoverController alloc] initWithContentViewController:myModalView];
            
            [formatPopover setDelegate:self];
            
            [formatPopover presentPopoverFromRect:selectRect
                                           inView:myContext
                         permittedArrowDirections:UIPopoverArrowDirectionAny
                                         animated:YES];
            }
        else
            {
            [self presentModalViewController:myModalView animated:YES];
            }
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)closeModal
{
    if (formatPopover)
        {
        [formatPopover dismissPopoverAnimated:YES];
        [formatPopover release];
        formatPopover = nil;
        }
    else
        {
        [self dismissModalViewControllerAnimated:YES];
        }
    
    [myModalView release];
    myModalView = nil;
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)viewMeetingDetails:(BMLT_Meeting *)inMeeting
{
    MeetingDetailViewController *meetingDetails = [[MeetingDetailViewController alloc] init];
    [meetingDetails setMyMeeting:inMeeting];
    [meetingDetails setMyModalController:self];
    [[meetingDetails navigationItem] setTitle:[inMeeting getBMLTName]];
    [[[meetingDetails navigationItem] titleView] sizeToFit];
    [[self navigationController] pushViewController:meetingDetails animated:YES];
    [meetingDetails release];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)viewMeetingList:(NSArray *)inList
{
    ListViewBaseController  *listController = [[ListViewBaseController alloc] init];
    if ( listController )
        {
        [listController displayListOfMeetings:inList];
        if ( [self isKindOfClass:[MapViewController class]] )
            {
            UISwipeGestureRecognizer    *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBack:)];
            [gestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
            [[listController view] addGestureRecognizer:gestureRecognizer];
            [gestureRecognizer release];
            }
        [[self navigationController] pushViewController:listController animated:YES];
        [listController release];
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)beanieButtonHit:(id)sender
{
    [self newSearch];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)specifyNewSearch:(id)sender
{
    [self newSearch];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)enableCenterButton:(BOOL)isEnabled
{
    [mainButton setEnabled:isEnabled];
    [mainButton setNeedsDisplay];
}

/***************************************************************\**
 \brief Clears the previous search results.
 *****************************************************************/
- (void)clearSearch
{
    [[BMLTAppDelegate getBMLTAppDelegate] clearSearch];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (IBAction)swipeBack:(UIGestureRecognizer *)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - Virtual Functions To be Overridden -
/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)displaySearchResults:(NSArray *)inResults
{
#ifdef DEBUG
    NSLog(@"A_SearchController displaySearchResults Displaying Results");
#endif
    displayedMeetings = inResults;
    
    if ( ![inResults count] )
        {
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NO-SEARCH-RESULTS",nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK-BUTTON",nil) otherButtonTitles:nil];
        [myAlert show];
        [myAlert release];
        [self stopAnimation];
        [self enableCenterButton:YES];
        [self clearSearch];
        }
    else
        {
        [self setBarButton:YES];
        [self enableCenterButton:NO];
        }
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)displaySearchError:(NSError *)inError
{
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"COMM-ERROR",nil) message:[[inError userInfo]objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK-BUTTON",nil) otherButtonTitles:nil];
    
    [myAlert show];
    [myAlert release];
    [self abortSearch];
    [[BMLTAppDelegate getBMLTAppDelegate] clearSearch];
    [self enableCenterButton:YES];
}

/***************************************************************\**
 \brief Clears the previous search results.
 *****************************************************************/
- (void)clearSearchResults
{
    [self setSearchResults:nil];
    [[[BMLTAppDelegate getBMLTAppDelegate] getMeetingSearch:NO withParams:nil] clearSearch];
    [self stopAnimation];
    [self closeModal];
    [[BMLTAppDelegate getBMLTAppDelegate] validateSearches];
    [[BMLTAppDelegate getBMLTAppDelegate] clearMapNeedsRefresh];
    [[BMLTAppDelegate getBMLTAppDelegate] clearListNeedsRefresh];
    [self setVisualElementsForSearch];
}

/***************************************************************\**
 \brief 
 *****************************************************************/
- (void)newSearch
{
}

@end
