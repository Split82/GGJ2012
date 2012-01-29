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

// array of NSNumber int
@property (nonatomic, assign) NSMutableArray *positions;

// array of NSDictionary {'direction' = 1 or -1, 'count' = 2}
@property (nonatomic, assign) NSMutableArray *steps;

@end
