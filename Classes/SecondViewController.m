    //
//  SecondViewController.m
//  Balkania
//
//  Created by Momchil Tomov on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"



@implementation SecondViewController

@synthesize	searchResults;
@synthesize songs;

@synthesize savedSearchTerm;
@synthesize savedScopeButtonIndex;
@synthesize searchWasActive;

@synthesize daisy;
@synthesize receivedData;
@synthesize isSearching;
@synthesize originalTableBkCol;
@synthesize originalTableRowHeight;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	//Initialize the array.
	/*self.songs = [[NSMutableArray alloc] initWithObjects:
					 [Song songWithArtist:@"Giorgos Mazonakis" 
									title:@"Nikotina" 
									  url:@"http://cpanel-dept-dev-svc.princeton.edu/test/Giorgos Mazonakis - Nikotina.MP3"],
					 [Song songWithArtist:@"Slavi Trifonov i Sofi Marinova" 
									title:@"Edinstveni" 
									  url:@"http://cpanel-dept-dev-svc.princeton.edu/test/Slavi Trifonov i Sofi Marinova - Edinstveni.mp3"],
					 [Song songWithArtist:@"Dire Straits"
									title:@"So Far Away"
									  url:@"http://cpanel-dept-dev-svc.princeton.edu/test/107  Dire Straits - So Far Away.mp3"],
					 [Song songWithArtist:@"Dire Straits"
									title:@"Money For Nothing"
									  url:@"http://cpanel-dept-dev-svc.princeton.edu/test/108  Dire Straits - Money For Nothing.mp3"],
					 [Song songWithArtist:@"Armand Van Helden"
									title:@"My My My"
									  url:@"http://cpanel-dept-dev-svc.princeton.edu/test/Armand Van Helden - My My  My My.mp3"],
					 [Song songWithArtist:@"Def Leppard"
									title:@"Let's Get Rocked"
									  url:@"http://cpanel-dept-dev-svc.princeton.edu/test/Def Leppard - Let's Get Rocked.mp3"],
					 [Song songWithArtist:@"Def Leppard"
									title:@"Pour Some Sugar On Me"
									  url:@"http://cpanel-dept-dev-svc.princeton.edu/test/Def Leppard - Pour Some Sugar On Me.mp3"],
					 [Song songWithArtist:@"Delirium"
									title:@"After All"
									  url:@"http://cpanel-dept-dev-svc.princeton.edu/test/Delerium_-_After_All_(Satoshi_Tomiie_Edit).mp3"],
					 [Song songWithArtist:@"Delirium"
									title:@"Silence"
									  url:@"http://cpanel-dept-dev-svc.princeton.edu/test/Delirium - Silence (Club Mix).mp3"],
					 [Song songWithArtist:@"Dire Straits"
									title:@"Walk Of Life"
									  url:@"http://cpanel-dept-dev-svc.princeton.edu/test/Dire Straits - Walk Of Life.mp3"],
					 [Song songWithArtist:@"Foreigner"
									title:@"Cold As Ice"
									  url:@"http://cpanel-dept-dev-svc.princeton.edu/test/Foreigner - Cold As Ice.mp3"],
					 [Song songWithArtist:@"Foreigner"
									title:@"Urgent"
									  url:@"http://cpanel-dept-dev-svc.princeton.edu/test/Foreigner - Urgent.mp3"],
					 [Song songWithArtist:@"Guns N' Roses"
									title:@"November Rain"
									  url:@"http://cpanel-dept-dev-svc.princeton.edu/test/Guns 'N' Roses - November Rain.mp3"],
					 [Song songWithArtist:@"Toto"
									title:@"Hold The Line"
									  url:@"http://cpanel-dept-dev-svc.princeton.edu/test/Toto - Hold The Line.mp3"],
					 [Song songWithArtist:@"Whitesnake"
									title:@"Here I Go Again"
									  url:@"http://cpanel-dept-dev-svc.princeton.edu/test/Whitesnake - Here I Go Again.mp3"],
					 nil];*/
	self.songs = [[NSMutableArray alloc] init];
	
					 
	//Set the title
	self.navigationItem.title = @"Search Results";
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

	// restore search term
	if (self.savedSearchTerm) {
		[self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
		[self.searchDisplayController.searchBar setText:self.savedSearchTerm];
	}
	
	// save how results table looks for restoring it after dimming
	self.originalTableBkCol = [[[self searchDisplayController] searchResultsTableView] backgroundColor];
	self.originalTableRowHeight = [[[self searchDisplayController] searchResultsTableView] rowHeight];	
	
	// enter editing mode: we can only add songs
	/*[self setEditing:YES animated:YES];
	[resultsTable setEditing:YES animated:YES];
	[resultsTable reloadData];
	[[self.searchDisplayController searchResultsTableView] setEditing:YES animated:YES];*/
	
	// spinning daisy while loading search results
	self.daisy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[self.daisy setCenter:CGPointMake(self.view.center.x, self.view.center.y * 0.7)];
	//[self.daisy startAnimating];
	//[resultsTable bringSubviewToFront:self.daisy];
	[[self.searchDisplayController searchResultsTableView] addSubview:self.daisy];
	//[spinner setCenter:[self.view center]];
	
	// if details view does not exist
	if (details == nil) {
		details = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
		// and pass it a reference to playlist so it can know what song to play next
	}
}


