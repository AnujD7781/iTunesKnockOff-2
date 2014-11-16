/*
//  CustomDragnDropTableView.m
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

#import "CustomDragnDropTableView.h"
#import "DBManager.h"
#import "AppDelegate.h"
@implementation CustomDragnDropTableView
@synthesize PlayListdelegate;

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    /*------------------------------------------------------
     method that should handle the drop data
     --------------------------------------------------------*/
    NSURL* fileURL;
    
    //set the image using the best representation we can get from the pasteboard
    //if the drag comes from a file, set the window title to the filename
    fileURL=[NSURL URLFromPasteboard: [sender draggingPasteboard]];
    //[[self window] setTitle: fileURL!=NULL ? [fileURL absoluteString] : @"(no name)"];
    NSLog(@"%@", [fileURL absoluteString]);
    
    
    return YES;
}
-(void) draggingEnded:(id<NSDraggingInfo>)sender {
}

- (void)mouseUp:(NSEvent *)theEvent
{
    if([theEvent clickCount] == 1) {
        NSLog(@"Apple");
        // [model performSelector:@selector(toggleSelectedState) afterDelay:[NSEvent doubleClickInterval]];
    }
    else if([theEvent clickCount] == 2)
    {
        NSLog(@"Apple2");
    }
}

- (void)rightMouseDown:(NSEvent *)theEvent {
    NSLog(@"Apple2");
    NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"Contextual Menu"];
    [theMenu insertItemWithTitle:@"Open in new Window" action:@selector(OpenInNewWindow:) keyEquivalent:@"" atIndex:0];
    [theMenu insertItemWithTitle:@"Delete Selected Playlist" action:@selector(deletePlayList:) keyEquivalent:@"" atIndex:1];
    [NSMenu popUpContextMenu:theMenu withEvent:theEvent forView:self];
}

-(void) OpenInNewWindow :(id) sender {
    AppDelegate *appDelegate = (AppDelegate*) [[NSApplication sharedApplication]delegate];
    [appDelegate menuOpenInNewWindow:nil];
}

- (void) deletePlayList: (id) sender {
    NSLog(@"beep");
    [PlayListdelegate deleteSelectedPlaylist];
    AppDelegate *appDelegate = (AppDelegate*) [[NSApplication sharedApplication]delegate];
    [appDelegate menuDeletePlaylist:nil];
}

-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    NSLog(@"draggingEntered");
    return NSDragOperationEvery;
    
}

-(NSDragOperation) draggingUpdated:(id<NSDraggingInfo>)sender
{
    NSLog(@"draggingUpdated");
    return NSDragOperationEvery;
}
@end
