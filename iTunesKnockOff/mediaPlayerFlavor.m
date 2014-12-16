//
//  mediaPlayerFlavor.m
//  iTunesKnockOff
//
//  Created by ANUJ DESHMUKH on 12/13/14.
//  Copyright (c) 2014 DESHMUKH. All rights reserved.
//

#import "MediaPlayerFlavor.h"

@implementation MediaPlayerFlavor
+ (BOOL) isShuffleSelected {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([[prefs objectForKey:@"Shuffle"] isEqualToString:@"YES"]) {
        return YES;
    }
    return NO;
}
+ (BOOL) changeShuffleStatus {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([[prefs objectForKey:@"Shuffle"] isEqualToString:@"YES"]) {
        [prefs setObject:@"NO" forKey:@"Shuffle"];
    } else {
        [prefs setObject:@"YES" forKey:@"Shuffle"];
    }
    [prefs synchronize];
    return NO;
}
+ (BOOL) isSRepeatSelected {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([[prefs objectForKey:@"Repeat"] isEqualToString:@"YES"]) {
        return YES;
    }
    return NO;
}
+ (BOOL) changeRepeatStatus {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([[prefs objectForKey:@"Repeat"] isEqualToString:@"YES"]) {
        [prefs setObject:@"NO" forKey:@"Repeat"];
    } else {
        [prefs setObject:@"YES" forKey:@"Repeat"];
    }
    [prefs synchronize];
    return NO;
}
+ (BOOL) setLatestSelectedColumn:(NSString*)column {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:column forKey:@"lastValue"];
    [prefs synchronize];
    return NO;
}
+ (NSString*) getLastSelectedColumn {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs objectForKey:@"lastValue"];
}

+ (BOOL) initMediaFlavor {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (![[prefs objectForKey:@"Repeat"] isEqualToString:@"YES"]) {
        [prefs setObject:@"NO" forKey:@"Shuffle"];
        [prefs setObject:@"NO" forKey:@"Repeat"];
        [prefs setObject:@"Title" forKey:@"Shuffle"];
        [prefs setObject:@"YES" forKey:@"Init"];
        [prefs synchronize];
    }
    
    return YES;
}
@end
