/*
//  CustomDrangNDropView.m
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

#import "CustomDrangNDropView.h"
#import "DBManager.h"
@implementation CustomDrangNDropView
@synthesize background;
@synthesize delegate;
- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    /*------------------------------------------------------
     method that should handle the drop data
     --------------------------------------------------------*/
    NSPasteboard *pboard = [sender draggingPasteboard];
    if ([[pboard types] containsObject:NSURLPboardType]) {
        NSArray *urls = [pboard readObjectsForClasses:@[[NSURL class]] options:nil];
        NSLog(@"URLs are: %@", urls);
         [delegate didReceiveDraggedFilesIntoView:urls];
    }
    
    return YES;
}
-(void) draggingEnded:(id<NSDraggingInfo>)sender {
}

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self registerForDraggedTypes:@[NSColorPboardType, NSFilenamesPboardType]];
        NSLog(@"initWithFrame");
    }
    return self;
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
- (void)drawRect:(NSRect)rect
{
    [background set];
    NSRectFill([self bounds]);
}

- (void)changeColor:(NSColor*) aColor
{
    background = aColor;
}
- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context {
    NSDragOperation *dragopeeratoin;
    return *dragopeeratoin;
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
    [theMenu insertItemWithTitle:@"Add New Song" action:@selector(addNewSong:) keyEquivalent:@"" atIndex:0];
    [theMenu insertItemWithTitle:@"Open a song" action:@selector(openASong:) keyEquivalent:@"" atIndex:0];
    [theMenu insertItemWithTitle:@"Delete Selected Song" action:@selector(deleteSong:) keyEquivalent:@"" atIndex:1];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    [arr addObjectsFromArray:[[DBManager getSharedInstance] getAllPlayListNames]];
    NSMenuItem *mainItem = [[NSMenuItem alloc] init];
    [mainItem setTitle:@"Add to Playlist"];
    NSMenu *submenu = [[NSMenu alloc] init];
    int i=0;
    for (NSString *menuName in arr ) {
        
        NSLog(@"%@",menuName);
        [submenu insertItemWithTitle:menuName action:@selector(addToPlaylist:) keyEquivalent:@"" atIndex:i];
        i++;
        
    }
    
    [mainItem setSubmenu:submenu];
  
    [theMenu addItem:mainItem];
    
    [NSMenu popUpContextMenu:theMenu withEvent:theEvent forView:self];
   
}
- (void) deleteSong : (id) sender {
    NSLog(@"beep");
    [delegate deleteSelectedSong];

    
}
- (void) openASong : (id) sender {
    NSLog(@"Honk");
    [delegate openAsongFromLib];
}
- (void) addNewSong : (id) sender {
     NSLog(@"Honk");
    [delegate addNewSong];
}
-(void) addToPlaylist : (id)sender {
    NSMenu *submenu = (NSMenu*)sender;
    NSLog(@"%@",[submenu title]);
    [delegate addSongToPlaylist:[submenu title]];
    
}
@end
