//
//  MixerCircleView.h
//  GGJ2012
//
//  Created by Lukáš Foldýna on 27.01.12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Capsule.h"


@class MixerCircleView;

@interface MixerView : UIView

- (id) initWithLeftComponent:(CapsuleComponents)leftComponent rightComponent:(CapsuleComponents)rigtComponent;

@property (nonatomic, assign) CapsuleComponents leftComponent;
@property (nonatomic, assign) CapsuleComponents rigtComponent;
- (void) setLeftComponent:(CapsuleComponents)leftComponent rightComponent:(CapsuleComponents)rigtComponent;

@property (nonatomic, strong) MixerCircleView *topCircleView;
@property (nonatomic, strong) MixerCircleView *bottomCircleView;

- (void) reset;

@end
