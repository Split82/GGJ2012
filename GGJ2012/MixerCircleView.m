//
//  MixerCircleView.m
//  GGJ2012
//
//  Created by Lukáš Foldýna on 28.01.12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "MixerCircleView.h"

@interface MixerCircleView ()

- (NSString *) _stringForComponent:(int)component;
- (void) rotationAnimation:(CADisplayLink *)displayLink;

@end

@implementation MixerCircleView {
    NSMutableArray *_componentViews;
    NSTimeInterval _prevTimespan;
    CGFloat _animateToRotation;
    CADisplayLink *_displayLink;
}

@synthesize numbers = _numbers;
@synthesize mode = _mode;
@synthesize background = _background;
@synthesize rotation = _rotation;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setClipsToBounds:NO];
        
        CGRect bounds = [self bounds];
        _background = [[UIImageView alloc] initWithFrame:bounds];
        [_background setImage:[UIImage imageNamed:@"kolo_bg"]];
        [self addSubview:_background];
        
        _mode = MixerCircleViewModesFull;
        
        _componentViews = [[NSMutableArray alloc] init];
        CGFloat offset = 50.0;
        CGFloat size = 50.0;
        
        for (int i = 0; i < 4; i++) {
            frame = CGRectMake((i == 0 || i == 2 ? offset : bounds.size.width - size - offset), 
                               (i < 2 ? offset : bounds.size.height - size - offset), size, size);
            UIImageView *componentView = [[UIImageView alloc] initWithFrame:frame];
            [componentView setTag:i + 1];
            [_componentViews addObject:componentView];
            [self addSubview:componentView];
        }
    }
    return self;
}

- (void) setNumbers:(MixerViewNumbers)numbers
{
    _numbers = numbers;
    [self setup];
}

- (void) setup
{
    int i = 0;
    for (UIImageView *componentView in _componentViews) {
        NSString *imageName = @"";
        
        switch (i) {
            case 0:
                imageName = [self _stringForComponent:_numbers.component00];
                break;
            case 1:
                imageName = [self _stringForComponent:_numbers.component01];
                break;
            case 2: 
                imageName = [self _stringForComponent:_numbers.component10];
                break;
            case 3:
                imageName = [self _stringForComponent:_numbers.component11];
                break;
        }
        [componentView setImage:[UIImage imageNamed:imageName]];
        [componentView setTransform:CGAffineTransformIdentity];
        i++;
    }
}

- (void) setMode:(MixerCircleViewModes)mode
{
    if (_mode == mode)
        return;
    _mode = mode;
    
    int i = 0;
    for (UIImageView *componentView in _componentViews) {
        if ((i < 2 && _mode == MixerCircleViewModesHideTop) || (i > 1 && _mode == MixerCircleViewModesHideBottom)) {
            [componentView setHidden:YES];
        } else {
            [componentView setHidden:NO];
        }
        i++;
    }
}

- (NSString *) _stringForComponent:(int)component
{
    switch (component) {
        case 0:
            return @"ohen";
            break;
        case 1:
            return @"vitr";
            break;
        case 2:
            return @"strom";
            break;
        case 3:
            return @"voda";
            break;
        case 4:
            return @"E";
            break;
        case 5:
        default:
            return @"F";
            break;
    }
}

- (void)setRotation:(CGFloat)rotation {
    
    _rotation = rotation;
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(_rotation);
    _background.transform = transform;
}

- (void) animateToRotation:(CGFloat)rotation
{
    _animateToRotation = rotation;
    
    [_displayLink invalidate];
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(rotationAnimation:)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void) rotationAnimation:(CADisplayLink *)displayLink
{
    NSTimeInterval  current = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval timespan = 0;

    if (_prevTimespan)
        timespan = current - _prevTimespan;
    
    int direction = (_animateToRotation > 0 ? 1 : -1);
    CGFloat angel = self.rotation * direction * timespan;
    
    if ((direction == 1 && angel > _animateToRotation) || (direction == -1 && angel < _animateToRotation)) {
        [displayLink invalidate];
    } else
        self.rotation = angel;
    _prevTimespan = current;
}

@end
