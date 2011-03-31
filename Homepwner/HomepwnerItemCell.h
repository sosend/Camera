//
//  HomepwnerItemCell.h
//  Homepwner
//
//  Created by Lisa Ridley on 3/30/11.
//  Copyright 2011 RoveWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Possession;

@interface HomepwnerItemCell : UITableViewCell {
    UILabel *valueLabel;
    UILabel *nameLabel;
    UIImageView *imageView;
}
- (void)setPossession:(Possession *)possession;
@end
