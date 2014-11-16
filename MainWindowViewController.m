/*
//  MainWindowViewController.m
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

#import "MainWindowViewController.h"
#import "DBManager.h"
@interface MainWindowViewController ()

@end

@implementation MainWindowViewController
@synthesize musicPlayerController = _musicPlayerController;
@synthesize windowController = _windowController;
@synthesize splitView;
- (void)awakeFromNib {
    NSLog(@"awake from nib");
    //custTableView = (CustomDragnDropTableView*) self.tblViewPlaylist;
    [self.tblViewPlaylist.PlayListdelegate self];
    [self.tblViewPlaylist setDoubleAction:@selector(doubleClick:)];
    
    _windowController = [[iTunesWindowController alloc]initWithWindowNibName:@"iTunesWindowController"];

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _musicPlayerController = [[iTunesViewController alloc]initWithNibName:@"iTunesViewController" bundle:nil];
        aryLibraryOutLn = [[NSMutableArray alloc]init];
        [aryLibraryOutLn addObjectsFromArray:[NSArray arrayWithObjects:@"Library",@"Music", @"Playlist", nil]];
        [aryLibraryOutLn addObjectsFromArray:[[DBManager getSharedInstance]getAllPlayListNames]];
        
        self.tblViewPlaylist.headerView.hidden = YES;
        
    }
    return self;
}
- (void)doubleClick: (id)sender {
    arrWindow = [[NSMutableArray alloc]init];
    
    
    if (_windowController) {
       [arrWindow addObject:_windowController];
    }
    _windowController = [[iTunesWindowController alloc]initWithWindowNibName:@"iTunesWindowController"];
    [_windowController showWindow:self];
    [[_windowController window] makeKeyAndOrderFront:self];
    [[_windowController window] orderFrontRegardless];
    NSWindow *window = [_windowController window];
    [window makeKeyAndOrderFront:nil];
    //windowCtrl.viewController.currentController = @"Music";
    [_windowController.viewController initWithPlayList:[aryLibraryOutLn objectAtIndex:[self.tblViewPlaylist selectedRow]]];
    [_musicPlayerController initWithPlayList:@"Music"];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
    [self.tblViewPlaylist selectRowIndexes:indexSet byExtendingSelection:NO];
    
}

- (void)viewDidLoad {
    // Do view setup here.
    [[splitView.subviews objectAtIndex:1] addSubview:_musicPlayerController.view];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
    [self.tblViewPlaylist selectRowIndexes:indexSet byExtendingSelection:NO];
    [_musicPlayerController initWithPlayList:@"Music"];
    
}
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    // how many rows do we have here?
    return aryLibraryOutLn.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    NSTableCellView *result = nil;
    if ([[aryLibraryOutLn objectAtIndex:row]isEqualToString:@"Library"] || [[aryLibraryOutLn objectAtIndex:row]isEqualToString:@"Playlist"]) {
        result = [tableView makeViewWithIdentifier:@"HeaderRow" owner:self];
    }
    else {
        result = [tableView makeViewWithIdentifier:@"Music" owner:self];
    }
   // Item *item = [self.items objectAtIndex:row];
   // result.imageView.image = item.itemIcon;
    result.textField.stringValue = [aryLibraryOutLn objectAtIndex:row];
    NSLog(@"%@",result.textField.stringValue);
    //result = [tableView makeViewWithIdentifier:@"HeaderCell" owner:self];
    //result.textField.objectValue = @"hello";
    return result;
   
}
-(BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row {
    BOOL isGroup = NO;
    // Choose some way to set isGroup to YES or NO depending on your records.
    return isGroup;
}
-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
    
    // row is the selected row
    // tableView is the table view where the selection occured
    [_musicPlayerController initWithPlayList:[aryLibraryOutLn objectAtIndex:row] ];
    return YES;
    
}
- (void)getPlaylistName  {
    NSString *prompt = @"Please enter playlist Name:";
    //NSString *infoText = @"What happens here is...";
    NSString *defaultValue = @"playlist";
    
    NSAlert *alert = [NSAlert alertWithMessageText: prompt
                                     defaultButton:@"Save"
                                   alternateButton:@"Cancel"
                                       otherButton:nil
                         informativeTextWithFormat:@""];
    
    NSTextField *input = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];
    [input setStringValue:defaultValue];
    [alert setAccessoryView:input];
    NSInteger button = [alert runModal];
    if (button == NSAlertDefaultReturn) {
        [input validateEditing];
        NSLog(@"User entered: %@", [input stringValue]);
        if ([[input stringValue] isEqualToString:@""]) {
            NSLog(@"Playlist name can not be a blank value");
            
        }else {
            [[DBManager getSharedInstance]saveSongPlayListName:[input stringValue]];
            [aryLibraryOutLn removeAllObjects];
            [aryLibraryOutLn addObjectsFromArray:[NSArray arrayWithObjects:@"Library",@"Music", @"Playlist", nil]];
            [aryLibraryOutLn addObjectsFromArray:[[DBManager getSharedInstance]getAllPlayListNames]];
            [self.tblViewPlaylist reloadData];
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[aryLibraryOutLn count]-1];
            [self.tblViewPlaylist selectRowIndexes:indexSet byExtendingSelection:NO];
             [_musicPlayerController initWithPlayList:[aryLibraryOutLn lastObject] ];
        }
       
    } else if (button == NSAlertAlternateReturn) {
        NSLog(@"User cancelled");
    } else {
        NSLog(@"bla");
    }
}
- (void)deleteSelectedPlaylist {
    NSAlert *alert = [NSAlert alertWithMessageText: @"Are you sure you want to delete selected playlist?"
                                     defaultButton:@"Ok"
                                   alternateButton:@"Cancel"
                                       otherButton:nil
                         informativeTextWithFormat:@""];
    
   
    NSInteger button = [alert runModal];
    if (button == NSAlertDefaultReturn) {
        NSLog(@"%@",[aryLibraryOutLn objectAtIndex:[self.tblViewPlaylist selectedRow]]);
        if ([[aryLibraryOutLn objectAtIndex:[self.tblViewPlaylist selectedRow]] isNotEqualTo:@"PlayList" ]|| [[aryLibraryOutLn objectAtIndex:[self.tblViewPlaylist selectedRow]] isNotEqualTo:@"Music" ] || [[aryLibraryOutLn objectAtIndex:[self.tblViewPlaylist selectedRow]] isNotEqualTo:@"Library" ]) {
            [[DBManager getSharedInstance]removePlayList:[aryLibraryOutLn objectAtIndex:[self.tblViewPlaylist selectedRow]]];
        }
        
        
        [aryLibraryOutLn removeAllObjects];
        [aryLibraryOutLn addObjectsFromArray:[NSArray arrayWithObjects:@"Library",@"Music", @"Playlist", nil]];
        [aryLibraryOutLn addObjectsFromArray:[[DBManager getSharedInstance]getAllPlayListNames]];
        
        if (arrWindow.count > 0) {
            for (_windowController in arrWindow) {
                [_windowController close];
            }
        }
        [self.tblViewPlaylist reloadData];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
        [self.tblViewPlaylist selectRowIndexes:indexSet byExtendingSelection:NO];
        
        NSLog(@"delete selected song");
        
    }
   
}
- (void)addNewSong {
    NSLog(@"delete selected song");

}
@end

