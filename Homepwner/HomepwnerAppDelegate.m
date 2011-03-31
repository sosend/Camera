//
//  HomepwnerAppDelegate.m
//  Homepwner
//
//  Created by Lisa Ridley on 3/28/11.
//  Copyright 2011 RoveWorks. All rights reserved.
//

#import "HomepwnerAppDelegate.h"

@implementation HomepwnerAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{        
    NSLog(@"Calling HompwnerAppDelegate::application:didFinishLaunchingWithOptions:");
    NSString *possessionPath = [self possessionArrayPath];
    
    NSMutableArray *possessionArray = [NSKeyedUnarchiver unarchiveObjectWithFile:possessionPath];
    
    if(!possessionArray) possessionArray = [NSMutableArray array];
    
    // Override point for customization after application launch.
    itemsViewController = [[ItemsViewController alloc]init];
    
    [itemsViewController setPossessions:possessionArray];
    
    navController = [[UINavigationController alloc] initWithRootViewController:itemsViewController];

    [self.window addSubview:[navController view]];
    [self.window makeKeyAndVisible];


    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
   NSLog(@"Calling HompwnerAppDelegate::applicationWillResignActive:");
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{   
    NSLog(@"Calling HompwnerAppDelegate::applicationDidEnterBackground:");
    NSString *possessionPath = [self possessionArrayPath];
    NSMutableArray *possessionArray = [itemsViewController possessions];
    [NSKeyedArchiver archiveRootObject:possessionArray toFile:possessionPath];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"Calling HompwnerAppDelegate::applicationWillEnterForeground:");
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"Calling HompwnerAppDelegate::applicationDidBecomeActive:");
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"Calling HompwnerAppDelegate::applicationWillTerminate:");
    NSString *possessionPath = [self possessionArrayPath];
    NSMutableArray *possessionArray = [itemsViewController possessions];
    [NSKeyedArchiver archiveRootObject:possessionArray toFile:possessionPath];
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    NSLog(@"Calling HompwnerAppDelegate::applicationDidReceiveMemoryWarning:");
}
- (void)dealloc
{
    NSLog(@"Calling HompwnerAppDelegate::dealloc");
//    itemsViewController = nil;
    [itemsViewController release];
    [navController release];
    [_window release];
    [super dealloc];
}

- (NSString *)possessionArrayPath {
    NSLog(@"Calling HompwnerAppDelegate::possessionArrayPath");
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Possessions.data"];
}
@end
