//
//  FirstViewController.h
//  Balkania
//
//  Created by Momchil Tomov on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NowPlayingViewController.h"
#import "Song.h"
#import "SharedData.h"


@interface FirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate>
{
	IBOutlet UITableView *playlistTableView;
	NSMutableArray *searchResults;
	NSMutableArray *searchResultsIndicesInPlaylist;
	
	// saved state of search
	NSString *savedSearchTerm;
    NSInteger savedScopeButtonIndex;
    BOOL searchWasActive;
	
	// now playing
	NowPlayingViewController *player;
}

@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, retain) NSMutableArray *searchResultsIndicesInPlaylist;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

- (void)handleSearchForTerm:(NSString *)searchTerm;

@end
