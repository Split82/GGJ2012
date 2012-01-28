//
//  MixazniPultViewController.h
//  GGJ2012
//
//  Created by Lukáš Foldýna on 27.01.12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Capsule.h"


@protocol MixazniPultDelegate;

@interface MixazniPultViewController : UIView

- (id) initWithLeftComponent:(CapsuleComponents)leftComponent rightComponent:(CapsuleComponents)rightComponent;
@property (nonatomic, weak) id<MixazniPultDelegate> delegate;

@end


@protocol MixazniPultDelegate <NSObject>

@required
- (void) viewController:(MixazniPultViewController *)controller leftCapsule:(CapsuleComponents)leftCapsule
           rightCapsule:(CapsuleComponents)rightCapsule;

@end
