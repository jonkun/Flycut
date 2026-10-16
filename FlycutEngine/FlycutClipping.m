//
//  FlycutClipping.m
//  Flycut
//
//  Flycut by Gennadiy Potapov and contributors. Based on Jumpcut by Steve Cook.
//  Copyright 2011 General Arcade. All rights reserved.
//
//  This code is open-source software subject to the MIT License; see the homepage
//  at <https://github.com/TermiT/Flycut> for details.
//


#import "FlycutClipping.h"

@implementation FlycutClipping

-(id) init
{
    [self initWithContents:@""
                  withType:@""
         withDisplayLength:40
      withAppLocalizedName:@""
          withAppBundleURL:nil
             withTimestamp:0];
    return self;
}

-(id) initWithContents:(NSString *)contents withType:(NSString *)type withDisplayLength:(int)displayLength withAppLocalizedName:(NSString *)localizedName withAppBundleURL:(NSString*)bundleURL withTimestamp:(NSInteger)timestamp
{
    [super init];
    clipContents = [[[NSString alloc] init] retain];
    clipDisplayString = [[[NSString alloc] init] retain];
    clipType = [[[NSString alloc] init] retain];

    [self setContents:contents setDisplayLength:displayLength];
    [self setType:type];
    [self setAppLocalizedName:localizedName];
    [self setAppBundleURL:bundleURL];
    [self setTimestamp:timestamp];
    [self setHasName:false];
    
    return self;
}

/* - (id)initWithCoder:(NSCoder *)coder
{
    NSString * newContents;
    int newDisplayLength;
    NSString *newType;
    BOOL newHasName;
    if ( self = [super init]) {
        newContents = [NSString stringWithString:[coder decodeObject]];
        [coder decodeValueOfObjCType:@encode(int) at:&newDisplayLength];
        newType = [NSString stringWithString:[coder decodeObject]];
        [coder decodeValueOfObjCType:@encode(BOOL) at:&newHasName];
        [self 	     setContents:newContents
                setDisplayLength:newDisplayLength];
        [self setType:newType];
        [self setHasName:newHasName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    int codeDisplayLength = [self displayLength];
    BOOL codeHasName = [self hasName];
    [coder encodeObject:[self contents]];
    [coder encodeValueOfObjCType:@encode(int) at:&codeDisplayLength];
    [coder encodeObject:[self type]];
    [coder encodeValueOfObjCType:@encode(BOOL) at:&codeHasName];
} */

-(void) setContents:(NSString *)newContents setDisplayLength:(int)newDisplayLength
{
    id old = clipContents;
    [newContents retain];
    clipContents = newContents;
    [old release];
    if ( newDisplayLength  > 0 ) {
        clipDisplayLength = newDisplayLength;
    }
   [self resetDisplayString];
}

-(void) setContents:(NSString *)newContents
{
    id old = clipContents;
    [newContents retain];
    clipContents = newContents;
    [old release];
    [self resetDisplayString];
}

-(void) setType:(NSString *)newType
{
    id old = clipType;
    [newType retain];
    clipType = newType;
    [old release];
}

-(void) setDisplayLength:(int)newDisplayLength
{
    if ( newDisplayLength > 0 && clipDisplayLength != newDisplayLength ) {
        clipDisplayLength = newDisplayLength;
        [self resetDisplayString];
    }
}

-(void) setAppLocalizedName:(NSString *)new
{
    id old = appLocalizedName;
    [new retain];
    appLocalizedName = new;
    [old release];
}

-(void) setAppBundleURL:(NSString *)new
{
    id old = appBundleURL;
    [new retain];
    appBundleURL = new;
    [old release];
}

-(void) setTimestamp:(NSInteger)newTimestamp
{
    clipTimestamp = newTimestamp;
}

-(void) setHasName:(BOOL)newHasName
{
        clipHasName = newHasName;
}

