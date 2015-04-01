/*
//  AppDelegate.m
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

#import "AppDelegate.h"
#import "MainWindowViewController.h"
#import "DBManager.h"
#import "MediaPlayerFlavor.h"

@implementation AppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize musicPlayerController = _musicPlayerController;
@synthesize mainView = _mainView;
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
   NSString *startTime = [formatter stringFromDate:[NSDate date]];
    NSLog(@"%@",startTime);
    
    // Insert code here to initialize your application
    id closeButton = [self.window standardWindowButton:NSWindowCloseButton ];
    [closeButton setAction:@selector(closeapp:)];
    [closeButton setTarget:self];
    
    _mainView = [[MainWindowViewController alloc]init];
    [_MenuITEM setAlternate:YES];
    [_MenuITEM setEnabled:YES];
   
    if ([MediaPlayerFlavor isShuffleSelected]) {
        [self.menuShuffle setState:1];
    }
    if ([MediaPlayerFlavor isSRepeatSelected]) {
        [self.menuRepeat setState:1];
    }
    arrRecentSongs = [[NSMutableArray alloc]init];
    
    [self createRecentlyAddedSongMenu];
    [self.window.contentView addSubview:_mainView.view];
}

- (void) createRecentlyAddedSongMenu {
    [arrRecentSongs removeAllObjects];
    [arrRecentSongs addObjectsFromArray:[[DBManager getSharedInstance] getRecentlyPlayedSongs]];
    
    NSMenu *submenu = [[NSMenu alloc] init];
    int i=0;
    for (SongData *menuName in arrRecentSongs ) {
        
        NSLog(@"%@",menuName);
        [submenu insertItemWithTitle:menuName.strTitle action:@selector(recentSongSelected:) keyEquivalent:@"" atIndex:i];
        i++;
        
    }
    [_menuItemAdd setSubmenu:submenu];
}

- (IBAction)recentSongSelected:(id)sender {
    NSMenu *submenu = (NSMenu*)sender;
    NSLog(@"%@",[submenu title]);
    for (SongData *data in arrRecentSongs) {
        if ([data.strTitle isEqualToString:[submenu title]]) {
            [_mainView.musicPlayerController playerHandler:data];
            break;
        }
    }
    
}
- (void) closeapp: (id)sender {
    [NSApp terminate:self];
}
- (IBAction)menuAddSongs:(id)sender {
   [_mainView.musicPlayerController addTrackToPlaylist:nil];
}
- (IBAction)menuDeleteSongs:(id)sender {
   [_mainView.musicPlayerController DeleteSongFromTable:nil];
    
    
}
- (IBAction)menuAddPlaylist:(id)sender {
    [_mainView getPlaylistName];
}

- (IBAction)OpenSong:(id)sender {
    [_mainView.musicPlayerController openAsongFromLib];
}

- (IBAction)menuDeletePlaylist:(id)sender {
    [_mainView deleteSelectedPlaylist];
}

- (IBAction)menuOpenInNewWindow:(id)sender {
    [_mainView doubleClick:nil];
}
- (IBAction)menuPlay:(id)sender {
    [_mainView.musicPlayerController playTrack:nil];
}

- (IBAction)menuNext:(id)sender {
    [_mainView.musicPlayerController playNextTrack:nil];
}

- (IBAction)menuPrevious:(id)sender {
    [_mainView.musicPlayerController playPreviousTrack:nil];
}

- (IBAction)menuIncreaseVol:(id)sender {
    float vol = _mainView.musicPlayerController.audioPlayer.volume;
    if (vol < 1.0) {
        [_mainView.musicPlayerController.audioPlayer setVolume:vol+0.05];
        _mainView.musicPlayerController.volumeSlider.doubleValue=vol+0.05;
        
    }
}

- (IBAction)menuDecreaseVol:(id)sender {
    float vol = _mainView.musicPlayerController.audioPlayer.volume;
    if (vol > 0.0) {
        [_mainView.musicPlayerController.audioPlayer setVolume:vol-0.05];
        _mainView.musicPlayerController.volumeSlider.doubleValue=vol-0.05;
        
    }
}

- (IBAction)menuMoveToCurrentSong:(id)sender {
    [_mainView.musicPlayerController goToCurrentPlayingSong:nil];
    
}
- (IBAction)shuffleAction:(id)sender {
    [MediaPlayerFlavor changeShuffleStatus];
    if ([MediaPlayerFlavor isShuffleSelected]) {
        [self.menuShuffle setState:1];
    } else {
        [self.menuShuffle setState:0];
    }
}

- (IBAction)repeatAction:(id)sender {
    [MediaPlayerFlavor changeRepeatStatus];
    if ([MediaPlayerFlavor isSRepeatSelected]) {
        [self.menuRepeat setState:1];
    } else {
        [self.menuRepeat setState:0];
    }
}
@end
