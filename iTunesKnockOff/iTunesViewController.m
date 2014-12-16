/*
 iTunesViewController.m
 iTunesKnockOff
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

#import "iTunesViewController.h"
#import "SongData.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "DBManager.h"
#import "sqlite3.h"
#import "iTunesWindowController.h"
#import "NSTableColumnManagerView.h"
#import "MediaPlayerFlavor.h"
#import "NSStringHelper.h"
#import "ArraySortFactory.h"

static void *AVSPPlayerItemStatusContext = &AVSPPlayerItemStatusContext;
static void *AVSPPlayerRateContext = &AVSPPlayerRateContext;
static void *AVSPPlayerLayerReadyForDisplay = &AVSPPlayerLayerReadyForDisplay;

@interface iTunesViewController () 
@end

@implementation iTunesViewController
#pragma mark synthesize controller properties
@synthesize timeSlider,currentController;

#pragma mark view and application properties initialization

- (void)awakeFromNib {
    [self reloadTableData];
    [self.tblViewPlaylist setDoubleAction:@selector(doubleClick:)];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dragDropView = (CustomDrangNDropView*) self.view;
        [dragDropView setDelegate:self];
        NSImage *img = [NSImage imageNamed:@"green_Background.jpg"];
        [self.view changeColor:[NSColor colorWithPatternImage:img]];
        
        self.aryTracks = [[NSMutableArray alloc]init];
        
        [self.tblViewPlaylist setDoubleAction:@selector(playSelectedSong:)];
        [self.tblViewPlaylist setDraggingSourceOperationMask:NSDragOperationEvery forLocal:NO];
        [self reloadTableData];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshiTunesViewController)
                                                     name:@"RefreshController"
                                                   object:nil];
        [self refreshiTunesViewController];
        
    }
    return self;
}



-(void) initWithPlayList:(NSString*)playListName {
    self.currentController = playListName;
    [self.aryTracks removeAllObjects];
    
    NSLog(@"Current View COntroller is : %@",self.currentController);
    if ([self.currentController isEqualToString:@"Music"] || self.currentController == nil) {
        [self.aryTracks addObjectsFromArray:[NSArray arrayWithArray:[[DBManager getSharedInstance]getSongList]]];
    } else {
        [self.aryTracks addObjectsFromArray:[NSArray arrayWithArray:[[DBManager getSharedInstance]getPlaylistFor:self.currentController]]];
    }
   
    [self reloadTableData];
}

#pragma mark refresh view controller(table and )
-(void)reloadTableData {
    if (self.tblViewPlaylist.selectedColumn == -1) {
        [MediaPlayerFlavor setLatestSelectedColumn:@"Title"];
    }
    
    NSArray *sortedArray = [ArraySortFactory arraySortedArray:self.aryTracks ];
    [self.aryTracks removeAllObjects];
    [self.aryTracks addObjectsFromArray:sortedArray];
    [self.tblViewPlaylist reloadData];
}

- (void)refreshiTunesViewController {
    [self initWithPlayList:self.currentController];
    NSArray *arrClm = [[DBManager getSharedInstance]getAllColumn];
    for (Column *clm in arrClm) {
        if ([self.tblViewPlaylist columnWithIdentifier:clm.strColumn]!=-1) {
                NSTableColumn *column = [self.tblViewPlaylist.tableColumns objectAtIndex:[self.tblViewPlaylist columnWithIdentifier:clm.strColumn]];
                [self.tblViewPlaylist removeTableColumn: column];
            }
    }
    for (Column *clm in arrClm) {
        if (clm.State) {
            NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:clm.strColumn];
            [[column headerCell] setStringValue:clm.strColumn];
            [self.tblViewPlaylist addTableColumn:column];

        }
    }
    
    [self reloadTableData];
 
}

-(void) playSelectedSong:(id)sender {
   SongData* songData  = (self.aryTracks)[(int)self.tblViewPlaylist.selectedRow];
    [self playerHandler:songData];
}

#pragma mark media player handlers
- (IBAction)playTrack:(id)sender {
     self.audioPlayer.rate = 1.0;
    if (self.tblViewPlaylist.selectedRow == -1) {
        [self playerUserInputHandler:0];
    } else {
        [self.audioPlayer play];
    }
}

- (IBAction)pauseTrack:(id)sender {
    [self.audioPlayer pause];
}

- (IBAction)rewindTrack:(id)sender {
    
}

- (IBAction)fastForwardTrack:(id)sender {
    if ([self.audioPlayer respondsToSelector:@selector(setEnableRate:)])
        self.audioPlayer.enableRate = YES;
    if ([self.audioPlayer respondsToSelector:@selector(setRate:)])
        self.audioPlayer.rate = 2.0;
    NSTimeInterval time = self.audioPlayer.currentTime;
    time += 5.0; // forward 5 secs
    if (time > self.audioPlayer.duration)
    {
    }
    else
        self.audioPlayer.currentTime = time;
}

- (IBAction)playNextTrack:(id)sender {
    if (![MediaPlayerFlavor isShuffleSelected] && ![MediaPlayerFlavor isSRepeatSelected]) {
        [self playerUserInputHandler:1];
    }else {
        if ([MediaPlayerFlavor isShuffleSelected] && ![MediaPlayerFlavor isSRepeatSelected]) {
            
            [self.tblViewPlaylist deselectAll:nil];
            
            NSUInteger index = arc4random()%[self.aryTracks count];
            NSIndexSet *indexSet1 = [NSIndexSet indexSetWithIndex:(int)index];
            [self.tblViewPlaylist selectRowIndexes:indexSet1 byExtendingSelection:YES];
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:(int)index];
            [self.tblViewPlaylist selectRowIndexes:indexSet byExtendingSelection:YES];
            SongData  *randomIndex = (self.aryTracks)[index];
            NSLog(@"%@",randomIndex.strTitle);
            [self playerHandler:randomIndex];
        }
        if (![MediaPlayerFlavor isShuffleSelected] && [MediaPlayerFlavor isSRepeatSelected]) {
            if (self.tblViewPlaylist.selectedRow == -1) {
                NSUInteger index = 1;
                NSIndexSet *indexSet1 = [NSIndexSet indexSetWithIndex:(int)index];
                [self.tblViewPlaylist selectRowIndexes:indexSet1 byExtendingSelection:YES];
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:(int)index];
                [self.tblViewPlaylist selectRowIndexes:indexSet byExtendingSelection:YES];
                SongData  *randomIndex = (self.aryTracks)[index];
                NSLog(@"%@",randomIndex.strTitle);
                [self playerHandler:randomIndex];
            } else {
            NSUInteger index = self.tblViewPlaylist.selectedRow;
            NSIndexSet *indexSet1 = [NSIndexSet indexSetWithIndex:(int)index];
            [self.tblViewPlaylist selectRowIndexes:indexSet1 byExtendingSelection:YES];
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:(int)index];
            [self.tblViewPlaylist selectRowIndexes:indexSet byExtendingSelection:YES];
            SongData  *randomIndex = (self.aryTracks)[index];
            NSLog(@"%@",randomIndex.strTitle);
            [self playerHandler:randomIndex];
            }
        }
    }
    
}

- (IBAction)playPreviousTrack:(id)sender {
    [self playerUserInputHandler:2];
}

- (IBAction)stopTrack:(id)sender {
    [self.audioPlayer setCurrentTime:0];
    [self.audioPlayer stop];
    
}


- (IBAction)addTrackToPlaylist:(id)sender {
    NSMutableArray *arrTemp = [[NSMutableArray alloc]init];
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:YES];
    [panel setAllowedFileTypes:@[@"mp3"]];
    NSInteger clicked = [panel runModal];
    
    if (clicked == NSFileHandlingPanelOKButton) {
        for (NSURL *url in [panel URLs]) {
            NSLog(@"%@",[url absoluteString]);
            SongData *data= [SongData initWithSongURL:url];
            [arrTemp addObject:data];
            
         
        }
        if ([self.currentController isEqualToString:@"Music"]) {
            [[DBManager getSharedInstance]saveData:arrTemp];
        } else {
            [[DBManager getSharedInstance]saveSongInPlayList:arrTemp withName:self.currentController];
        }
    }
    
     
    [self reloadTableData];
}

-(void) playerUserInputHandler:(int)idTrack {
    SongData *songData;
    if (idTrack == 0 && self.aryTracks.count > 0 ) {
        //NSLog(@" no song selected yet");
        if (self.tblViewPlaylist.selectedRow == -1) {
           
           songData  = [self.aryTracks firstObject];
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
            [self.tblViewPlaylist selectRowIndexes:indexSet byExtendingSelection:NO];
            [self playerHandler:songData];
        }
        
    } else if (idTrack == 1 && self.tblViewPlaylist.numberOfRows >= self.tblViewPlaylist.selectedRow ){
        NSInteger integer = 0;
        if (self.tblViewPlaylist.numberOfRows > self.tblViewPlaylist.selectedRow) {
             integer = (NSInteger)self.tblViewPlaylist.selectedRow;
            integer = integer+1;
        }
        NSLog(@"%ld,%ld ",(long)self.tblViewPlaylist.selectedRow , (long)self.tblViewPlaylist.numberOfRows);
        if ( self.tblViewPlaylist.selectedRow+1 == self.tblViewPlaylist.numberOfRows ) {
            integer = (NSInteger)0;
            
        }
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:(int)integer];
        [self.tblViewPlaylist selectRowIndexes:indexSet byExtendingSelection:NO];
        songData = nil;
        songData  = (self.aryTracks)[(int)self.tblViewPlaylist.selectedRow];
        [self playerHandler:songData];
    } else if (idTrack == 2  ){
        NSInteger integer = (NSInteger)self.tblViewPlaylist.selectedRow;
        integer = integer-1;
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:(int)integer];
        [self.tblViewPlaylist selectRowIndexes:indexSet byExtendingSelection:NO];
        songData = nil;
        songData  = (self.aryTracks)[(int)self.tblViewPlaylist.selectedRow];
        [self playerHandler:songData];
    }
}

- (IBAction)DeleteSongFromTable:(id)sender {
    if (self.tblViewPlaylist.selectedRow != -1) {
        
        if ([self.currentController isEqualToString:@"Music"]) {
            [[DBManager getSharedInstance] removeSongFromList:(self.aryTracks)[(int)self.tblViewPlaylist.selectedRow]];
        } else {
            [[DBManager getSharedInstance]removeSong:(self.aryTracks)[(int)self.tblViewPlaylist.selectedRow] fromPlayList:self.currentController];
        }
        
        [self.aryTracks removeObjectAtIndex:(int)self.tblViewPlaylist.selectedRow];
        self.imgAlbum.image = [NSImage imageNamed:@"icons" ];
        [self.lblAlbum setStringValue:@""];
        [self.lblSong setStringValue:@""];
        [self.lblTime setStringValue:@"0.0 -"];
        
        [self reloadTableData];
        [self stopTrack:nil];
    }
}

- (void) playerHandler:(SongData*)data {
    [self.audioPlayer setRate:1.0];
    [self.audioPlayer enableRate];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
        if (data.imgAlbum !=  nil) {
            self.imgAlbum.image = data.imgAlbum;
        } else {
            self.imgAlbum.image = [NSImage imageNamed:@"icons" ];
        }
        [self.lblAlbum setStringValue:data.strAlbumName];
        [self.lblSong setStringValue:data.strTitle];
    
    
        NSURL *urlSong = [NSURL URLWithString:data.strSongURL];
    if (![MediaPlayerFlavor isShuffleSelected]) {
        [[DBManager getSharedInstance]addRecentlyPlayedSong:data];

    }
    
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:urlSong error:nil];
    
        [self.audioPlayer prepareToPlay];
        [self.volumeSlider setMaxValue:1.0];
        [self.volumeSlider setMinValue:0.0];
        self.volumeSlider.doubleValue = 1.0;
        self.timeSlider.maxValue = [self.audioPlayer duration];
        self.timeSlider.doubleValue = 0.0;
    [self.audioPlayer play];
}

- (IBAction)setVolumeFull:(id)sender {
    self.volumeSlider.doubleValue = 1.0;
    [self.audioPlayer setVolume:1.0];
}

- (IBAction)setVolumeMute:(id)sender {
    self.volumeSlider.doubleValue = 0.0;
    [self.audioPlayer setVolume:0.0];
}

- (IBAction)sliderValue:(id)sender {
    if([self.audioPlayer isPlaying]) {
       self.audioPlayer.currentTime = self.timeSlider.doubleValue;
    }
    else {
        self.timeSlider.doubleValue = 0;
    }
    
    
}

- (IBAction)setVolumeForPlayer:(id)sender {
    [self.audioPlayer setVolume:self.volumeSlider.floatValue];
    
}

- (IBAction)goToCurrentPlayingSong:(id)sender {
    NSURL *url = [self.audioPlayer url];
    int i = 0;
    int selectedInt = 0;
    for (i=0; i<[self.aryTracks count]; i++) {
        SongData *songData = [self.aryTracks objectAtIndex:i];
        if([songData.strSongURL isEqualToString:url.absoluteString]) {
            selectedInt = i;
        }
    }
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:selectedInt];
    [self.tblViewPlaylist selectRowIndexes:indexSet byExtendingSelection:NO];
}

#pragma mark Controller Helper
#pragma mark player helpers
- (void)updateTime:(NSTimer *)timer {
    NSTimeInterval timeLeft = self.audioPlayer.duration - self.audioPlayer.currentTime;
    NSTimeInterval timeElapsed=  self.audioPlayer.currentTime;
    [self.lblTimeCurrent setStringValue:[NSString stringFromTimeInterval:timeElapsed]];
    [self.lblTime setStringValue:[NSString stringFromTimeInterval:timeLeft]];
    timeSlider.doubleValue = self.audioPlayer.currentTime;
    if (self.audioPlayer.currentTime == self.audioPlayer.duration) {
        [self playNextTrack:nil];
    }
    if (self.audioPlayer.currentTime > self.audioPlayer.duration - 2) {
        [self playNextTrack:self];
    }
}

+ (NSSet *)keyPathsForValuesAffectingVolume {
	return [NSSet setWithObject:@"player.volume"];
}
#pragma mark NSTableView Delegates for music Player table

- (void)tableView:(NSTableView *)tableView draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation {
    
}

- (id<NSPasteboardWriting>)tableView:(NSTableView *)tableView pasteboardWriterForRow:(NSInteger)row {
    
    SongData *data = (self.aryTracks)[row];
    return data;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.aryTracks.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    SongData *songData = (self.aryTracks)[row];
    if ([tableColumn.identifier isEqualToString:@"Title"]) {
        return songData.strTitle;
    } else if ([tableColumn.identifier isEqualToString:@"Year"]) {
        return songData.strYear;
    } else if ([tableColumn.identifier isEqualToString:@"Comment"]) {
        return songData.strComment;
    } else if ([tableColumn.identifier isEqualToString:@"Time"]) {
        return songData.strTime;
    } else if ([tableColumn.identifier isEqualToString:@"Album"]) {
        return songData.strAlbumName;
    } else if ([tableColumn.identifier isEqualToString:@"Artist"]) {
        return songData.strArtist;
    } else if ([tableColumn.identifier isEqualToString:@"Genres"]) {
        return songData.strType;
    }
    return @"";
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
    return YES;
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectTableColumn:(NSTableColumn *)tableColumn {
    NSLog(@"Here");
    if ([tableColumn.identifier isEqualToString:@"Title"]) {
        [MediaPlayerFlavor setLatestSelectedColumn:@"Title"];
    } else if ([tableColumn.identifier isEqualToString:@"Year"]) {
        [MediaPlayerFlavor setLatestSelectedColumn:@"Year"];
    } else if ([tableColumn.identifier isEqualToString:@"Comment"]) {
        [MediaPlayerFlavor setLatestSelectedColumn:@"Comment"];
    } else if ([tableColumn.identifier isEqualToString:@"Time"]) {
        [MediaPlayerFlavor setLatestSelectedColumn:@"Time"];
    } else if ([tableColumn.identifier isEqualToString:@"Album"]) {
        [MediaPlayerFlavor setLatestSelectedColumn:@"Album"];
    } else if ([tableColumn.identifier isEqualToString:@"Singer"]) {
        [MediaPlayerFlavor setLatestSelectedColumn:@"Singer"];
    } else if ([tableColumn.identifier isEqualToString:@"Genres"]) {
        [MediaPlayerFlavor setLatestSelectedColumn:@"Genres"];
    }
    [self reloadTableData];
    return YES;
}

- (void)doubleClick: (id)sender {
    if (self.tblViewPlaylist.selectedRow != -1) {
        SongData *songData =  (self.aryTracks)[[self.tblViewPlaylist selectedRow]];
        [self playerHandler:songData];
    }
}

#pragma mark NSDragging delegates and datasource handlers
- (void)didReceiveDraggedFilesIntoView:(NSArray*)songURL {
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    for (NSURL *songURLinAry in songURL) {
        SongData *data = [SongData initWithSongURL:songURLinAry];
        [arr addObject:data];
    }
    if ([self.currentController isEqualToString:@"Music"]) {
        [[DBManager getSharedInstance]saveData:arr];
        [self.aryTracks addObjectsFromArray:arr];
    } else {
        [[DBManager getSharedInstance]saveSongInPlayList:arr withName:self.currentController];
        [self.aryTracks addObjectsFromArray:arr];
    }
    [self reloadTableData];
}

- (void)deleteSelectedSong {
    [self DeleteSongFromTable:nil];
}

- (void)addNewSong {
    [self addTrackToPlaylist:nil];
    
}

-(void) openAsongFromLib {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:NO];
    [panel setAllowedFileTypes:@[@"mp3"]];
    NSInteger clicked = [panel runModal];
    
    if (clicked == NSFileHandlingPanelOKButton) {
        for (NSURL *url in [panel URLs]) {
            SongData *data= [SongData initWithSongURL:url];
            [self playerHandler:data];
        }
        
    }
}

-(void) addSongToPlaylist:(NSString*)playListName {
    if ([self.tblViewPlaylist selectedRow]!=-1) {
        SongData* songData  = (self.aryTracks)[self.tblViewPlaylist.selectedRow];
        NSArray *arr = @[songData];
        [[DBManager getSharedInstance]saveSongInPlayList:arr withName:playListName];
    }
    [self refreshiTunesViewController];
}

@end
