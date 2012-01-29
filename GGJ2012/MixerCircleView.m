//
//  MixerCircleView.m
//  GGJ2012
//
//  Created by Lukáš Foldýna on 28.01.12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "MixerCircleView.h"


@interface MixerCircleComponentView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation MixerCircleComponentView

@synthesize image = _image;
@synthesize imageView = _imageView;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
        [self addSubview:_imageView];
    }
    return self;
}

- (void) setImage:(UIImage *)image
{
    _image = image;
    [_imageView setImage:image];
    [_imageView setTransform:CGAffineTransformIdentity];
}

- (void) setContentMode:(UIViewContentMode)contentMode
{
    [super setContentMode:contentMode];
    
    if (contentMode == UIViewContentModeTopLeft) {
        [_imageView setFrame:CGRectOffset(_imageView.frame, 0.0, 0.0)];
    } else if (contentMode == UIViewContentModeTopRight) {
        [_imageView setFrame:CGRectOffset(_imageView.frame, 150.0, 0.0)];
    } else if (contentMode == UIViewContentModeBottomLeft) {
        [_imageView setFrame:CGRectOffset(_imageView.frame, 0.0, 150.0)];
    } else if (contentMode == UIViewContentModeBottomRight) {
        [_imageView setFrame:CGRectOffset(_imageView.frame, 150.0, 150.0)];
    }
}

- (void) setTransform:(CGAffineTransform)transform
{
    [super setTransform:transform];
    float radians = atan2(transform.b, transform.a);
    [_imageView setTransform:CGAffineTransformMakeRotation(-radians)];
}

@end



@interface MixerCircleView ()

- (NSString *) _stringForComponent:(int)component;

@end

@implementation MixerCircleView

@synthesize numbers = _numbers;
@synthesize background = _background;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setClipsToBounds:NO];
        
        CGRect bounds = [self bounds];
        _background = [[UIImageView alloc] initWithFrame:bounds];
        [_background setImage:[UIImage imageNamed:@"kolo_bg"]];
        [self addSubview:_background];
        
        for (int i = 0; i < 4; i++) {
            UIImageView *componentView = (id)[[MixerCircleComponentView alloc] initWithFrame:CGRectMake(50, 50, 200.0, 200.0)];
            [componentView setUserInteractionEnabled:NO];
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
  //  NSLog(@"changing views");
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

@end