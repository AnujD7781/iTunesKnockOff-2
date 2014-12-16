/*
//  ArraySortFactory.m
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

#import "ArraySortFactory.h"
#import "SongData.h"
@implementation ArraySortFactory
+(NSArray*) arraySortedArray:(NSArray*)arr {
    NSMutableArray *sortedArray = [[NSMutableArray alloc]init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *clm =[prefs objectForKey:@"lastValue"];
    [prefs synchronize];
    
    if ([clm isEqualToString:@"Time"]) {
        [sortedArray addObjectsFromArray: [arr sortedArrayUsingComparator: ^(SongData *a1, SongData *a2) {
            return [a1.strTime   compare:a2.strTime];
        }]];
    }
    else if ([clm isEqualToString:@"Comment"]) {
        [sortedArray addObjectsFromArray: [arr sortedArrayUsingComparator: ^(SongData *a1, SongData *a2) {
            return [a1.strComment   compare:a2.strComment];
        }]];
    }
    else if ([clm isEqualToString:@"Album"]) {
        [sortedArray addObjectsFromArray: [arr sortedArrayUsingComparator: ^(SongData *a1, SongData *a2) {
            return [a1.strAlbumName   compare:a2.strAlbumName];
        }]];
    }
    else if ([clm isEqualToString:@"Artist"]) {
        [sortedArray addObjectsFromArray: [arr sortedArrayUsingComparator: ^(SongData *a1, SongData *a2) {
            return [a1.strArtist   compare:a2.strArtist];
        }]];
    }
    else if ([clm isEqualToString:@"Year"]) {
        [sortedArray addObjectsFromArray: [arr sortedArrayUsingComparator: ^(SongData *a1, SongData *a2) {
            return [a1.strYear   compare:a2.strYear];
        }]];
    }
    else if ([clm isEqualToString:@"Title"]) {
        [sortedArray addObjectsFromArray: [arr sortedArrayUsingComparator: ^(SongData *a1, SongData *a2) {
            return [a1.strTitle   compare:a2.strTitle];
        }]];    }
    
    else if ([clm isEqualToString:@"Genres"]) {
        [sortedArray addObjectsFromArray: [arr sortedArrayUsingComparator: ^(SongData *a1, SongData *a2) {
            return [a1.strType   compare:a2.strType];
        }]];
    }
    
    return sortedArray;
}
@end
