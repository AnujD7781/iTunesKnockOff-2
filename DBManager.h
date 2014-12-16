/*
//  DBManager.h
//  iTunesKnockOff
The MIT License (MIT)
Copyright (c) 2014 Anuj Deshmukh (anuj.deshmukh7@gmail.com & www.linkedin.com/pub/anuj-deshmukh/17/16b/56a/)
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "SongData.h"
#import "Column.h"

@interface DBManager : NSObject {
    NSString *databasePath;
}

+(DBManager*)getSharedInstance;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL createDB;
-(BOOL) saveData:(NSArray*)arySongData;

@property (NS_NONATOMIC_IOSONLY, getter=getSongList, readonly, copy) NSArray *songList;
-(NSArray*) getPlaylistFor:(NSString*)playlistName;
-(NSArray*) getAllColumn;
-(NSArray*) getRecentlyPlayedSongs ;

- (BOOL)changeStateForColumn:(Column*)clm;

- (BOOL) removeSongFromList:(SongData*)songData ;
-(BOOL) saveSongPlayListName:(NSString*)playListName;
-(BOOL) saveSongInPlayList:(NSArray*)arrSongData withName:(NSString*)playListName;
- (BOOL) addRecentlyPlayedSong:(SongData*)songdData;

- (BOOL) removeSong:(SongData*)songData fromPlayList:(NSString*)strPlayList;
- (BOOL) removePlayList:(NSString*)playListName;
- (BOOL) lastSelectedColumn:(Column*)clm forPlayList:(NSString*)playList;

@property (NS_NONATOMIC_IOSONLY, getter=getAllPlayListNames, readonly, copy) NSArray *allPlayListNames;
@end
