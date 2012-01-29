//
//  Lightning.h
//  GGJ2012
//
//  Created by Loki on 1/29/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "CCNode.h"

@interface Lightning : CCNode

    @property (nonatomic, assign) BOOL finished;
    


- (void)draw;
- (id)initWithStartPos:(CGPoint)initStartPos endPos:(CGPoint)initEndPos;

- (void)calc:(ccTime)dt;

- (void)generate;

@end
