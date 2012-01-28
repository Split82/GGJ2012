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

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _mode = MixerCircleViewModesFull;
        
        for (int i = 0; i < 4; i++) {
            UILabel *componentView = [[UILabel alloc] initWithFrame:CGRectMake((i == 1 || i == 3 ? 90.0 : 10.0), 
                                                                               (i > 1 ? 90.0 : 10.0), 50.0, 50.0)];
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
        UILabel *componentView = [self.subviews objectAtIndex:i];
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
        UILabel *componentView = [self.subviews objectAtIndex:i];
        
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
