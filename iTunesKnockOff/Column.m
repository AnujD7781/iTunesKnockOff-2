//
//  Column.m
//  iTunesKnockOff
//
//  Created by ANUJ DESHMUKH on 11/26/14.
//  Copyright (c) 2014 DESHMUKH. All rights reserved.
//

#import "Column.h"

@implementation Column
+(Column*) initWithColumn:(NSString*)strColumn withState:(BOOL)state {
     Column *clm= [[Column alloc]init];
    clm.strColumn = strColumn;
    clm.State = state;
    return clm;
}
@end
