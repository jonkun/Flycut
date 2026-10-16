//
//  FlycutClipping.h
//  Flycut
//
//  Flycut by Gennadiy Potapov and contributors. Based on Jumpcut by Steve Cook.
//  Copyright 2011 General Arcade. All rights reserved.
//
//  This code is open-source software subject to the MIT License; see the homepage
//  at <https://github.com/TermiT/Flycut> for details.
//

#import <Foundation/Foundation.h>

@interface FlycutClipping : NSObject {
// What must a clipping hold?
// The text
    NSString * clipContents;
// The text type
    NSString * clipType;
// The display length
    int clipDisplayLength;
// The display string
    NSString * clipDisplayString;
// Does it have a name?
    BOOL clipHasName;
// The app name it came from
    NSString * appLocalizedName;
// The the bunle URL of the app it came from
    NSString * appBundleURL;
// The time
    NSInteger clipTimestamp;
// PNG, JPEG, or GIF bytes when this clipping is an image. Nil for text.
    NSData *clipImageData;
// File name (not a path) of the bytes in Application Support, so history survives relaunch.
    NSString *clipImageFile;
    int imageWidth;
    int imageHeight;
}

-(id) initWithContents:(NSString *)contents withType:(NSString *)type withDisplayLength:(int)displayLength withAppLocalizedName:(NSString *)localizedName withAppBundleURL:(NSString *)bundleURL withTimestamp:(NSInteger)timestamp;
/* -(id) initWithCoder:(NSCoder *)coder;
-(void) decodeWithCoder:(NSCoder *)coder; */
-(NSString *) description;

// set values
-(void) setContents:(NSString *)newContents setDisplayLength:(int)newDisplayLength;
-(void) setContents:(NSString *)newContents;
-(void) setType:(NSString *)newType;
-(void) setDisplayLength:(int)newDisplayLength;
-(void) setHasName:(BOOL)newHasName;

// Retrieve values
-(FlycutClipping *) clipping;
-(NSString *) contents;
-(int) displayLength;
-(NSString *) displayString;
-(NSString *) type;
-(NSString *) appLocalizedName;
-(NSString *) appBundleURL;
-(NSInteger) timestamp;
-(BOOL) hasName;

// Image clippings. Text clippings leave these empty.
-(BOOL)isImage;
-(NSData *)imageData;
-(NSString *)imageFileName;
-(NSString *)imageFileExtension;
-(int)imageWidth;
-(int)imageHeight;
-(void)setImageData:(NSData *)data width:(int)width height:(int)height fileName:(NSString *)fileName;
// Writes imageData into Application Support and records the file name. No-op once a file name is set.
-(BOOL)writeImageToStorage;
// Loads bytes for a file written earlier. Keeps the file name even when the file is missing.
-(void)loadStoredImageFile:(NSString *)fileName width:(int)width height:(int)height;
+(NSString *)imageStorageDirectory;
// Pass nil to delete every stored image file.
+(void)removeStoredImageFilesExcept:(NSSet *)fileNames;

// Additional functions
-(void) resetDisplayString;

@end
