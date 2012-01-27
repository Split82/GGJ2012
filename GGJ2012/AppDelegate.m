//
//  AppDelegate.m
//  GGJ2012
//
//  Created by Jan Ilavsky on 1/26/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "AppDelegate.h"
#import "GameViewController.h"

@implementation AppDelegate {

    UIWindow *window;
}

- (void) applicationDidFinishLaunching:(UIApplication*)application {

	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
    GameViewController *gameViewController = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
    [window setRootViewController:gameViewController];
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
