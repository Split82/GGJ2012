//
//  MixerPlanView.h
//  GGJ2012
//
//  Created by Lukáš Foldýna on 28.01.12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MixerPlanView : UIButton

@property (nonatomic, assign) NSInteger steps;
@property (nonatomic, assign) int direction;
@property (nonatomic, assign) BOOL topView;

@end
