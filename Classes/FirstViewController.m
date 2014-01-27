//
//  FirstViewController.m
//  Balkania
//
//  Created by Momchil Tomov on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"


@implementation FirstViewController

@synthesize searchResults;
@synthesize searchResultsIndicesInPlaylist;

@synthesize savedSearchTerm, savedScopeButtonIndex, searchWasActive;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Playlist";
	UIBarButtonItem *nowPlayingButton = [[[UIBarButtonItem alloc]
										  initWithTitle:@"Edit"
										  style:UIBarButtonItemStylePlain
										  target:self
										  action:@selector(editPlaylist)]
										 autorelease];
	self.navigationItem.leftBarButtonItem = nowPlayingButton;
	
	//Copy database to the user's phone if needed.
	[Song copyDatabaseIfNeeded];
	//Once the db is copied, get the initial data to display on the screen.
	[SharedData instance].playlist = [Song getPlaylistFromDB];
	
	// restore search term
	if (self.savedSearchTerm) {
		[self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
		[self.searchDisplayController.searchBar setText:self.savedSearchTerm];
	}

	playlistTableView.scrollEnabled = YES;
	// hide search bar
	if ([[[SharedData instance] playlist] count] > 0) {
		[playlistTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
	}
	[playlistTableView reloadData];
	
	// if now playing view dies not exist, create it
	if (player == nil) {
		player = [[NowPlayingViewController alloc] initWithNibName:@"NowPlayingView" bundle:nil];
		// and pass it a reference to playlist so it can know what song to play next
	}
}

// when switching between views
- (void)viewDidAppear:(BOOL)animated
{
	// in case new songs were added
	[playlistTableView reloadData];
}

// click on edit button
- (void)editPlaylist
{
	if (playlistTableView.editing)
	{
		[self setEditing:NO animated:YES];
		[playlistTableView setEditing:NO animated:YES];
		[self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
		[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
	}
	else
	{
		[self setEditing:YES animated:YES];
		[playlistTableView setEditing:YES animated:YES];
		[self.navigationItem.leftBarButtonItem setTitle:@"Done"];
		[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
	}
}


// Determine whether a given row is eligible for reordering or not.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

// Process the row move. This means updating the data model to correct the item indices.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
	  toIndexPath:(NSIndexPath *)toIndexPath {
	Song *song = [[[SharedData instance].playlist objectAtIndex:fromIndexPath.row] retain];
	[[SharedData instance].playlist removeObjectAtIndex:fromIndexPath.row];
	[[SharedData instance].playlist insertObject:song atIndex:toIndexPath.row];
	[song release];
}


// navigate to now playing
- (void)goToNowPlaying
{
	[self.navigationController pushViewController:player animated:YES];	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	[super viewDidUnload];
	self.searchResults = nil;
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	// save search term so we can restore it next time the user opens the view
	self.searchWasActive = [self.searchDisplayController isActive];
	self.savedSearchTerm = [self.searchDisplayController.searchBar text];
	self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
}

- (void)dealloc {
	[savedSearchTerm release];
	[searchResults release];
	[searchResultsIndicesInPlaylist release];
	[player release];
    [super dealloc];
}

/* 
// Table View Data Source Methods
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rowCount;
	
	if (tableView == [[self searchDisplayController] searchResultsTableView]) {
		rowCount = [self.searchResults count];
	}
	else {
		rowCount = [[SharedData instance].playlist count];
	}

	return rowCount;
}

// display cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	NSInteger row = indexPath.row;

	Song *song;
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		song = (Song *)[self.searchResults objectAtIndex:row];
	}
	else {
		song = (Song *)[[SharedData instance].playlist objectAtIndex:row];
	}
	
	static NSString *kCellID = @"cellID";
	UITableViewCell *cell = [tableView
							 dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
									  reuseIdentifier:kCellID] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	cell.textLabel.text = song.title;
	cell.detailTextLabel.text = song.artist;
	return cell;
}

// perform search
- (void)handleSearchForTerm:(NSString *)searchTerm
{
	self.savedSearchTerm = searchTerm;
	
	if (self.searchResults == nil)
	{
		self.searchResults = [[NSMutableArray alloc] init];
		self.searchResultsIndicesInPlaylist = [[NSMutableArray alloc] init];
	}
	
	[self.searchResults removeAllObjects];
	[self.searchResultsIndicesInPlaylist removeAllObjects];
	
	if ([self.savedSearchTerm length] != 0)
	{
		int row = 0;
		for (Song *song in [SharedData instance].playlist)
		{
			BOOL inArtist = ([song.artist rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound);
			BOOL inTitle = ([song.title rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound);
			// TODO make search a little smarter
			if (inArtist || inTitle)
			{
				[self.searchResults addObject:song];
				[self.searchResultsIndicesInPlaylist addObject:[NSNumber numberWithInt:row]];
			}
			row++;
		}
	}
}

// to begin search
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
	[self handleSearchForTerm:searchString];
    
	return YES;
}

// cleanup after search
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
	[self setSavedSearchTerm:nil];

}

// on row select
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row = indexPath.row;
	
	Song *newSong;
	if (tableView == [[self searchDisplayController] searchResultsTableView]) {
		newSong = [self.searchResults objectAtIndex:row];
	}
	else {
		newSong = [[SharedData instance].playlist objectAtIndex:row];
	}
	
	[self goToNowPlaying];
	if (player.song == nil)
	{
		UIBarButtonItem *nowPlayingButton = [[[UIBarButtonItem alloc]
											  initWithTitle:@"Now Playing"
											  style:UIBarButtonItemStylePlain
											  target:self
											  action:@selector(goToNowPlaying)]
											 autorelease];
		self.navigationItem.rightBarButtonItem = nowPlayingButton;
	}
	if (player.song == nil || player.song.url != newSong.url)
	{
		player.song = newSong;
		[player changeSong];
		player.songIndexInPlaylist = row;
	}
}


// on cell swipe
-(void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
}

// on cell delete
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	// If row is deleted, remove it from the list.
	NSInteger row = indexPath.row;
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// delete your data item here
		// Animate the deletion from the table.
		if (tableView == [[self searchDisplayController] searchResultsTableView]) {
			// delete from playlist, and from playlist table
			int rowInPlaylist = [[self.searchResultsIndicesInPlaylist objectAtIndex:row] intValue];
			[[SharedData instance].playlist removeObjectAtIndex:rowInPlaylist];
			[playlistTableView 
			 deleteRowsAtIndexPaths:[NSArray 
									 arrayWithObject:[NSIndexPath indexPathForRow:rowInPlaylist inSection:0]]  // FIXME when adding sections this can't be 0
			 withRowAnimation:NO];
			// delete from search results
			[self.searchResults removeObjectAtIndex:row];
			[self.searchResultsIndicesInPlaylist removeObjectAtIndex:row];
		}
		else {
			[[SharedData instance].playlist removeObjectAtIndex:row];
		}
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		[tableView reloadData];
	}
}


@end
