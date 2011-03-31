//
//  HomepwnerAppDelegate.h
//  Homepwner
//
//  Created by Lisa Ridley on 3/28/11.
//  Copyright 2011 RoveWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemsViewController.h"

@interface HomepwnerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ItemsViewController *itemsViewController;
    UINavigationController *navController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (NSString *)possessionArrayPath;

@end
