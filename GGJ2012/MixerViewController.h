//
//  MixazniPultViewController.h
//  GGJ2012
//
//  Created by Lukáš Foldýna on 27.01.12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "Capsule.h"

@protocol MixerViewControllerDelegate;

@interface MixerViewController : UIControl

- (id) initWithLeftComponent:(CapsuleComponents)leftComponent rightComponent:(CapsuleComponents)rightComponent;
@property (nonatomic, weak) id<MixerViewControllerDelegate> delegate;

@end


@protocol MixerViewControllerDelegate <NSObject>

@required
- (void) viewController:(MixerViewController *)controller leftCapsule:(CapsuleComponents)leftCapsule
           rightCapsule:(CapsuleComponents)rightCapsule;

@end
