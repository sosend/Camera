//
//  ItemsViewController.h
//  Homepwner
//
//  Created by Lisa Ridley on 3/28/11.
//  Copyright 2011 RoveWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemDetailViewController;
@class Possession;
@class HomepwnerItemCell;

@interface ItemsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
    
    ItemDetailViewController *detailViewController;
    UIView *headerView;
    NSMutableArray *possessions;
}
@property (nonatomic, retain) NSMutableArray *possessions;

- (UIView *)headerView;
@end
