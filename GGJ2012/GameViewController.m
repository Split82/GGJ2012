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
#import "MixerViewController.h"


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

- (void) presentMixerViewController
{    
    CapsuleComponents component1;
    component1.component0 = 0;
    component1.component1 = 0;
    component1.component2 = 0;
    
    CapsuleComponents component2;
    component2.component0 = 1;
    component2.component1 = 1;
    component2.component2 = 1;
    
    UIView *masterView = [[UIControl alloc] initWithFrame:self.view.bounds];
    [masterView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:masterView];
    
    MixerViewController *controller = [[MixerViewController alloc] initWithLeftComponent:component1
                                                                          rightComponent:component2];
    __block CGRect frame = [controller frame];
    frame.origin.x = floorf((self.view.bounds.size.width - frame.size.width) / 2), 
    frame.origin.y = self.view.bounds.size.height;
    [controller setFrame:frame];
    [masterView addSubview:controller];
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void) {
                         [masterView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
                         
                         frame.origin.y = floorf((self.view.bounds.size.height - frame.size.height) / 2);
                         [controller setFrame:frame];
                     }
                     completion:NULL];
}

#pragma mark - Actions

- (IBAction)segmentedControlViewValueChanged:(id)sender {
    
    UISegmentedControl *segmentedControl = (UISegmentedControl*)sender;
    switch (segmentedControl.selectedSegmentIndex) {
        case 1:
            mainGameScene.controlMode = ControlModeAddingMovers;
            break;
        case 3:
            [self presentMixerViewController];
            break;
        default:
            mainGameScene.controlMode = ControlModePanning;            
            break;
    }

}

@end
