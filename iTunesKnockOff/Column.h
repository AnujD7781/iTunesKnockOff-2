//
//  Column.h
//  iTunesKnockOff
//
//  Created by ANUJ DESHMUKH on 11/26/14.
//  Copyright (c) 2014 DESHMUKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Column : NSObject
@property (nonatomic,retain) NSString * strColumn;
@property (assign) BOOL State;
+(Column*) initWithColumn:(NSString*)strColumn withState:(BOOL)state;
@end
