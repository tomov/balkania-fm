//
//  DetailViewController.h
//  Balkania
//
//  Created by Momchil Tomov on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import "SharedData.h"


@interface DetailViewController : UIViewController {
	IBOutlet UILabel *titleLabel;
	IBOutlet UILabel *artistLabel;
	IBOutlet UILabel *yearLabel;
	IBOutlet UILabel *albumLabel;
	IBOutlet UILabel *labelLabel;
	IBOutlet UILabel *languageLabel;
	IBOutlet UITextView *infoTextView;
	
	Song *song;	
}

@property (nonatomic, retain) Song *song;

@end
