//
//  Tile.h
//  GGJ2012
//
//  Created by Peter Hrincar on 1/27/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tile : NSObject

@property(nonatomic, assign) unsigned int gid;

- (id)initWithGID:(int)gid;

@end
