//
//  MenuViewController.h
//  GGJ2012
//
//  Created by Lukáš Foldýna on 29.01.12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MenuViewController : UIViewController

@property (nonatomic, strong) UIViewController *gameController;
@property (nonatomic, strong) IBOutlet UIImageView *creditView;

- (IBAction) presentMenuViewController:(id)sender;

- (IBAction) presentCredits:(id)sender;
- (IBAction) hideCredits:(id)sender;

@end
