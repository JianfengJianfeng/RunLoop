//
//  AppDelegate.m
//  RunLoop
//
//  Created by JianfengXu on 2019/11/9.
//  Copyright © 2019 JianfengXu. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"//RunLoop处理Timer事件
#import "ViewController1.h"//RunLoop处理Source事件
#import "ViewController2.h"//Runloop处理Observe事件

@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    ViewController2 *mainVC = [[ViewController2 alloc] init];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = mainVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}



@end
