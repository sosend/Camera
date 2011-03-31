//
//  ImageCache.m
//  Homepwner
//
//  Created by Lisa Ridley on 3/28/11.
//  Copyright 2011 RoveWorks. All rights reserved.
//

#import "ImageCache.h"

static ImageCache *sharedImageCache;

@implementation ImageCache

#pragma mark -
#pragma mark Initialization
- (id)init {
    self = [super init];
    if (self) {
        dictionary = [[NSMutableDictionary alloc] init];
    }
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(clearCache:)
               name:UIApplicationDidReceiveMemoryWarningNotification
             object:nil];
    return self;
}

+ (ImageCache *)sharedImageCache {
    if(!sharedImageCache) {
        sharedImageCache = [[ImageCache alloc]init];
    }
    return sharedImageCache;
}

+ (id)allocWithZone:(NSZone *)zone {
    if(!sharedImageCache) {
        sharedImageCache = [super allocWithZone:zone];
        return sharedImageCache;
    } else {
        return nil;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (void) release {
    //no op
}
- (void)setImage:(UIImage *)i forKey:(NSString *)s {
    [dictionary setObject:i forKey:s];
    NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:s];
    NSData *d = UIImagePNGRepresentation(i);
    
    [d writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)s {
    UIImage *result = [dictionary objectForKey:s];
    if(!result) {
        NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:s]; 

        result = [UIImage imageWithContentsOfFile:imagePath];
        if(result) {
            [dictionary setObject:result forKey:s];
        } else {
            NSLog(@"Error:  unable to find %@", imagePath);
        }
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)s {
    [dictionary removeObjectForKey:s];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:s]; 

    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

- (void)clearCache:(NSNotification *)note {
    NSLog(@"Calling ImageCache::clearCache:");
    NSLog(@"flushing %d images out of the cache", [dictionary count]);
    [dictionary removeAllObjects];
}
@end
