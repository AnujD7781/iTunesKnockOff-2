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
+(NSArray*) arraySortedArray:(NSArray*)arr WithDiscriptor:(NSString*)strDiscriptor {
    NSString *stringDiscriptor;
    NSMutableArray *sortedArray = [[NSMutableArray alloc]init];
    for (SongData *songData in arr) {
        if ([strDiscriptor isEqualToString:@"Time"]) {
            stringDiscriptor = songData.strTime;
        }
        else if ([strDiscriptor isEqualToString:@"Comment"]) {
            stringDiscriptor = songData.strComment;
        }
        else if ([strDiscriptor isEqualToString:@"Album"]) {
            stringDiscriptor = songData.strAlbumName;
        }
        else if ([strDiscriptor isEqualToString:@"Singer"]) {
            stringDiscriptor = songData.strArtist;
        }
        else if ([strDiscriptor isEqualToString:@"Year"]) {
            stringDiscriptor = songData.strYear;
        }
        else if ([strDiscriptor isEqualToString:@"Title"]) {
            stringDiscriptor = songData.strTitle;
        }
        
        else if ([strDiscriptor isEqualToString:@"Genres"]) {
            stringDiscriptor = songData.strType;
        }
        NSDictionary *sortDict = [[NSDictionary alloc]init];
        [sortDict setValue:songData forKey:@"SongData" ];
        [sortDict setValue:stringDiscriptor forKey:@"strDiscriptor" ];
    }
    return sortedArray;
}
@end
