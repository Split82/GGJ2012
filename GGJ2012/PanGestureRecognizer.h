//
//  PanGestureRecognizer.h
//  GGJ2012
//
//  Created by Jan Ilavsky on 1/28/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

@interface PanGestureRecognizer : UIGestureRecognizer

@property (nonatomic, readonly) CGPoint translation;
@property (nonatomic, readonly) NSTimeInterval duration;

@end
