//
//  HorizontalPickerView.m
//  GGJ2012
//
//  Created by Jan Ilavsky on 1/28/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "HorizontalPickerView.h"

#define DECELERATION 2000.0f

@interface HorizontalPickerView()

@property (nonatomic, assign) CGPoint contentOffset;

@end


@implementation HorizontalPickerView {
    
    CGSize contentSize;
    UIImageView *componentsImageView0;
    UIImageView *componentsImageView1;
    
    CGFloat startPanOffset;
    
    CADisplayLink *animationDisplayLink;

    CGFloat xOffsetAnimationDestination;
    CGFloat offsetX;
    CGFloat decelerating;
    CGFloat decelOrigin;
    CGFloat decelDelta;
    CGFloat velocity;
    CGFloat bounceTime;
    NSTimeInterval lastTime;
    
    NSTimeInterval lastPanTime;
}
@synthesize contentOffset = _contentOffset;

#pragma mark - Init

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {

        componentsImageView0 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PickerElements.png"]];
        componentsImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PickerElements.png"]];      
        
        contentSize = CGSizeMake(componentsImageView0.frame.size.width * 2, componentsImageView0.frame.size.height);
        
        [self addSubview:componentsImageView0];
        componentsImageView1.frame = CGRectOffset(componentsImageView0.frame, componentsImageView0.frame.size.width, 0);
        [self addSubview:componentsImageView1];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
        [self addGestureRecognizer:panGestureRecognizer];
    }
    return self;
}

#pragma mark - Setters

- (void)setBounds:(CGRect)bounds {

    [super setBounds:bounds];
    
    CGRect rect = componentsImageView0.frame;
    rect.origin.x = floorf(bounds.origin.x / rect.size.width) * rect.size.width;
    componentsImageView0.frame = rect;
    rect.origin.x += componentsImageView0.frame.size.width;
    componentsImageView1.frame = rect;
}

- (void)setContentOffset:(CGPoint)contentOffset {
    
    _contentOffset = contentOffset;
    
    CGRect rect = self.bounds;
    rect.origin = _contentOffset;
    self.bounds = rect;
}

#pragma mark - Animation

- (void)stopAnimation {
    
    if (animationDisplayLink) {
        [animationDisplayLink invalidate];
        animationDisplayLink = nil;
    }
}

- (void)animateToXOffset:(CGFloat)newXOffsetAnimationDestination {
    
    [self stopAnimation];
    
    xOffsetAnimationDestination = newXOffsetAnimationDestination;
    
    // Reset
    
    offsetX = self.contentOffset.x;
    decelerating = 0;
    decelOrigin = 0;
    decelDelta = 0;
    
    // Start new animations
    animationDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animate:)];
    [animationDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}
CGFloat easeOut(CGFloat time, CGFloat origin, CGFloat delta, CGFloat duration) {
    
    return (time >= duration) 
    ? origin + delta 
    : origin + delta * (1 - powf(2, -10 * (time / duration)));
}

- (void)calcAnimation:(NSTimeInterval)calcStep {
    
    if (decelerating == 0) {
        decelOrigin = offsetX;
        decelDelta = xOffsetAnimationDestination - offsetX;    
        
        bounceTime = 6.93174 * decelDelta / velocity;
    }
    
    decelerating += calcStep;    
    offsetX = easeOut(decelerating, decelOrigin, decelDelta, 0.6);
    
    
    if (decelerating >= bounceTime) {
        decelerating = 0;
        offsetX = xOffsetAnimationDestination;
        [self stopAnimation];
    }  
}

- (void)animate:(CADisplayLink *)sender {
    
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    
    // If first frame don't do anything
    if (lastTime < 0) {     
        lastTime = timestamp;
        return;
    }
    
    NSTimeInterval deltaTime = timestamp - lastTime;
    lastTime = timestamp;
    
    // Maximum deltaTime
    if (deltaTime > 0.4f) {
        deltaTime = 0.016f;
    }
    
    [self calcAnimation:deltaTime];
    
    CGPoint offset = self.contentOffset;
    offset.x = roundf(offsetX);
    [self setContentOffset:offset];
}

#pragma mark - GestureRecognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer*)panGestureRecognizer {
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        startPanOffset = self.contentOffset.x;
    }
    
    CGPoint translation = [panGestureRecognizer translationInView:self.superview];
    translation.x = startPanOffset - translation.x;    
    translation.y = 0;
    self.contentOffset = translation;
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        velocity = [panGestureRecognizer velocityInView:self.superview].x * 0.001f;
        NSLog(@"%f %f", velocity, ([NSDate timeIntervalSinceReferenceDate] - lastPanTime));
        if (fabs(velocity) > 1 && ([NSDate timeIntervalSinceReferenceDate] - lastPanTime) < 0.1) {
            [self animateToXOffset:self.contentOffset.x - velocity * 100];
        }
    }
    
    lastPanTime = [NSDate timeIntervalSinceReferenceDate];
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self stopAnimation];
}

@end
