//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by Lisa Ridley on 3/30/11.
//  Copyright 2011 RoveWorks. All rights reserved.
//

#import "HomepwnerItemCell.h"
#import "Possession.h"

@implementation HomepwnerItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //Create a subview
        valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        //add to contentView of the cell
        [[self contentView] addSubview:valueLabel];
        [valueLabel release];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [[self contentView] addSubview:nameLabel];
        [nameLabel release];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [[self contentView] addSubview:imageView];
        //resize to fit inside table row frame -- changes when cell rotates
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    float inset = 5.0;
    //get bounds of the contentView
    CGRect bounds = [[self contentView] bounds];
    
    float h = bounds.size.height;
    float w = bounds.size.width;
    float valueWidth = 40.0;
    
    //set frame for subviews relative to contentView's bounds
    CGRect innerFrame = CGRectMake(inset, inset, h, h - inset * 2.0);
    [imageView setFrame:innerFrame];
    
    innerFrame.origin.x += innerFrame.size.width + inset;
    innerFrame.size.width = w - (h + valueWidth + inset * 4);
    [nameLabel setFrame:innerFrame];
    
    innerFrame.origin.x += innerFrame.size.width + inset;
    innerFrame.size.width = valueWidth;
    [valueLabel setFrame:innerFrame];
}

- (void)setPossession:(Possession *)possession {
    [valueLabel setText:[NSString stringWithFormat:@"$%d", 
                         [possession valueInDollars]]];
    [nameLabel setText:[possession possessionName]];
    [imageView setImage:[possession thumbnail]];
}

@end