-(void) resetDisplayString
{
    NSString *newDisplayString, *firstLineOfClipping, *trimmedString;
	NSUInteger start, lineEnd, contentsEnd;
	NSRange startRange = NSMakeRange(0,0);
	NSRange contentsRange;
	// We're resetting the display string, so release the old one.
    [clipDisplayString release];
	// We want to restrict the display string to the clipping contents through the first line break.
    trimmedString = [clipContents stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [trimmedString getLineStart:&start end:&lineEnd contentsEnd:&contentsEnd forRange:startRange];
	contentsRange = NSMakeRange(0, contentsEnd);
	firstLineOfClipping = [trimmedString substringWithRange:contentsRange];
    if ( [firstLineOfClipping length] > clipDisplayLength ) {
        newDisplayString = [[NSString stringWithString:[firstLineOfClipping substringToIndex:clipDisplayLength]] stringByAppendingString:@"…"];   
    } else {
        newDisplayString = [NSString stringWithString:firstLineOfClipping];
    }
    [newDisplayString retain];
    clipDisplayString = newDisplayString;
}

-(NSString *) description
{
    NSString *description = [[super description] stringByAppendingString:@": "];
    description = [description stringByAppendingString:[self displayString]];   
    return description;
}

-(FlycutClipping *) clipping
{
    return self;
}

-(NSString *) contents
{
//    NSString *returnClipContents;
//    returnClipContents = [NSString stringWithString:clipContents];
//    return returnClipContents;
    return clipContents;
}

-(NSString *) appLocalizedName
{
    return appLocalizedName;
}

-(NSString *) appBundleURL
{
    return appBundleURL;
}

-(NSInteger) timestamp
{
    return clipTimestamp;
}

-(int) displayLength
{
    return clipDisplayLength;
}

-(NSString *) type
{
    return clipType;
}

-(NSString *) displayString
{
    // QUESTION
    // Why doesn't the below work?
    // NSString *returnClipDisplayString;
    // returnClipDisplayString = [NSString stringWithString:clipDisplayString];
    // return returnClipDisplayString;
    return clipDisplayString;
}

-(BOOL) hasName
{
    return clipHasName;
}

-(BOOL)isImage
{
    return clipImageData.length > 0;
}

-(NSData *)imageData
{
    return clipImageData;
}

-(NSString *)imageFileName
{
    return clipImageFile;
}

-(NSString *)imageFileExtension
{
    if ([clipType isEqualToString:@"public.jpeg"] || [clipType isEqualToString:@"public.jpg"])
        return @"jpg";
    if ([clipType isEqualToString:@"public.gif"] || [clipType isEqualToString:@"com.compuserve.gif"])
        return @"gif";
    return @"png";
}

-(int)imageWidth
{
    return imageWidth;
}

-(int)imageHeight
{
    return imageHeight;
}

-(void)setImageData:(NSData *)data width:(int)width height:(int)height fileName:(NSString *)fileName
{
    if (data != clipImageData) {
        [data retain];
        [clipImageData release];
        clipImageData = data;
    }
    imageWidth = width;
    imageHeight = height;
    if (fileName != clipImageFile) {
        NSString *safeName = [fileName lastPathComponent];
        [safeName retain];
        [clipImageFile release];
        clipImageFile = safeName;
    }
    [self resetDisplayString];
}

+(NSString *)imageStorageDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *base = [paths count] > 0 ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    return [base stringByAppendingPathComponent:@"Flycut/Images"];
}

-(BOOL)writeImageToStorage
{
    if (clipImageData.length == 0)
        return NO;
    if (clipImageFile.length > 0)
        return YES;

    NSString *directory = [[self class] imageStorageDirectory];
    NSFileManager *files = [NSFileManager defaultManager];
    if (![files createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil])
        return NO;

    NSString *fileName = [NSString stringWithFormat:@"%@.%@", [[NSUUID UUID] UUIDString], [self imageFileExtension]];
    NSString *path = [directory stringByAppendingPathComponent:fileName];
    if (![clipImageData writeToFile:path atomically:YES])
        return NO;

    [fileName retain];
    [clipImageFile release];
    clipImageFile = fileName;
    return YES;
}

-(void)loadStoredImageFile:(NSString *)fileName width:(int)width height:(int)height
{
    NSString *safeName = [fileName lastPathComponent];
    if (safeName.length == 0)
        return;
    NSString *path = [[[self class] imageStorageDirectory] stringByAppendingPathComponent:safeName];
    NSData *data = [NSData dataWithContentsOfFile:path];
    // Keep the file name when the bytes are missing so a later save does not drop the reference.
    [self setImageData:data width:width height:height fileName:safeName];
}

+(void)removeStoredImageFilesExcept:(NSSet *)fileNames
{
    NSString *directory = [self imageStorageDirectory];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:nil];
    NSSet *imageExtensions = [NSSet setWithObjects:@"png", @"jpg", @"jpeg", @"gif", nil];
    for (NSString *file in files) {
        if (fileNames && [fileNames containsObject:file])
            continue;
        if (![imageExtensions containsObject:[[file pathExtension] lowercaseString]])
            continue;
        [[NSFileManager defaultManager] removeItemAtPath:[directory stringByAppendingPathComponent:file] error:nil];
    }
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    FlycutClipping * otherClip = (FlycutClipping *)other;
    BOOL selfIsImage = [self isImage] || clipImageFile.length > 0;
    BOOL otherIsImage = [otherClip isImage] || [otherClip imageFileName].length > 0;
    if (selfIsImage || otherIsImage) {
        if (!selfIsImage || !otherIsImage)
            return NO;
        // Same pixels are the same clip, including a recopy that got a new file name.
        if (clipImageData && [otherClip imageData])
            return [clipImageData isEqualToData:[otherClip imageData]];
        // One side may not have loaded the file (it lives on the machine that copied it).
        if (clipImageFile && [otherClip imageFileName])
            return [clipImageFile isEqualToString:[otherClip imageFileName]];
        return NO;
    }
    return [self.contents isEqualToString:otherClip.contents];
}

- (NSUInteger)hash {
    if (clipImageData)
        return [clipImageData hash];
    if (clipImageFile)
        return [clipImageFile hash];
    return [clipContents hash];
}

-(void) dealloc
{
    [clipContents release];
    [clipType release];
    [appLocalizedName release];
    [appBundleURL release];
    [clipImageData release];
    [clipImageFile release];
    clipDisplayLength = 0;
    [clipDisplayString release];
    clipHasName = 0;
    [super dealloc];
}
@end
