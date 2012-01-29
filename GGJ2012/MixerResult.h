//
//  MixerResult.h
//  GGJ2012
//
//  Created by Lukáš Foldýna on 29.01.12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Capsule.h"


@interface MixerResult : NSObject

@property (nonatomic, assign) CapsuleComponents leftInput;
@property (nonatomic, assign) CapsuleComponents rightInput;

@property (nonatomic, assign) CapsuleComponents leftOutput;
@property (nonatomic, assign) CapsuleComponents rightOutput;

@property (nonatomic, assign) NSMutableArray *positions;
@property (nonatomic, assign) NSMutableArray *steps;

@end
