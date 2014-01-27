//
//  SecondViewController.h
//  Balkania
//
//  Created by Momchil Tomov on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"
#import "Song.h"
#import "SharedData.h"
#import "DetailViewController.h"

@interface SecondViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate>
{
	// search results
	IBOutlet UITableView *resultsTable;
	NSMutableArray *searchResults; // temporary short results	
	NSMutableArray *songs; // last search results; TODO do we even need this?
	
	// search state when switching views
	NSString *savedSearchTerm;
    NSInteger savedScopeButtonIndex;
    BOOL searchWasActive;
	
	// search progress
	UIActivityIndicatorView *daisy;
	NSMutableData *receivedData;
	BOOL isSearching;
	UIColor *originalTableBkCol;
	CGFloat originalTableRowHeight;
	
	// song details
	DetailViewController *details;
}

@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, retain) NSMutableArray *songs;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

@property (nonatomic, retain) UIActivityIndicatorView *daisy;
@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic) BOOL isSearching;
@property (nonatomic, retain) UIColor *originalTableBkCol;
@property (nonatomic) CGFloat originalTableRowHeight;

- (void)handleSearchForTerm:(NSString *)searchTerm;

@end
