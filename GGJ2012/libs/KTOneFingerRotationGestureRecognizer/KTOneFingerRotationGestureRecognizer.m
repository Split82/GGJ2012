//
//  KTOneFingerRotationGestureRecognizer.m
//
//  Created by Kirby Turner on 4/22/11.
//  Copyright 2011 White Peak Software Inc. All rights reserved.
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "KTOneFingerRotationGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

#define MINIMUM_RADIUS 10

@implementation KTOneFingerRotationGestureRecognizer {
    
    CGFloat startRotation;
    BOOL startRotationSet;
}

@synthesize rotation = rotation_;

- (BOOL)canDetectRotationForTouchPoint:(CGPoint)touchPoint {
    
    CGRect bounds = self.view.bounds;
    CGPoint center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));    
    
    return (ccpLengthSQ(ccpSub(center, touchPoint)) > MINIMUM_RADIUS * MINIMUM_RADIUS);
}

- (CGFloat)rotationForTouchPoint:(CGPoint)touchPoint {
    
    if (![self canDetectRotationForTouchPoint:touchPoint]) {
        return 0;
    }
    
    CGRect bounds = self.view.bounds;
    CGPoint center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));      
    
    if (ccpLengthSQ(ccpSub(center, touchPoint)) > MINIMUM_RADIUS * MINIMUM_RADIUS) {
        
        return atan2f(touchPoint.y - center.y, touchPoint.x - center.x);       
    }
    
    return 0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
   if ([touches count] > 1 || ((UITouch*)[touches anyObject]).view != self.view) {

       self.state = UIGestureRecognizerStateFailed;
   }
   else {
       
       self.state = UIGestureRecognizerStateBegan;
       
       UITouch *touch = [touches anyObject];
       if ([self canDetectRotationForTouchPoint:[touch locationInView:self.view]]) {

           startRotation = [self rotationForTouchPoint:[touch locationInView:self.view]];
           startRotationSet = YES;
       }
   }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self setState:UIGestureRecognizerStateChanged];

    UITouch *touch = [touches anyObject];

    if (!startRotationSet) {
        
        if ([self canDetectRotationForTouchPoint:[touch locationInView:self.view]]) {
            
            startRotation = [self rotationForTouchPoint:[touch locationInView:self.view]];
            startRotationSet = YES;
        }        
    }

    if (startRotationSet && [self canDetectRotationForTouchPoint:[touch locationInView:self.view]] && [self canDetectRotationForTouchPoint:[touch previousLocationInView:self.view]]) {
        
        CGFloat deltaRotation = ([self rotationForTouchPoint:[touch locationInView:self.view]] - [self rotationForTouchPoint:[touch previousLocationInView:self.view]]);
        
        while (deltaRotation > M_PI) {
            
            deltaRotation -= 2 * M_PI;
        }
        while (deltaRotation < -M_PI) {
            
            deltaRotation += 2 * M_PI;
        }
        
        rotation_ += deltaRotation;
    }       
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.state = UIGestureRecognizerStateCancelled;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.state = UIGestureRecognizerStateCancelled;
}

- (void)reset {
    
    startRotationSet = NO;
    rotation_ = 0;
    startRotation = 0;
}

@end
