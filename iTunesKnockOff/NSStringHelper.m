//
//  NSStringHelper.m
//  iTunesKnockOff
//
//  Created by ANUJ DESHMUKH on 12/14/14.
//  Copyright (c) 2014 DESHMUKH. All rights reserved.
//

#import "NSStringHelper.h"

@implementation NSString (helper)
+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}
@end
