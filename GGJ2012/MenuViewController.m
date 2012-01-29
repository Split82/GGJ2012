//
//  MenuViewController.m
//  GGJ2012
//
//  Created by Lukáš Foldýna on 29.01.12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "MenuViewController.h"
#import "GameViewController.h"
#import "SimpleAudioEngine.h"
#import "AppDelegate.h"


@implementation MenuViewController

@synthesize creditView = _creditView;
@synthesize gameController = _gameController;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
    }
    return self;
}

#pragma mark - View lifecycle

- (void) viewDidUnload
{
    [super viewDidUnload];
    
    _creditView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{	
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark -

- (IBAction) presentMenuViewController:(id)sender
{
    //[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    UIWindow *window = [self.view window];
    
    if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] gameController] == nil) {
        _gameController = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] setGameController:(id)_gameController];   
    } else {
        _gameController = [(AppDelegate *)[[UIApplication sharedApplication] delegate] gameController];
    }
    [window setRootViewController:_gameController];
    [window addSubview:self.view];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void) {
                         [self.view setAlpha:0.0];
                     }
                     completion:^(BOOL finished) {
                         [self.view removeFromSuperview];
                     }];
}

- (IBAction) presentCredits:(id)sender
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void) {
                         [_creditView setAlpha:1.0];
                     }
                     completion:NULL];
}

- (IBAction) hideCredits:(id)sender
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void) {
                         [_creditView setAlpha:0.0];
                     }
                     completion:NULL];
}

@end
