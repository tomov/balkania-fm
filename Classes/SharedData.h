//
//  SharedData.h
//  Balkania
//
//  Created by Momchil Tomov on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SharedData : NSObject {
	NSMutableArray *playlist;
}

@property (nonatomic, retain) NSMutableArray *playlist;

+ (SharedData *)instance;

@end
