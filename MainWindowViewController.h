/*
//  MainWindowViewController.h
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
#import "CustomDragnDropTableView.h"
#import "iTunesWindowController.h"
@interface MainWindowViewController : NSViewController<NSOutlineViewDataSource,NSOutlineViewDelegate, NSTableViewDelegate, NSTablePlaylistDelegate> {
    NSMutableArray *aryLibraryOutLn;
    NSMutableArray *arrWindow;
}
@property (nonatomic,strong) IBOutlet NSSplitView *splitView;
@property (strong) iTunesViewController *musicPlayerController;
@property (strong) iTunesWindowController *windowController;
@property (weak) IBOutlet CustomDragnDropTableView *tblViewPlaylist;
- (void)getPlaylistName;
- (void)doubleClick: (id)sender;
@end
