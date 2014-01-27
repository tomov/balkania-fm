//
//  SharedData.m
//  Balkania
//
//  Created by Momchil Tomov on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SharedData.h"


@implementation SharedData

@synthesize playlist;

static SharedData *instance = nil;

+ (SharedData *)instance
{
	@synchronized(self)
	{
		if (instance == nil)
		{
			instance = [[SharedData alloc] init];
			instance.playlist = [[NSMutableArray alloc] init];
		}
	}
	return instance;
}

- (void)dealloc
{
	[playlist release];
	[super dealloc];
}

@end
