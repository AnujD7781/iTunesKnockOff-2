/*
//  iTunesViewController.m
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

#import "iTunesViewController.h"
#import "SongData.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "DBManager.h"
#import "sqlite3.h"
#import "iTunesWindowController.h"

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
    NSLog(@"awake from nib");
    //custTableView = (CustomDragnDropTableView*) self.tblViewPlaylist;
    [self.tblViewPlaylist reloadData];
    [self.tblViewPlaylist setDoubleAction:@selector(doubleClick:)];
    
}

- (void)doubleClick: (id)sender {
    if (self.tblViewPlaylist.selectedRow != -1) {
        SongData *songData =  [self.aryTracks objectAtIndex:[self.tblViewPlaylist selectedRow]];
        [self playerHandler:songData];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        dragDropView = (CustomDrangNDropView*) self.view;
        [dragDropView setDelegate:self];
        //self.currentController = @"Music";
        
        NSImage *img = [NSImage imageNamed:@"green_Background.jpg"];
        [self.view changeColor:[NSColor colorWithPatternImage:img]];
        
        self.aryTracks = [[NSMutableArray alloc]init];
        
        [self.tblViewPlaylist setDoubleAction:@selector(playSelectedSong:)];
        [self.tblViewPlaylist setDraggingSourceOperationMask:NSDragOperationEvery forLocal:NO];
        [self.tblViewPlaylist reloadData];
        //[self initWithPlayList:@"Music"];
        
    }
    return self;
}
-(void) initWithPlayList:(NSString*)playListName;
{
    self.currentController = playListName;
    [self.aryTracks removeAllObjects];
    NSLog(@"Current View COntroller is : %@",self.currentController);
    if ([self.currentController isEqualToString:@"Music"]) {
        [self.aryTracks addObjectsFromArray:[NSArray arrayWithArray:[[DBManager getSharedInstance]getSongList]]];
    } else {
        [self.aryTracks addObjectsFromArray:[NSArray arrayWithArray:[[DBManager getSharedInstance]getPlaylistFor:self.currentController]]];
    }
    [self.tblViewPlaylist reloadData];
}
-(void) playSelectedSong:(id)sender {
   SongData* songData  = [self.aryTracks objectAtIndex:(int)self.tblViewPlaylist.selectedRow];
    [self playerHandler:songData];
}

#pragma mark player handler delegate
- (IBAction)playTrack:(id)sender {
    //NSLog(@"play");
     self.audioPlayer.rate = 1.0;
    if (self.tblViewPlaylist.selectedRow == -1) {
        [self playerUserInputHandler:0];
    } else {
        [self.audioPlayer play];
    }
    
   
}
- (IBAction)pauseTrack:(id)sender {
    //NSLog(@"pause");
    [self.audioPlayer pause];
}
- (IBAction)rewindTrack:(id)sender {
    //NSLog(@"rewind");
    iTunesWindowController *controllerWindow = [[iTunesWindowController alloc]initWithWindowNibName:@"iTunesWindowController"];
    [controllerWindow showWindow:nil];
    [[controllerWindow window] makeMainWindow];
}
- (IBAction)fastForwardTrack:(id)sender {
    //NSLog(@"fastForward");
    if ([self.audioPlayer respondsToSelector:@selector(setEnableRate:)])
        self.audioPlayer.enableRate = YES;
    if ([self.audioPlayer respondsToSelector:@selector(setRate:)])
        self.audioPlayer.rate = 2.0;
    
    
    NSTimeInterval time = self.audioPlayer.currentTime;
    time += 5.0; // forward 5 secs
    if (time > self.audioPlayer.duration)
    {
        // stop, track skip or whatever you want
    }
    else
        self.audioPlayer.currentTime = time;
        //[self.audioPlayer setRate:self.audioPlayer.rate + 2.0];
	
}
- (IBAction)playNextTrack:(id)sender {
    //NSLog(@"next");
    [self playerUserInputHandler:1];
}
- (IBAction)playPreviousTrack:(id)sender {
    //NSLog(@"prev");
    [self playerUserInputHandler:2];
}
- (IBAction)stopTrack:(id)sender {
    //NSLog(@"stop");
    [self.audioPlayer setCurrentTime:0];
    [self.audioPlayer stop];
}
- (void) sortByClm:(NSString*)sortDiscriptor {
    
    
}
- (IBAction)addTrackToPlaylist:(id)sender {
    //NSLog(@"add");
    NSMutableArray *arrTemp = [[NSMutableArray alloc]init];
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:YES]; // yes if more than one dir is allowed
    [panel setAllowedFileTypes:[NSArray arrayWithObjects:@"mp3",nil]];
    NSInteger clicked = [panel runModal];
    
    if (clicked == NSFileHandlingPanelOKButton) {
        for (NSURL *url in [panel URLs]) {
            // do something with the url here.
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
    
     
    [self.tblViewPlaylist reloadData];
   
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
        songData  = [self.aryTracks objectAtIndex:(int)self.tblViewPlaylist.selectedRow];
        [self playerHandler:songData];
    } else if (idTrack == 2  ){
        NSInteger integer = (NSInteger)self.tblViewPlaylist.selectedRow;
        integer = integer-1;
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:(int)integer];
        [self.tblViewPlaylist selectRowIndexes:indexSet byExtendingSelection:NO];
        songData = nil;
        songData  = [self.aryTracks objectAtIndex:(int)self.tblViewPlaylist.selectedRow];
        [self playerHandler:songData];
    }
}

- (IBAction)DeleteSongFromTable:(id)sender {
    if (self.tblViewPlaylist.selectedRow != -1) {
        
        if ([self.currentController isEqualToString:@"Music"]) {
            [[DBManager getSharedInstance] removeSongFromList:[self.aryTracks objectAtIndex:(int)self.tblViewPlaylist.selectedRow]];
        } else {
            [[DBManager getSharedInstance]removeSong:[self.aryTracks objectAtIndex:(int)self.tblViewPlaylist.selectedRow] fromPlayList:self.currentController];
        }
        
        [self.aryTracks removeObjectAtIndex:(int)self.tblViewPlaylist.selectedRow];
        self.imgAlbum.image = [NSImage imageNamed:@"icons" ];
        [self.lblAlbum setStringValue:@""];
        [self.lblSong setStringValue:@""];
        [self.lblTime setStringValue:@"0.0 -"];
        
        [self.tblViewPlaylist reloadData];
        [self stopTrack:nil];
    }
}

- (void) playerHandler:(SongData*)data {
    
    [self.audioPlayer setRate:1.0];
    
    //NSLog(@"%f",self.audioPlayer.rate);
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
    //NSLog(@"full");
    self.volumeSlider.doubleValue = 1.0;
    [self.audioPlayer setVolume:1.0];
}
- (IBAction)setVolumeMute:(id)sender {
    //NSLog(@"mute");
    self.volumeSlider.doubleValue = 0.0;
    [self.audioPlayer setVolume:0.0];
}
- (IBAction)sliderValue:(id)sender {
    //NSLog(@"//NSLog");
    self.audioPlayer.currentTime = self.timeSlider.doubleValue;
}
- (IBAction)setVolumeForPlayer:(id)sender {
    [self.audioPlayer setVolume:self.volumeSlider.floatValue];
    //self.timeSlider.doubleValue = self.audioPlayer.volume;
    
}
#pragma mark Controller Helper


#pragma mark player helpers
- (void)updateTime:(NSTimer *)timer {
    NSTimeInterval timeLeft = self.audioPlayer.duration - self.audioPlayer.currentTime;
    NSTimeInterval timeTotal = self.audioPlayer.duration;
    //NSLog(@"Player rate =------------------%f  -------------",self.audioPlayer.rate);
    
    // update your UI with timeLeft
//self.lblTime = ;
    
    int min=timeLeft/60;
    int sec = lroundf(timeLeft) % 60;
    
    int minTotal=timeTotal/60;
    int secTotal = lroundf(timeTotal) % 60;
    
    
    [self.lblTime setStringValue:[NSString stringWithFormat:@"%d.%d - %d.%d ", min,sec,minTotal,secTotal]];
    timeSlider.doubleValue = self.audioPlayer.currentTime;
    if (self.audioPlayer.currentTime == self.audioPlayer.duration) {
        [self playNextTrack:nil];
    }
    if (self.audioPlayer.currentTime > self.audioPlayer.duration - 2) {
        [self playNextTrack:self];
    }
}

+ (NSSet *)keyPathsForValuesAffectingVolume
{
	return [NSSet setWithObject:@"player.volume"];
}

#pragma mark NSTableView Delegates for music Player table

- (void)tableView:(NSTableView *)tableView draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation {
    
}
- (id<NSPasteboardWriting>)tableView:(NSTableView *)tableView pasteboardWriterForRow:(NSInteger)row {
    
    SongData *data = [self.aryTracks objectAtIndex:row];
    return data;
}
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    // how many rows do we have here?
    return self.aryTracks.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    // populate each row of our table view with data
    // display a different value depending on each column (as identified in XIB)
    SongData *songData = [self.aryTracks objectAtIndex:row];

    if ([tableColumn.identifier isEqualToString:@"Title"]) {
        return songData.strTitle;
        
    } else
    if ([tableColumn.identifier isEqualToString:@"Year"]) {
        return songData.strYear;
        
    }
    else if ([tableColumn.identifier isEqualToString:@"Comment"]) {
        return songData.strComment;
        
    }
    else
        if ([tableColumn.identifier isEqualToString:@"Time"]) {
        return songData.strTime;
        
    } else if ([tableColumn.identifier isEqualToString:@"Album"]) {
        return songData.strAlbumName;
        
    } else if ([tableColumn.identifier isEqualToString:@"Singer"]) {
        return songData.strArtist;
        
    } else if ([tableColumn.identifier isEqualToString:@"Genres"]) {
        return songData.strType;
        
    }
    return @"";
}
-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
    
    // row is the selected row
    // tableView is the table view where the selection occured
    //SongData* songData  = [self.aryTracks objectAtIndex:(int)row];
    //[self playerHandler:songData];
    return YES;
   
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
    [self.tblViewPlaylist reloadData];

    
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
    [panel setAllowsMultipleSelection:NO]; // yes if more than one dir is allowed
    [panel setAllowedFileTypes:[NSArray arrayWithObjects:@"mp3",nil]];
    NSInteger clicked = [panel runModal];
    
    if (clicked == NSFileHandlingPanelOKButton) {
        for (NSURL *url in [panel URLs]) {
            // do something with the url here.
            NSLog(@"%@",[url absoluteString]);
            SongData *data= [SongData initWithSongURL:url];
            [self playerHandler:data];
        }
        
    }
}
-(void) addSongToPlaylist:(NSString*)playListName {
    if ([self.tblViewPlaylist selectedRow]!=-1) {
        SongData* songData  = [self.aryTracks objectAtIndex:self.tblViewPlaylist.selectedRow];
        NSArray *arr = [NSArray arrayWithObjects:songData, nil];
        [[DBManager getSharedInstance]saveSongInPlayList:arr withName:playListName];
    }
}

@end
