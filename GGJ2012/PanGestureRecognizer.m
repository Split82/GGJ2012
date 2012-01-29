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
    NSTimeInterval startTime;
}

@synthesize translation = _translation;
@synthesize duration = _duration;


- (id)initWithTarget:(id)target action:(SEL)action {
    
    self = [super initWithTarget:target action:action];
    if (self) {
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    //NSLog(@"%@ - %@", touch.view, self.view);    
    if (touch.view == self.view) {
        
        startPosition = [touch locationInView:touch.window];
        self.state = UIGestureRecognizerStateBegan;       
        
        startTime = [NSDate timeIntervalSinceReferenceDate];
    }
    else {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    self.state = UIGestureRecognizerStateChanged;  
    
    _duration = [NSDate timeIntervalSinceReferenceDate] - startTime;
    
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInView:touch.window];    
    _translation = ccpSub(position, startPosition);
    CGFloat y = _translation.x;
    _translation.x = -_translation.y;
    _translation.y = y;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    _duration = [NSDate timeIntervalSinceReferenceDate] - startTime;    
    
    self.state = UIGestureRecognizerStateEnded;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {

    _duration = [NSDate timeIntervalSinceReferenceDate] - startTime;    
    
    self.state = UIGestureRecognizerStateCancelled;  
}

- (void)reset {
    
    _translation = CGPointZero;
    _duration = 0;
}

@end