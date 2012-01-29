//
//  GameViewController.m
//  GGJ2012
//
//  Created by Jan Ilavsky on 1/26/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "GameViewController.h"
#import "cocos2d.h"
#import "MainGameScene.h"
#import "MixDesignerView.h"

@implementation GameViewController {
    
    MainGameScene *mainGameScene;
    
    
    __weak IBOutlet UIView *mixBuildingView;
    __weak IBOutlet UIView *lightBuildingView;
    
    IBOutlet MixDesignerView *mixDesignerView;
}

#pragma mark - Helpers

- (void)setupNotifications {
    
    // Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil]; 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];     
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];  
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationSignificantTimeChange:) name:UIApplicationSignificantTimeChangeNotification object:nil];       
}

- (void)removeNotifications {
    
    // Notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:UIApplicationDidBecomeActiveNotification object:nil]; 
    
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:UIApplicationDidEnterBackgroundNotification object:nil];     
    
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:UIApplicationWillEnterForegroundNotification object:nil];  
    
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:UIApplicationSignificantTimeChangeNotification object:nil];       
}

- (void)setupCocos2D {
    
    // CCDirector
    [CCDirector setDirectorType:kCCDirectorTypeDisplayLink];
	CCDirector *director = [CCDirector sharedDirector];
	[director setOpenGLView:(EAGLView*)self.view];
	[director setDeviceOrientation:kCCDeviceOrientationPortrait]; // Must be portrait if we support landscape in view controller
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:YES];    
    
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];    
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupNotifications];    
    [self setupCocos2D];

    // Main scene
    mainGameScene = [[MainGameScene alloc] initWithMainView:self.view addLightBuildingView:lightBuildingView addMixBuildingView:mixBuildingView];
    
	// Run main scene
	[[CCDirector sharedDirector] runWithScene:mainGameScene];   
}

- (void)viewDidUnload {
 
    mixDesignerView = nil;
    mixBuildingView = nil;
    lightBuildingView = nil;
    [super viewDidUnload];

    [self removeNotifications];
    
	[[CCDirector sharedDirector] end];    
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
	[[CCDirector sharedDirector] purgeCachedData];
}

#pragma mark - Application state changes

- (void)applicationWillResignActive:(UIApplication *)application {
    
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
	[[CCDirector sharedDirector] resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
    
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
    
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
    
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
    
	[[CCDirector sharedDirector] end];
}

#pragma mark - Actions

- (IBAction)segmentedControlViewValueChanged:(id)sender {
    
    UISegmentedControl *segmentedControl = (UISegmentedControl*)sender;
    switch (segmentedControl.selectedSegmentIndex) {
        case 1:
            mainGameScene.controlMode = ControlModeAddingMovers;
            break;
        case 2:
            mainGameScene.controlMode = ControlModeErasingMovers;
            break;
        default:
            mainGameScene.controlMode = ControlModePanning;            
            break;
    }

}

@end
