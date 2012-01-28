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

@end

@implementation MixerCircleView

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
        
        //if (frame.origin.y > 40)
        //[_background setTransform:CGAffineTransformMakeRotation(CC_DEGREES_TO_RADIANS(180))];
        
        _mode = MixerCircleViewModesFull;
        
        for (int i = 0; i < 4; i++) {
            UIImageView *componentView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
            [componentView setTag:i + 1];
            
            if (i == 0)
                [componentView setContentMode:UIViewContentModeTopLeft];
            else if (i == 1)
                [componentView setContentMode:UIViewContentModeTopRight];
            else if (i == 2)
                [componentView setContentMode:UIViewContentModeBottomLeft];
            else if (i == 3)
                [componentView setContentMode:UIViewContentModeBottomRight];
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
    [UIView setAnimationsEnabled:NO];
    for (int i = 0; i < 4; i++) {
        UIImageView *componentView = (id)[self viewWithTag:i + 1];
        NSString *text = @"";
        
        switch (i) {
            case 0:
                text = [self _stringForComponent:_numbers.component00];
                break;
            case 1:
                text = [self _stringForComponent:_numbers.component01];
                break;
            case 2: 
                text = [self _stringForComponent:_numbers.component10];
                break;
            case 3:
                text = [self _stringForComponent:_numbers.component11];
                break;
        }
        [componentView setImage:[UIImage imageNamed:text]];
        [componentView setTransform:CGAffineTransformIdentity];
    }
    [UIView setAnimationsEnabled:YES];
}

- (void) setMode:(MixerCircleViewModes)mode
{
    if (_mode == mode)
        return;
    _mode = mode;
    
    for (int i = 0; i < 4; i++) {
        UILabel *componentView = (id)[self viewWithTag:i + 1];
        
        if ((i < 2 && _mode == MixerCircleViewModesHideTop) || (i > 1 && _mode == MixerCircleViewModesHideBottom)) {
            [componentView setHidden:YES];
        } else {
            [componentView setHidden:NO];
        }
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

@end
