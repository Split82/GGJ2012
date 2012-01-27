//
//  MixazniPultViewController.m
//  GGJ2012
//
//  Created by Lukáš Foldýna on 27.01.12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "MixazniPultViewController.h"


@implementation MixazniPultViewController

@synthesize view = _view;

- (id) init
{
    self = [super init];
    
    if (self) {
        _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
    }
    return self;
}

@end
