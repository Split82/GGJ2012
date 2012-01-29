//
//  MixerCircleView.h
//  GGJ2012
//
//  Created by Lukáš Foldýna on 28.01.12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixerView.h"


@interface MixerCircleView : UIView

- (void) setup;

@property (nonatomic, assign) MixerViewNumbers numbers;
@property (nonatomic, strong) UIImageView *background;

@end