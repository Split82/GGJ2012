//
//  MixerCircleView.h
//  GGJ2012
//
//  Created by Lukáš Foldýna on 27.01.12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Capsule.h"


typedef struct {
    int component00;
    int component01;
    int component10;
    int component11;
} MixerViewNumbers;


@class MixerCircleView;

@interface MixerView : UIView

- (id) initWithLeftComponent:(CapsuleComponents)leftComponent rightComponent:(CapsuleComponents)rigtComponent;

@property (nonatomic, assign) CapsuleComponents leftComponent;
@property (nonatomic, assign) CapsuleComponents rigtComponent;
- (void) setLeftComponent:(CapsuleComponents)leftComponent rightComponent:(CapsuleComponents)rigtComponent;

@property (nonatomic, readonly) MixerViewNumbers topPos;
@property (nonatomic, readonly) MixerViewNumbers bottomPos;

@property (nonatomic, strong) MixerCircleView *topCircleView;
@property (nonatomic, strong) MixerCircleView *bottomCircleView;

- (void) reset;

@property (nonatomic, strong) NSMutableArray *planViews;

@end
