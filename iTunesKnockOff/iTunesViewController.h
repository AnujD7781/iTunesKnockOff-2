/*
  iTunesViewController.h
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

#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SongData.h"
#import "CustomDrangNDropView.h"
#import "NSArrayHelper.h"

@class AVAudioPlayer, AVPlayerLayer;
@interface iTunesViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, NSViewDragDelegate>  {
    CustomDrangNDropView *dragDropView;
    IBOutlet NSView *iTunesView;
    BOOL isShuffleChecked ;
  
}
// Control outlets handlers.
@property (strong) NSString *currentController;

// IBOutlets properties for all objects.
@property (weak) IBOutlet NSTextField *lblAlbum;
@property (weak) IBOutlet NSTextField *lblSong;
@property (weak) IBOutlet NSImageView *imgAlbum;
@property (weak) IBOutlet NSTextField *lblTime;
@property (weak) IBOutlet NSTableView *tblViewPlaylist;
@property (nonatomic,strong) IBOutlet NSTableColumn *clmTime;
@property (nonatomic,strong) IBOutlet NSTableColumn *clmTitle;
@property (nonatomic,strong) IBOutlet NSTableColumn *clmAlbum;
@property (nonatomic,strong) IBOutlet NSTableColumn *clmGeners;
@property (nonatomic,strong) IBOutlet NSTableColumn *clmSinger;
@property (nonatomic,strong) IBOutlet NSSlider *timeSlider;
@property (weak) IBOutlet NSSlider *volumeSlider;
@property (weak) IBOutlet NSTextField *lblTimeCurrent;


// Player and player layer object
@property (strong) AVPlayerLayer *playerLayer;
@property (strong) AVAudioPlayer *audioPlayer;


// IBAction for all control actions.
- (IBAction)playTrack:(id)sender;
- (IBAction)pauseTrack:(id)sender;
- (IBAction)rewindTrack:(id)sender;
- (IBAction)fastForwardTrack:(id)sender;
- (IBAction)playNextTrack:(id)sender;
- (IBAction)playPreviousTrack:(id)sender;
- (IBAction)stopTrack:(id)sender;
- (IBAction)addTrackToPlaylist:(id)sender;
- (IBAction)setVolumeFull:(id)sender;
- (IBAction)setVolumeMute:(id)sender;
- (IBAction)setVolumeForPlayer:(id)sender;
- (IBAction)DeleteSongFromTable:(id)sender;


// Handlers and helper functions
- (void) playerHandler:(SongData*)data;
- (IBAction)sliderValue:(id)sender;
-(void) initWithPlayList:(NSString*)playListName;
-(void) openAsongFromLib;
-(void) playSelectedSong:(id)sender;


// Controller veriables
@property (nonatomic,strong) NSMutableArray *aryTracks;
@property (assign) double currentTime;
@property (readonly) double duration;
@property (assign) float volume;
@property (strong) id timeObserverToken;

@end
