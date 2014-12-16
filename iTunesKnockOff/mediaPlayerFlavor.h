//
//  mediaPlayerFlavor.h
//  iTunesKnockOff
//
//  Created by ANUJ DESHMUKH on 12/13/14.
//  Copyright (c) 2014 DESHMUKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaPlayerFlavor : NSObject
+ (BOOL) isShuffleSelected;
+ (BOOL) changeShuffleStatus;
+ (BOOL) isSRepeatSelected;
+ (BOOL) changeRepeatStatus;
+ (BOOL) setLatestSelectedColumn:(NSString*)column;
+ (NSString*) getLastSelectedColumn;
+ (BOOL) initMediaFlavor;
+ (BOOL) isInitDone;

@end
