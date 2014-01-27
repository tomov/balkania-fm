//
//  NowPlayingViewController.h
//  Balkania
//
//  Created by Momchil Tomov on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import "AudioStreamer.h"
#import <QuartzCore/CoreAnimation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>
#import "SharedData.h"

@interface NowPlayingViewController : UIViewController {
	IBOutlet UILabel *label;
	Song *song;
	NSInteger songIndexInPlaylist;
	
	IBOutlet UIButton *button;
	IBOutlet UIButton *nextSongButton;
	IBOutlet UIView *volumeSlider;
	IBOutlet UILabel *positionLabel;
	IBOutlet UILabel *durationLabel;
	IBOutlet UISlider *progressSlider;
	IBOutlet UISwitch *shuffleSwitch;
	AudioStreamer *streamer;
	NSTimer *progressUpdateTimer;
}

@property (nonatomic, retain) Song *song;
@property NSInteger songIndexInPlaylist;

- (IBAction)buttonPressed:(id)sender;
- (IBAction)nextSongButtonPressed:(id)sender;
- (void)spinButton;
- (void)updateProgress:(NSTimer *)aNotification;
- (IBAction)sliderMoved:(UISlider *)aSlider;

- (void)changeSong;

@end
