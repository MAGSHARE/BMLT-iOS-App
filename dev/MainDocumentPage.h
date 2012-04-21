/**
 \mainpage
 <h1 style="text-align:center">The BMLT iOS App</h1>
 <p>The BMLT iOS App is an app that is designed to work in concert with <a href="http://magshare.org/bmlt">the BMLT Server System</a>, in assisting those interested in finding NA meetings.</p>
 
 <p>The <a href="http://magshare.org/bmlt">BMLT</a> (which stands for <strong>B</strong>asic <strong>M</strong>eeting <strong>L</strong>ist <strong>T</strong>oolbox), is a powerful, client-server system, designed to help <a href="http://na.org">NA</a> Service bodies store, edit, and share information about their regularly-scheduled meetings.</p>
 
 <p>It is <a href="http://magshare.org/bmlt-users">in use in many places around the world</a>. The current version of this app is designed to be "tuned" for specific installations. In the future, we may be able to establish a "broker" server that could help to locate the nearest server.</p>

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
*/