//
//  MenuViewController.m
//  GGJ2012
//
//  Created by Lukáš Foldýna on 29.01.12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "MenuViewController.h"
#import "GameViewController.h"


@implementation MenuViewController

@synthesize gameController = _gameController;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
        _gameController = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
        [_gameController view];
    }
    return self;
}

- (void) didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark -

- (IBAction) presentMenuViewController:(id)sender
{
    UIWindow *window = [self.view window];
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
    
}

@end
