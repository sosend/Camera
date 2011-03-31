//
//  Possession.h
//  Homepwner
//
//  Created by Lisa Ridley on 3/28/11.
//  Copyright 2011 RoveWorks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Possession : NSObject <NSCoding> {
    NSString *possessionName;
    NSString *serialNumber;
    NSInteger valueInDollars;
    NSDate *dateCreated;
    NSString *imageKey;
    UIImage *thumbnail;
    NSData *thumbnailData;
}

@property (nonatomic, copy) NSString *possessionName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) NSInteger valueInDollars;
@property (nonatomic, readonly) NSDate *dateCreated;
@property (nonatomic, copy) NSString *imageKey;
@property (readonly) UIImage *thumbnail;

- (id)initWithPossessionName:(NSString *)pName valueInDollars:(NSInteger)value serialNumber:(NSString *)sNumber;
- (id)initWithPossessionName:(NSString *)pName;

+(id)randomPossession;

- (void)setThumbnailDataFromImage:(UIImage *)image;
@end
