    //
//  DetailViewController.m
//  Balkania
//
//  Created by Momchil Tomov on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

- (Song *)song
{
	return song;
}

- (void)setSong:(Song *)newSong
{
	if (song != newSong)
	{
		[song release];
		[newSong retain];
		song = newSong;
		
		titleLabel.text = song.title;
		artistLabel.text = song.artist;
		if (song.album == (id)[NSNull null] || song.album.length == 0) {
		}
		else {
			albumLabel.text = song.album;
		}
		if (song.year == 0) {
		}
		else {
			yearLabel.text = [NSString stringWithFormat:@"%d", song.year];
		}
		if (song.label == (id)[NSNull null] || song.label.length == 0) {
		}
		else {
			labelLabel.text = song.label;
		}
		if (song.language == (id)[NSNull null] || song.language.length == 0) {
		}
		else {
			languageLabel.text = song.language;
		}
		if (song.info == (id)[NSNull null] || song.info.length == 0) {
		}
		else {
			infoTextView.text = song.info;
		}
	}
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
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
	// doesn't get called... dunno why
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[song release];
    [super dealloc];
}


@end
