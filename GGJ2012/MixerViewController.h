//
//  MixazniPultViewController.h
//  GGJ2012
//
//  Created by Lukáš Foldýna on 27.01.12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "Capsule.h"
#import "MixerResult.h"


@protocol MixerViewControllerDelegate;

@interface MixerViewController : UIControl

- (id) initWithResult:(MixerResult *)result;
@property (nonatomic, weak) id<MixerViewControllerDelegate> delegate;
@property (nonatomic, strong) MixerResult *result;

@end


@protocol MixerViewControllerDelegate <NSObject>

@required
- (void) viewController:(MixerViewController *)controller result:(MixerResult *)result;

@end
