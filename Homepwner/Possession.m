//
//  Possession.m
//  Homepwner
//
//  Created by Lisa Ridley on 3/28/11.
//  Copyright 2011 RoveWorks. All rights reserved.
//

#import "Possession.h"


@implementation Possession

@synthesize possessionName, serialNumber, valueInDollars, dateCreated, imageKey;
@synthesize thumbnail;

#pragma mark -
#pragma mark Memory Management
- (void) dealloc {
    self.possessionName = nil;
    [possessionName release];
    self.serialNumber = nil;
    [serialNumber release];
    [dateCreated release];
    self.imageKey = nil;
    [imageKey release];
    [thumbnailData release];
    [thumbnail release];
    [super dealloc];
}

#pragma mark -
#pragma mark Initializers
+(id)randomPossession {
/**
    static NSString *randomAdjectiveList[3] = {
        @"Fluffy", @"Rusty", @"Shiny"
    };
    static NSString *randomNounList[3] = {
        @"Bear", @"Spork", @"Mac"
    };
    NSString *randomName = [NSString stringWithFormat:@"%@ %@", randomAdjectiveList[random() % 3], randomNounList[random() % 3]];
    int randomValue = random() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + random() % 10,
                                    'A' + random() % 26,
                                    '0' + random() % 10,
                                    'A' + random() % 26,
                                    '0' + random() % 10];
**/
 Possession *newPossession = [[[self alloc] initWithPossessionName:@"New Item"
                                                     valueInDollars:0
                                                       serialNumber:@"Serial Number"] autorelease];
    return newPossession;
}

- (id)initWithPossessionName:(NSString *)pName valueInDollars:(NSInteger)value serialNumber:(NSString *)sNumber {
    self = [super init];
    if(self) {

        //initialize properties from parameters and set date value
        self.possessionName = pName;
        self.serialNumber = sNumber;
        self.valueInDollars = value;
        dateCreated = [[NSDate alloc] init];
    }    
    return self;
}

- (id)initWithPossessionName:(NSString *)pName {
    return [self initWithPossessionName:pName 
                         valueInDollars:0 
                           serialNumber:@""];
}

- (id)init {
    return [self initWithPossessionName:@"Possession" 
                         valueInDollars:0 
                           serialNumber:@""];
}

#pragma mark -
#pragma mark Overridden Methods
- (NSString *)description {
    NSString *descriptionString = [NSString stringWithFormat:@"%@ (%@): Worth $%d , Recorded on %@", self.possessionName, self.serialNumber, self.valueInDollars, self.dateCreated];
    return descriptionString;
}

#pragma mark -
#pragma mark NSCoding protocol methods
- (id) initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self) {
        self.possessionName = [decoder decodeObjectForKey:@"possessionName"];
        self.serialNumber = [decoder decodeObjectForKey:@"serialNumber"];
        self.valueInDollars = [decoder decodeIntForKey:@"valueInDollars"];
        self.imageKey = [decoder decodeObjectForKey:@"imageKey"];
        
        dateCreated = [[decoder decodeObjectForKey:@"dateCreated"] retain];
        
        thumbnailData = [[decoder decodeObjectForKey:@"thumbnailData"] retain];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.possessionName forKey:@"possessionName"];
    [encoder encodeObject:self.serialNumber forKey:@"serialNumber"];
    [encoder encodeInt:self.valueInDollars forKey:@"valueInDollars"];
    [encoder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [encoder encodeObject:self.imageKey forKey:@"imageKey"];
    
    [encoder encodeObject:thumbnailData forKey:@"thumbnailData"];
}

#pragma mark -
#pragma mark custom images
- (UIImage *)thumbnail {
    if(!thumbnailData) {
        return nil;
    }
    
    if(!thumbnail) {
        thumbnail = [[UIImage imageWithData:thumbnailData] retain];
    }
    return thumbnail;
}

- (void)setThumbnailDataFromImage:(UIImage *)image {
    [thumbnailData release];
    [thumbnail release];
    
    //create empty image 70px square
    CGRect imageRect = CGRectMake(0,0,70,70);
    UIGraphicsBeginImageContext(imageRect.size);
    
    //get original image and render in the current image context
    [image drawInRect:imageRect];
    
    thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    [thumbnail retain];
    UIGraphicsEndImageContext();
    
    thumbnailData = UIImagePNGRepresentation(image);
    [thumbnailData retain];
}
@end
