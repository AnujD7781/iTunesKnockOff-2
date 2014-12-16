/*
//  NSTableColumnManagerView.h
//  iTunesKnockOff
//
//  Created by ANUJ DESHMUKH on 11/26/14.
//  Copyright (c) 2014 DESHMUKH. All rights reserved.
*/

#import <Cocoa/Cocoa.h>
#import "Column.h"
@protocol NSTableHeaderDelegate;
@interface NSTableColumnManagerView : NSTableHeaderView 


@end
@protocol NSTableHeaderDelegate
@required
- (void)removeClm:(Column*)clm;
- (void)AddClm:(Column*)clm;

@end