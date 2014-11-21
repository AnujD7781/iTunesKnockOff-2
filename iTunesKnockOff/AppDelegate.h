/*
//  AppDelegate.h
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

#import <Cocoa/Cocoa.h>
#import "iTunesViewController.h"
#import "MainWindowViewController.h"
@interface AppDelegate : NSObject <NSApplicationDelegate> 
@property (weak) IBOutlet NSMenuItem *MenuITEM;
@property (weak) IBOutlet NSMenuItem *menuAddSongs;
@property (weak) IBOutlet NSMenuItem *menuDeleteSongs;


@property (nonatomic, retain) iTunesViewController *musicPlayerController;
@property (strong) MainWindowViewController *mainView;
@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSView *customView;
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (weak) IBOutlet NSMenuItem *menuItem;
- (IBAction)menuAddSongs:(id)sender;
- (IBAction)menuDeleteSongs:(id)sender;
- (IBAction)menuAddPlaylist:(id)sender;
- (IBAction)OpenSong:(id)sender;
- (IBAction)menuDeletePlaylist:(id)sender;
- (IBAction)menuOpenInNewWindow:(id)sender;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
- (IBAction)menuPlay:(id)sender;
- (IBAction)menuNext:(id)sender;
- (IBAction)menuPrevious:(id)sender;
- (IBAction)menuIncreaseVol:(id)sender;
- (IBAction)menuDecreaseVol:(id)sender;

- (IBAction)menuMoveToCurrentSong:(id)sender;

@end
