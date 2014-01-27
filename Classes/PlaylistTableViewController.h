//
//  PlaylistTableViewController.h
//  Balkania
//
//  Created by Momchil Tomov on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PlaylistTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *playlistTableView;
}

@end
