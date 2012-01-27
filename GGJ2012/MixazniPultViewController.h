//
//  MixazniPultViewController.h
//  GGJ2012
//
//  Created by Lukáš Foldýna on 27.01.12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface MixazniPultViewController : UIView

@property (nonatomic, strong) NSObject *leftCapsule;
@property (nonatomic, strong) NSObject *rightCapsule;

@property (nonatomic, weak) id delegate;

@end
