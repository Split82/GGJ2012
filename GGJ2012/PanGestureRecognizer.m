//
//  PanGestureRecognizer.m
//  GGJ2012
//
//  Created by Jan Ilavsky on 1/28/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "PanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation PanGestureRecognizer {
    
    CGPoint startPosition;
}

@synthesize translation = _translation;


- (id)initWithTarget:(id)target action:(SEL)action {
    
    self = [super initWithTarget:target action:action];
    if (self) {
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    if (touch.view == self.view) {
        
        startPosition = [touch locationInView:touch.window];
        self.state = UIGestureRecognizerStateBegan;                
    }
    else {
        self.state = UIGestureRecognizerStateCancelled;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    self.state = UIGestureRecognizerStatePossible;  
    
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInView:touch.window];    
    _translation = ccpSub(position, startPosition);
    CGFloat y = _translation.x;
    _translation.x = -_translation.y;
    _translation.y = y;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    self.state = UIGestureRecognizerStateFailed; 
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {

    self.state = UIGestureRecognizerStateCancelled;  
}

- (void)reset {
    
    _translation = CGPointZero;
}

@end