/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */


- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	// save search term so we can restore it next time the user opens the view
	self.searchWasActive = [self.searchDisplayController isActive];
	self.savedSearchTerm = [self.searchDisplayController.searchBar text];
	self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rowCount;
	
	if (tableView == [[self searchDisplayController] searchResultsTableView]) {
		rowCount = [self.searchResults count];
	}
	else {
		rowCount = [self.songs count];
	}
	return rowCount;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row = indexPath.row;
	
	Song *song;	
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		song = (Song *)[self.searchResults objectAtIndex:row];
	}
	else {
		// should never happen?
	}
	
	static NSString *kCellID = @"cellID";
	UITableViewCell *cell = [tableView
							 dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									  reuseIdentifier:kCellID] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	cell.textLabel.text = song.title;
	cell.detailTextLabel.text = song.artist;
	return cell;
}

// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleInsert;
}

// add song
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	// should always be true, but who knows...
	if (editingStyle == UITableViewCellEditingStyleInsert) {
		NSInteger row = indexPath.row;
		[[SharedData instance].playlist addObject:[self.songs objectAtIndex:row]];
		[self.songs removeObjectAtIndex:row];
		[self.searchResults removeObjectAtIndex:row];
		// delete from both tables... fuck
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		//[[[self searchDisplayController] searchResultsTableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		[tableView reloadData];
	}
}

#pragma mark alerts

- (void)showError:(NSString *)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark Search UI

// perform search // TODO irrelevant?
- (void)handleSearchForTerm:(NSString *)searchTerm
{	
	self.savedSearchTerm = searchTerm;
	
	if (self.searchResults == nil)
	{
		self.searchResults = [[NSMutableArray alloc] init];
	}
	
	[self.searchResults removeAllObjects];
	
	if ([self.savedSearchTerm length] != 0)
	{
		for (Song *song in self.songs)
		{
			BOOL inArtist = ([song.artist rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound);
			BOOL inTitle = ([song.title rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound);
			if (inArtist || inTitle)
			{
				[self.searchResults addObject:song];
			}
		}
	}
}

// started typing
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	
}

// to begin search while user is typing...or maybe not
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
	// TODO implement parallel querying
/*	NSArray *results = [self executeSearchQuery: searchString];
	
	if (self.searchResults == nil)
	{
		self.searchResults = [[NSMutableArray alloc] init];
	}
	[self.searchResults removeAllObjects];
	self.searchResults = [[NSMutableArray alloc] init];
	// TODO check if songs are in playlist and don't display them
	// also, add unique ID to songs so we can tell them apart
	for (int i = 0; i < [results count]; i++) {
		NSDictionary *songDictionary = [results objectAtIndex:i];
		Song *song = [[Song alloc] initFromDictionary:songDictionary];
		NSLog(@" song song song %@ ;; /Users/tomov90/Desktop/Screen Shot 2011-10-02 at 11.32.06 AM.png%@", [song toString], [songDictionary objectForKey:@"title"] );
		[self.searchResults addObject:song];
	}
	NSLog(@"  %d count", [self.searchResults count]);	
	*/
	
	//[self executeAsynchronousSearchQuery: searchString];  <-- too complicated to make it work, so do...

	// ...a hack to hide the songs from the previous search while the user is typing
	if ([self.searchResults count] > 0)
	{
		[self.searchResults removeAllObjects];
	}
	
	// make table stay dimmed
    [[[self searchDisplayController] searchResultsTableView] setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.8]];
    [[[self searchDisplayController] searchResultsTableView] setRowHeight:800];

	return YES;
}

// to perform actual search when button is pressed
- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	[self executeAsynchronousSearchQuery: theSearchBar.text];
}


// cleanup after search
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
	[self setSavedSearchTerm:nil];
}

