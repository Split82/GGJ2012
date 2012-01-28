//
//  MixerCircleView.h
//  GGJ2012
//
//  Created by Lukáš Foldýna on 28.01.12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef struct {
    int component00;
    int component01;
    int component10;
    int component11;
} MixerViewNumbers;


typedef enum {
    MixerCircleViewModesFull = 0,
    MixerCircleViewModesHideTop,
    MixerCircleViewModesHideBottom,
} MixerCircleViewModes;


@interface MixerCircleView : UIControl

@property (nonatomic, assign) MixerViewNumbers numbers;
@property (nonatomic, assign) MixerCircleViewModes mode;

@end