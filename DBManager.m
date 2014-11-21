/*
//  DBManager.m
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

#import "DBManager.h"
static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;
@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB {
    databasePath = [[NSBundle mainBundle]pathForResource:@"iTunesDB" ofType:@"sqlite3"];
    if (sqlite3_open([databasePath UTF8String], &database) != SQLITE_OK) {
        NSLog(@"Failed to open database!");
        return NO;
    }else {
        NSLog(@"DB opened properly");
    }
    return YES;
}
-(BOOL)closeDB {
    databasePath = [[NSBundle mainBundle]pathForResource:@"iTunesDB" ofType:@"sqlite3"];
    if (sqlite3_close(database) != SQLITE_OK) {
        NSLog(@"Failed to close database!");
        return NO;
    }
    return YES;
}

-(NSArray*) getAllPlayListNames {
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    NSString *query = @"SELECT PlayListName from PlayListName";
    sqlite3_stmt *statement;
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
        } else {
            // do things with addStmt, call sqlite3_step
            NSLog(@"its under it");
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueId = sqlite3_column_int(statement, 0);
                char *nameChars = (char *) sqlite3_column_text(statement, 0);
                NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
                [arr addObject:name];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
    
    return arr;
}
-(NSArray*) getSongList {
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    
    NSString *query = @"SELECT URL from songData";
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        NSLog(@"its under it");
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //int uniqueId = sqlite3_column_int(statement, 0);
            char *nameChars = (char *) sqlite3_column_text(statement, 0);
            
            
            NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
            NSURL *url = [NSURL URLWithString:name];
            SongData *data = [SongData initWithSongURL:url];
            [arr addObject:data];
           // NSLog(@"asaasdasd %@ , %@ ,%@ , %@ ",data.strCreator, data.strAuthor, data.strPublisher, data.strTime);
            
        }
        sqlite3_finalize(statement);
    }
        sqlite3_close(database);

    }
    return arr;
    
}
-(NSArray*) getPlaylistFor:(NSString*)playlistName {
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    
    
    NSString *query =[NSString stringWithFormat:@"SELECT SongURL from PlayList where playlistName='%@'",playlistName] ;
    sqlite3_stmt *statement;
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        
        if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
        } else {
            // do things with addStmt, call sqlite3_step
            NSLog(@"its under it");
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueId = sqlite3_column_int(statement, 0);
                char *nameChars = (char *) sqlite3_column_text(statement, 0);
                
                
                NSString *srtURL = [[NSString alloc] initWithUTF8String:nameChars];
                SongData *data = [SongData initWithSongURL:[NSURL URLWithString:srtURL]];
                [arr addObject:data];
                
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
    
    return arr;
}


-(BOOL) saveSongPlayListName:(NSString*)playListName {
    
    NSString *strSql;
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        strSql = @"INSERT INTO PlayListName (ID, PlayListName) VALUES(?,?)";

        if(sqlite3_prepare_v2(database, [strSql UTF8String], -1, &statement, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
        } else {
            // do things with addStmt, call sqlite3_step
            sqlite3_bind_int(statement, 1, 2);
            sqlite3_bind_text(statement, 2, [playListName UTF8String], -1, SQLITE_TRANSIENT);
            // sqlite3_bind_text(statement, 3, [songData.strSongURL UTF8String], -1, SQLITE_TRANSIENT);
            if(SQLITE_DONE != sqlite3_step(statement)) {
                NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
                NSLog(@"Error inserting data");
                return NO;
            }
            else {
                NSLog(@"It worked properly");
                sqlite3_reset(statement);
                statement = nil;
                return YES;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
  
    return NO;
}
-(BOOL) saveSongInPlayList:(NSArray*)arrSongData withName:(NSString*)playListName {
    NSString *strSql;
    NSMutableArray *arrForLibrarySongs= [[NSMutableArray alloc]init];
    for (int i=0; i<[arrSongData count]; i++) {
        SongData *songData = arrSongData[i];
        if (![self isSongPresentInTheLibrary:songData]) {
            [arrForLibrarySongs addObject:songData];
        }
        
    }
    if (arrForLibrarySongs.count > 0) {
       [self saveData:arrForLibrarySongs];
    }
    strSql = @"INSERT INTO PlayList (PlayListID, PlayListName, SongURL) VALUES(?,?,?)";
        if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
        {
            
            if(sqlite3_prepare_v2(database, [strSql UTF8String], -1, &statement, NULL) != SQLITE_OK)
            {
                NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
            } else {
                // do things with addStmt, call sqlite3_step
                int i;
                for (i=0;i<[arrSongData count];i++) {
                    SongData *songData = arrSongData[i];
                sqlite3_bind_int(statement, 1, 2);
                sqlite3_bind_text(statement, 2, [playListName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 3, [songData.strSongURL UTF8String], -1, SQLITE_TRANSIENT);
                    if (sqlite3_step(statement) == SQLITE_DONE) {
                        if (i == (arrSongData.count - 1))
                            sqlite3_finalize(statement);
                        else
                            sqlite3_reset(statement);
                    }
                }
            }
            sqlite3_close(database);
}
    
    return NO;
}
-(BOOL) saveSongDataIntoLibrary:(NSArray*)arySongData {
    // Build the path to the database file
    BOOL saveStatus;
    int i;
    NSString *strSql;
    strSql = @"INSERT INTO songData (Image,Album,Title,Singer,CopyRight,Genre,Creator,SongID,URL,Year) VALUES(?,?,?,?,?,?,?,?,?)";
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        if(sqlite3_prepare_v2(database, [strSql UTF8String], -1, &statement, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
        } else {
            for (i=0;i<arySongData.count ;i++) {
                
                SongData *songData = arySongData[i];
                NSData *imgData = [songData.imgAlbum TIFFRepresentation];
                sqlite3_bind_blob(statement, 1, [imgData bytes], (int)[imgData length], NULL);
                sqlite3_bind_text(statement, 2, [songData.strAlbumName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 3, [songData.strTitle UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 4, [songData.strArtist UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 5, [songData.strCopyRights UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 6, [songData.strType UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 7, [songData.strCreator UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(statement, 8, 2);
                sqlite3_bind_text(statement, 9, [songData.strSongURL UTF8String], -1, SQLITE_TRANSIENT);
                
                
                if (sqlite3_step(statement) == SQLITE_DONE) {
                    if (i == (arySongData.count - 1))
                        sqlite3_finalize(statement);
                    else {
                        saveStatus = YES;
                        sqlite3_reset(statement);
                    }
                }
            }
        }
    }
    
    
    
    return YES;
}
-(BOOL) saveData:(NSArray*)arySongData {
    // Build the path to the database file
    BOOL saveStatus;
    int i;
        NSString *strSql;
            strSql = @"INSERT INTO songData (Image,Album,Title,Singer,CopyRight,Genre,Creator,SongID,URL) VALUES(?,?,?,?,?,?,?,?,?)";
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        if(sqlite3_prepare_v2(database, [strSql UTF8String], -1, &statement, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
        } else {
    for (i=0;i<arySongData.count ;i++) {
        
        SongData *songData = arySongData[i];
        NSData *imgData = [songData.imgAlbum TIFFRepresentation];
        sqlite3_bind_blob(statement, 1, [imgData bytes], (int)[imgData length], NULL);
        sqlite3_bind_text(statement, 2, [songData.strAlbumName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [songData.strTitle UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [songData.strArtist UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 5, [songData.strCopyRights UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 6, [songData.strType UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 7, [songData.strCreator UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 8, 2);
        sqlite3_bind_text(statement, 9, [songData.strSongURL UTF8String], -1, SQLITE_TRANSIENT);
        
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            if (i == (arySongData.count - 1))
                sqlite3_finalize(statement);
            else {
                saveStatus = YES;
                sqlite3_reset(statement);
            }
        }
    }
        }
    }
    
  
    
    return YES;
}


- (BOOL) removeSong:(SongData*)songData fromPlayList:(NSString*)strPlayList {
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        NSString *sql = [NSString stringWithFormat:@"delete from PlayList where SongURL = '%@' and PlayLIstName = '%@'",songData.strSongURL,strPlayList];
                         
                         const char *del_stmt = [sql UTF8String];
                         
                         sqlite3_prepare_v2(database, del_stmt, -1, & statement, NULL);
                         if (sqlite3_step(statement) == SQLITE_DONE)
                         {
                             
                         } else {
                             
                         }
                         sqlite3_finalize(statement);
                         sqlite3_close(database);
                         
                         
                         }
        return NO;
}
- (BOOL) removeSongFromList:(SongData*)songData {
    
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        NSString *sql = [NSString stringWithFormat:@"delete from songData where url = '%@'",songData.strSongURL];
        
        const char *del_stmt = [sql UTF8String];
        
        sqlite3_prepare_v2(database, del_stmt, -1, & statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            
        } else {
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
        
        
    }
    return NO;
}
- (BOOL) removePlayList:(NSString*)playListName {

    
    sqlite3_stmt *statement;
   
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        NSString *sql = [NSString stringWithFormat:@"delete from PlayListName where PlayListName = '%@'",playListName];
        
        const char *del_stmt = [sql UTF8String];
        
        sqlite3_prepare_v2(database, del_stmt, -1, & statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Deleted the song");
        } else {
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
    return NO;
}
-(BOOL)isSongPresentInTheLibrary :(SongData*)song {
    
    BOOL isPresent = NO;
    
  NSString *query = [NSString stringWithFormat:@"SELECT URL from SongData where URL = '%@'",song.strSongURL];
        sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        
        if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
        } else {
            NSLog(@"its under it");
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueId = sqlite3_column_int(statement, 0);
                
                isPresent = YES;
                //[arr addObject:name];
                
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);

    }
    
    return isPresent;
}

@end
