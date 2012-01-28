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

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _background = [[UIImageView alloc] initWithFrame:self.bounds];
        [_background setImage:[UIImage imageNamed:@"MixerCircle"]];
        [self addSubview:_background];
        
        if (frame.origin.y > 40)
            [_background setTransform:CGAffineTransformMakeRotation(CC_DEGREES_TO_RADIANS(180))];
        
        _mode = MixerCircleViewModesFull;
        
        for (int i = 0; i < 4; i++) {
            UILabel *componentView = [[UILabel alloc] initWithFrame:CGRectMake((i == 0 || i == 2 ? 90.0 : 160.0), 
                                                                               (i < 2 ? 90.0 : 160.0), 50.0, 50.0)];
            [componentView setTag:i + 1];
            [componentView setBackgroundColor:[UIColor blueColor]];
            [componentView setTextColor:[UIColor whiteColor]];
            [componentView setFont:[UIFont boldSystemFontOfSize:16]];
            [componentView setTextAlignment:UITextAlignmentCenter];
            [self addSubview:componentView];
        }
    }
    return self;
}

- (void) setNumbers:(MixerViewNumbers)numbers
{
    _numbers = numbers;
    
    for (int i = 0; i < 4; i++) {
        UILabel *componentView = (id)[self viewWithTag:i + 1];
        NSString *text = @"";
        
        switch (i) {
            case 0:
                text = [self _stringForComponent:numbers.component00];
                break;
            case 1:
                text = [self _stringForComponent:numbers.component01];
                break;
            case 2: 
                text = [self _stringForComponent:numbers.component10];
                break;
            case 3:
                text = [self _stringForComponent:numbers.component11];
                break;
        }
        [componentView setText:text];
    }
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
            return @"A";
            break;
        case 1:
            return @"B";
            break;
        case 2:
            return @"C";
            break;
        case 3:
            return @"D";
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

@end