#pragma mark Search logic 

// new search started in the meantime (?) TODO make sure what happens when u actually start 2 searches
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
	
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
	
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
}

// next portion of search results served
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
	[receivedData appendData:data];
}

// search failed
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
	[self stopSearchingEffects];
	
    // inform the user
	[self showError:@"Could not connect to server. Please check your internet connection and try again."];
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

// search results obtained successfully
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
	NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
	NSError *theError = NULL;
	NSArray *results = [[CJSONDeserializer deserializer] deserialize:receivedData error:&theError];
	NSLog(@"++ %@", results);

	if (self.searchResults == nil)
	{
		self.searchResults = [[NSMutableArray alloc] init];
	}
	[self.searchResults removeAllObjects];
	[self.songs removeAllObjects];

	// TODO check if songs are in playlist and don't display them
	// also, add unique ID to songs so we can tell them apart
	for (int i = 0; i < [results count]; i++) {
		NSDictionary *songDictionary = [results objectAtIndex:i];
		Song *song = [[Song alloc] initFromDictionary:songDictionary];
		// to make this bitch work, add to both tables...fuck...this is a quickfix
		[self.searchResults addObject:song];
		[self.songs addObject:song];
		[song release];
	}
	
	// undim table
    [[[self searchDisplayController] searchResultsTableView] setBackgroundColor:self.originalTableBkCol];
    [[[self searchDisplayController] searchResultsTableView] setRowHeight:self.originalTableRowHeight];
	NSLog(@" after: color : %@   row: %@ ", [[[self searchDisplayController] searchResultsTableView] backgroundColor], [[[self searchDisplayController] searchResultsTableView] rowHeight]);
	
	[[[self searchDisplayController] searchResultsTableView] reloadData];
	// for some reason, editing turns off if we press cancel... and restarting it in OnCancelClicked doesn't work
	//[[[self searchDisplayController] searchResultsTableView] setEditing:YES animated:YES];

	// release the connection and the data
	[receivedData release];
    [connection release];
	[self stopSearchingEffects];
}

// execute search query against db
- (void)executeAsynchronousSearchQuery:(NSString *)query
{
	if (self.isSearching) {
		return;
	}
	NSURL *theURL = [NSURL URLWithString:@"http://ec2-50-19-209-186.compute-1.amazonaws.com/search.php"];
	
/*	FFFFFUUUUUUUUUUUUUUUCCCCKKKKKK WHY DOESNT THE GODDAMN FUCKING JSON OBJECT GET PASSED PROPERLY LKSJADFLKJFLKSAJFKLSJDFKLASJFKL;ADFJL;SAJFL;SAJFL;AJSF
	NSArray *keys = [NSArray arrayWithObjects:@"useddfdrname", nil];
	NSArray *objects = [NSArray arrayWithObjects:@"accuser", nil];
	NSDictionary *theRequestDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	NSError *theError = NULL;
	NSData *theBodyData = [[CJSONSerializer serializer] serializeObject:theRequestDictionary error:&theError];
	NSLog(@"-- %@", theBodyData);*/
	
	NSString *theFuckedUpBodyString = [NSString stringWithFormat:@"query=%@", query];
	NSData *theFuckedUpBodyData = [theFuckedUpBodyString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0f];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[theRequest setValue:[NSString stringWithFormat:@"%d", [theFuckedUpBodyData length]] forHTTPHeaderField:@"Content-Length"];	
	[theRequest setHTTPBody: theFuckedUpBodyData];
	
	NSLog(@" query: %@", query);
	[self startSearchingEffects];
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) 
	{
		receivedData = [[NSMutableData data] retain];
	}
	else
	{
		NSLog(@" ns connection failed "); // TODO nice error message to user
	}
}

- (void)startSearchingEffects
{
	self.isSearching = YES;
	[self.daisy startAnimating];
	[[self.searchDisplayController searchResultsTableView] addSubview:self.daisy];
}

- (void)stopSearchingEffects
{
	self.isSearching = NO;
	[self.daisy stopAnimating];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:details animated:YES];
	
	Song *song;
	if (tableView == [[self searchDisplayController] searchResultsTableView]) {
		song = [self.searchResults objectAtIndex:indexPath.row];
	}
	else {
		song = [self.songs objectAtIndex:indexPath.row];
	}
	
	details.song = song;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	[super viewDidUnload];
	self.searchResults = nil;
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[savedSearchTerm release];
	[searchResults release];
	[resultsTable release];
	[songs release];
	[receivedData release];
	[originalTableBkCol release];
	[details release];
    [super dealloc];
}





@end
