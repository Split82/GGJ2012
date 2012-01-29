//
//  AppDelegate.m
//  GGJ2012
//
//  Created by Jan Ilavsky on 1/26/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "AppDelegate.h"
#import "GameViewController.h"
#import "MenuViewController.h"

@implementation AppDelegate {

    UIWindow *window;
}

- (void) applicationDidFinishLaunching:(UIApplication*)application {

	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
    UIViewController *controller = nil;
    
    controller = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
    //controller = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
    [window setRootViewController:controller];
    [window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
    
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {

}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
    
}

@end
