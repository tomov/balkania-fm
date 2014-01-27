//
//  Song.h
//  Balkania
//
//  Created by Momchil Tomov on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface Song : NSObject {
	NSString *artist, *title, *album, *label, *language, *info;
	NSInteger year;
	
	NSInteger index;
	NSInteger indexInBigDatabase;
	NSString *url;
}

@property (nonatomic, copy) NSString *artist, *title, *album, *label, *language, *info;
@property NSInteger year;
@property (nonatomic, copy) NSString *url;
@property NSInteger index, indexInBigDatabase;

+ (NSMutableArray *)getPlaylistFromDB:(NSString *)dbPath;
+ (void) finalizeStatements;
+ (id)songWithArtist:(NSString *)artist title:(NSString *)title url:(NSString *)url;
+ (void) copyDatabaseIfNeeded;
+ (NSString *) getDBPath;

- (id)initWithArtist:(NSString *)artist title:(NSString *)title url:(NSString *)url;
- (id)initFromDictionary:(NSDictionary *)dict;
- (NSString *)toString;

@end
