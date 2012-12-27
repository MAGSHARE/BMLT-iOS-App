/**
 \mainpage
 <h1 style="text-align:center">The BMLT iOS App</h1>
 <p>The BMLT iOS App is an app that is designed to work in concert with <a href="http://bmlt.magshare.net/">the BMLT Server System</a>, in assisting those interested in finding NA meetings.</p>
 
 <p>The <a href="http://bmlt.magshare.net/">BMLT</a> (which stands for <strong>B</strong>asic <strong>M</strong>eeting <strong>L</strong>ist <strong>T</strong>oolbox), is a powerful, client-server system, designed to help <a href="http://na.org">NA</a> Service bodies store, edit, and share information about their regularly-scheduled meetings.</p>
 
 <p>It is <a href="http://bmlt.magshare.net/what-is-the-bmlt/hit-parade/">in use in many places around the world</a>. The current version of this app is designed to be "tuned" for specific installations. In the future, we may be able to establish a "broker" server that could help to locate the nearest server.</p>

 <div style="text-align:center">
    <h2>Basic Object Instantiation Diagram</h2>
    <img src="../images/BasicObjectLayout.gif" alt="Diagram of the basic object layout" style="margin-left:auto;margin-right:auto;display:block" />
 </div>
 <p>The diagram above shows an extremely general sequence of how the app operates. Here's the legend (as indicated by the letters):</p>
 <ol style="list-style-type:upper-alpha">
    <li>The main application (BMLTAppDelegate Class) is a <a href="http://en.wikipedia.org/wiki/Singleton_pattern">SINGLETON</a> instance that instantiates a standard <a href="http://developer.apple.com/library/ios/#DOCUMENTATION/UIKit/Reference/UITabBarController_Class/Reference/Reference.html">UITabBarController</a>. This controller handles the four main sections of the app.</li>
    <li>First, we have the Search Tab. This has two subclasses of A_BMLT_SearchViewController that provide the user with either a simple search interface (implemented by the BMLTSimpleSearchViewController class), or</li>
    <li>an advanced search (implemented by the BMLTAdvancedSearchViewController class). The advanced search is "pushed" onto the <a href="http://developer.apple.com/library/ios/#DOCUMENTATION/UIKit/Reference/UINavigationController_Class/Reference/Reference.html#//apple_ref/occ/cl/UINavigationController">UINavigationController</a> for the search tab.</li>
    <li>When a search is started, another view, implemented by the BMLTAnimationScreenViewController class, is pushed on to the visible search screen. This is displayed while the search is under way, and will also remain up if any errors were encountered during the search (such as it not being able to find any meetings).</li>
    <li>The two middle tab bar items are disabled if there are no search results, as their only purpose is to display search results. Both items are controlled by subclasses of A_BMLTSearchResultsViewController. The first item is for displaying the search results as a list. It is implemented by the BMLTDisplayListResultsViewController class, and displays the results in a <a href="http://developer.apple.com/library/ios/#DOCUMENTATION/UIKit/Reference/UITableViewController_Class/Reference/Reference.html#//apple_ref/occ/cl/UITableViewController">UITableViewController</a>.
    <li>Selecting a table row will push a single meeting display page, implemented by the BMLTMeetingDetailViewController class, onto the navbar.</li>
    <li>The Map tab is handled by an instance of BMLTMapResultsViewController, and shows an <a href="http://developer.apple.com/library/ios/#documentation/MapKit/Reference/MKMapView_Class/MKMapView/MKMapView.html">MkMapView</a>, displaying a number of annotations; each representing at least one meeting. If an annotation is blue, then it stands for a single meeting. If it is red, then it stands for multiple meetings.</li>
    <li>If the annotation in the map view is blue, then selecting that annotation will immediately push an instance of BMLTMeetingDetailViewController onto the navbar. This is the same class as used by the list view.</li>
    <li>If the annotation is red (multiple meetings), then an instance of BMLTDisplayListResultsViewController is either displayed in a popover (iPad), or pushed onto the navbar (iPhone). This instance will have a greatly reduced list, showing only those meetings represented by the red annotation.</li>
    <li>Selecting a table row of this short list will push a single meeting display page, implemented by the BMLTMeetingDetailViewController class, onto the navbar.</li>
    <li>Selecting the Settings tab will bring up an instance of BMLTSettingsViewController. This displays a screen that allows the user to select a number of settings and preferences for the app.</li>
    <li>In the case of the iPad, the "about" information will be displayed in the same screen as the settings. In the iPhone, a new screen will be pushed onto the navbar. This screen is controlled by the BMLTAboutViewController class.</li>
 </ol>
 <p>There are many more classes involved. Most will be self-evident in their purpose.</p>
 <h2>Location</h2>
 <p>Since this is a location-based app, and the search is done as a radius around a location, we need to have good control of both the user's current location, and the desired location for the search center (not always the same).</p>
 <p>The search location can be specified in four ways:</p>
 <ol>
    <li>There is a default location. This is specifed by the server settings, and is generally a central or important location in the server's Service area.</li>
    <li>There is the user's current location, as determined by <a href="http://developer.apple.com/library/ios/#documentation/UserExperience/Conceptual/LocationAwarenessPG/Introduction/Introduction.html#//apple_ref/doc/uid/TP40009497-CH1-SW1">the Core Location services</a>.</li>
    <li>There is an address, entered into a text box, and geocoded into a long/lat location.</li>
    <li>On the iPad, the user is presented with an interactive map, and they can move the marker around to specify a search center.</li>
 </ol>
 <p>If the Core Location services are unavailable, then #1 is used for the "user's location." On the iPhone, the simple search will not work, nor will the "near me" search. The user must type in an address. On the iPad, the user also has the choice of manipulating the map.</p>
 <p>On the iPhone, #2 is required for all 3 simple search choices, as well as "near me" in Advanced. On the iPad, the map location (set to #1, by default), is used, so these searches are enabled.</p>
 <p>In all cases, the address can be entered, and the search will take place from there.</p>
 <p>On the iPad, the map will always show where the search will be centered.</p>
 <p>Location is kept by the BMLTAppDelegate instance in two instance properties:</p>
 <ul>
     <li>BMLTAppDelegate::lastLocation<br />This contains the user's location, as determined by the Core Location Services. It is a <a href="http://developer.apple.com/library/ios/#documentation/CoreLocation/Reference/CLLocation_Class/CLLocation/CLLocation.html#//apple_ref/doc/uid/TP40007126">CLLocation</a> object.<br />This object will be nil, if location services are unavailable, or if the user's location has not been determined (the user can choose to not do a lookup upon start).</li>
     <li>BMLTAppDelegate::searchMapMarkerLoc<br />This contains the search center coordinates. It is a <a href="http://developer.apple.com/library/ios/#documentation/CoreLocation/Reference/CoreLocationDataTypesRef/Reference/reference.html">CLLocationCoordinates2D</a> struct.</li>
 </ul>
 <p>When a search is done, and displayed in the map results view, there will be a black marker. This will always display the central location for the search.</p>
 <h1 style="text-align:center;border-bottom:1px solid black">The Project README File:</h1>
 <pre>
 \verbinclude README
 </pre>
*/