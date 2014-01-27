//
//  Song.m
//  Balkania
//
//  Created by Momchil Tomov on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Song.h"


@implementation Song

@synthesize artist, title, album, year, label, language, info;
@synthesize url;
@synthesize index, indexInBigDatabase;

static sqlite3 *database = nil;

+ (NSMutableArray *)getPlaylistFromDB {
	NSString *dbPath = [Song getDBPath];
	NSMutableArray *playlist = [[NSMutableArray alloc] init];
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		const char *sql = "SELECT * FROM Playlist";
		sqlite3_stmt *selectstmt;
		if (sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			while (sqlite3_step(selectstmt) == SQLITE_ROW) {
				
				Song *song = [[Song alloc] init];
				song.index = sqlite3_column_int(selectstmt, 0);
				song.artist = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
				song.title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
				song.url = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)];
				[playlist addObject:song];
				[song release];
			}
		}
		sqlite3_finalize(selectstmt);
	}
	sqlite3_close(database);
	return playlist;
}

+ (void)savePlaylistToDB:(NSMutableArray *)playlist {
														// TODO backup table before erasing! in case of failure...	
	if (sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
		NSString *truncSQL = @"DELETE FROM Playlist";
		NSString *errorMsg;
		if (sqlite3_exec(database, [truncSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			NSLog(@"Error: %s", errorMsg);
			NSLog(truncSQL);
		}
		
		sqlite3_stmt *insertstmt;
		for (Song *song in playlist) {
			const char *sql = "INSERT INTO Playlist(id,artist,title,url) VALUES(?, ?, ?, ?)";
			if(sqlite3_prepare_v2(database, sql, -1, &insertstmt, NULL) != SQLITE_OK) {
				NSAssert1(0, @"Error while creating insert statement. '%s'", sqlite3_errmsg(database));
			}
//			sqlite3_bind_int(insertstmt, 1, song.index);   // TODO store with index in original database!
			sqlite3_bind_text(insertstmt, 2, [song.artist UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(insertstmt, 3, [song.title UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(insertstmt, 4, [song.url UTF8String], -1, SQLITE_TRANSIENT);
			
			if(SQLITE_DONE != sqlite3_step(insertstmt)) {
				NSAssert1(0, @"Error while inserting in. '%s'", sqlite3_errmsg(database));
			}
			
			sqlite3_reset(insertstmt);
		}
		sqlite3_finalize(insertstmt);
	}
	sqlite3_close(database);
}

// copy playlist db to user's phone if needed
// TODO remove the dummy row from the default table god damn it....
+ (void) copyDatabaseIfNeeded {
	
	//Using NSFileManager we can perform many file system operations.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath]; 
	
	if(!success) {
		
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Balkania.sqlite"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success)
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}	
}

// get path to playlist db
+ (NSString *)getDBPath {
	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"Balkania.sqlite"];
}

+ (id)songWithArtist:(NSString *)artist title:(NSString *)title url:(NSString *)url
{
	Song *newSong = [[[self alloc] init] autorelease];
	newSong.artist = artist;
	newSong.title = title;
	newSong.url = url;
	newSong.index = index;
	return newSong;
}

- (id)initWithArtist:(NSString *)artist title:(NSString *)title url:(NSString *)url
{
	[super init];
	self.artist = artist;
	self.title = title;
	self.url = url;
	return self;
}

- (id)initFromDictionary:(NSDictionary *)dict
{
	[super init];
	self.artist = [dict objectForKey:@"artist"];
	self.title = [dict objectForKey:@"title"];
	self.url = [dict objectForKey:@"url"];
	self.indexInBigDatabase = [dict objectForKey:@"id"];
	self.album = [dict objectForKey:@"album"];
	NSString *yearString = (NSString *)[dict objectForKey:@"year"];
	if (yearString != (id)[NSNull null])
	{
		self.year = [yearString integerValue];
	}
	else
	{
		self.year = 0;
	}
	self.label = [dict objectForKey:@"label"];
	self.language = [dict objectForKey:@"language"];
	self.info = [dict objectForKey:@"info"];
	return self;
}

- (NSString *)toString
{
	return [[NSString alloc] initWithFormat:@"%@ - %@", self.artist, self.title]; // !!!! copy retain assign release? autorelease? daaamn
}

- (void)dealloc
{
	[artist release];
	[title release];
	[album release];
	[label release];
	[info release];
	[url release];
	[super dealloc];
}


@end
