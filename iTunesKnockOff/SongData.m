/*
//  SongData.m
//  AVSimplePlayer
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

#import "SongData.h"





@implementation SongData
@synthesize strSongURL, strTitle, strCreator, strSubject, strDescription, strPublisher, strContributor;
@synthesize strType, strCopyRights, strAlbumName, strAuthor, strArtist, imgAlbum, fileURL, strComment;
@synthesize songAsset;


+(SongData*) initWithSongURL:(NSURL*)urlSong {
    SongData *songData= [[SongData alloc]init];
    songData.fileURL = urlSong;
    songData.strSongURL = [urlSong absoluteString];
    songData.songAsset = [AVAsset assetWithURL:urlSong];
    
    
        // 3
    AudioFileID audioFile;                                        // 4
    OSStatus theErr = noErr;                                      // 5
    theErr = AudioFileOpenURL((__bridge CFURLRef)urlSong,
                              kAudioFileReadPermission,
                              0,
                              &audioFile);                        // 6
    assert (theErr == noErr);                                     // 7
    UInt32 dictionarySize = 0;                                    // 8
    theErr = AudioFileGetPropertyInfo (audioFile,
                                       kAudioFilePropertyInfoDictionary,
                                       &dictionarySize,
                                       0);                        // 9
    assert (theErr == noErr);                                     // 10
    CFDictionaryRef dictionary;                                   // 11
    theErr = AudioFileGetProperty (audioFile,
                                   kAudioFilePropertyInfoDictionary,
                                   &dictionarySize,
                                   &dictionary);                  // 12
    assert (theErr == noErr);                                     // 13
                                       // 15
    theErr = AudioFileClose (audioFile);                          // 16
    assert (theErr == noErr);
    NSDictionary *dict = (__bridge NSDictionary*)dictionary;
     CFRelease (dictionary);
    if ([dict valueForKey:@"year" ]) {
        songData.strYear =[dict valueForKey:@"year" ];
        //NSLog(@"year = %@",songData.strYear);
    }
    if ([dict valueForKey:@"comments" ]) {
        songData.strComment =[dict valueForKey:@"comments" ];
        //NSLog(@"year = %@",songData.strYear);
    }
    NSLog(@"%@",dict);
    for (AVMetadataItem *metadataItem in songData.songAsset.commonMetadata) {
        NSString *key = [metadataItem commonKey];
        NSString *value = [metadataItem stringValue];
                
        CMTime audioDuration = songData.songAsset.duration;
        float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
        songData.strTime = [NSString stringWithFormat:@"%f",audioDurationSeconds];
        int minTotal=audioDurationSeconds/60;
        int secTotal = lroundf(audioDurationSeconds) % 60;
        
        
        songData.strTime = [NSString stringWithFormat:@"%d.%d ",minTotal,secTotal];
        
        
        
        if ([key isEqualToString:@"artwork"]){
            NSImage *img = nil;
            if ([metadataItem.keySpace isEqualToString:AVMetadataKeySpaceiTunes]) {
                img = [[NSImage alloc]initWithData:[metadataItem.value copyWithZone:nil]];
            }
            
            songData.imgAlbum = img;
        }else if ([key isEqualToString:@"title"])  {
            songData.strTitle = [NSString stringWithString:value];
        }else if ([key isEqualToString:@"artist"]) {
            songData.strArtist = [NSString stringWithString:value];
        }else if ([key isEqualToString:@"creator"])  {
            songData.strCreator = [NSString stringWithString:value];
        }else if ([key isEqualToString:@"subject"])  {
            songData.strSubject = [NSString stringWithString:value];
        }else if ([key isEqualToString:@"description"])  {
            songData.strDescription= [NSString stringWithString:value];
        }else if ([key isEqualToString:@"publisher"])  {
            songData.strPublisher = [NSString stringWithString:value];
        }else if ([key isEqualToString:@"contributor"])  {
            songData.strContributor = [NSString stringWithString:value];
        }else if ([key isEqualToString:@"type"])  {
            songData.strType = [NSString stringWithString:value];
        }else if ([key isEqualToString:@"copyrights"])  {
            songData.strCopyRights = [NSString stringWithString:value];
        }else if ([key isEqualToString:@"albumName"])  {
            songData.strAlbumName = [NSString stringWithString:value];
        }else if ([key isEqualToString:@"author"])  {
            songData.strAuthor = [NSString stringWithString:value];
        }else if ([key isEqualToString:@"artist"])  {
            songData.strArtist = [NSString stringWithString:value];
        }
    }
    
    return songData;
    
}
#pragma NSPasteBoard Writting delegates 
- (NSPasteboardWritingOptions)writingOptionsForType:(NSString *)type pasteboard:(NSPasteboard *)pasteboard {
   return [self.fileURL writingOptionsForType:type pasteboard:pasteboard];
}

- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard {
    return [self.fileURL writableTypesForPasteboard:pasteboard];
}

-(id) pasteboardPropertyListForType:(NSString *)type {
    return  [self.fileURL pasteboardPropertyListForType:type];
}

@end
