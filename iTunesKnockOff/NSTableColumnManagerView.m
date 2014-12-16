/*
//  NSTableColumnManagerView.m
//  iTunesKnockOff
//
//  Created by ANUJ DESHMUKH on 11/26/14.
//  Copyright (c) 2014 DESHMUKH. All rights reserved.
*/

#import "NSTableColumnManagerView.h"
#import "DBManager.h"
#import "AppDelegate.h"
#import "Column.h"
@implementation NSTableColumnManagerView
- (void)mouseUp:(NSEvent *)theEvent
{
    if([theEvent clickCount] == 1) {
        NSLog(@"Apple");
        NSPoint p = [self convertPoint:theEvent.locationInWindow fromView:nil];
        NSInteger selCol = [self columnAtPoint:p];
        NSLog(@"Clicked on header cell is in column: %ld",selCol);
        
    }
    else if([theEvent clickCount] == 2)
    {
        NSLog(@"Apple2");
    }
}

- (void)rightMouseDown:(NSEvent *)theEvent {
    NSArray *arr = [NSArray arrayWithArray:[[DBManager getSharedInstance]getAllColumn]];
    NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"Contextual Menu"];
    
    int i=0;
    for (Column *clm in arr ) {
        
        NSMenuItem *item = [[NSMenuItem alloc]init];
        if (clm.State) {
            [item setState:1];
        } else {
            [item setState:0];
        }
        [item setAction:@selector(addToPlaylist:)];
        [item setTitle:clm.strColumn];
        [theMenu addItem:item];
        i++;
    }
    [NSMenu popUpContextMenu:theMenu withEvent:theEvent forView:self];
    
}
-(void)addToPlaylist:(id)sender {
    NSMenuItem *item = (NSMenuItem*)sender;
    BOOL state;
    if (item.state == 1) {
        state = YES;
    }
    Column *clm = [Column initWithColumn:item.title withState:state];
    [[DBManager getSharedInstance]changeStateForColumn:clm];
    
    
    NSLog(@"%@",[[DBManager getSharedInstance]getAllColumn]);
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"RefreshController"
     object:self];
}

@end
