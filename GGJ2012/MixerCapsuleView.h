//
//  MixerCapsuleView.h
//  GGJ2012
//
//  Created by Lukáš Foldýna on 28.01.12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Capsule.h"


@protocol MixerCapsuleViewDelegate;

@interface MixerCapsuleView : UIView

@property (nonatomic, assign) CapsuleComponents capsule;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, weak) id<MixerCapsuleViewDelegate> delegate;

@end


@protocol MixerCapsuleViewDelegate <NSObject>

@required
- (void) view:(MixerCapsuleView *)view didSetCapsule:(CapsuleComponents)capsule;

@end
