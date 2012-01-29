//
//  CapsuleComponents.h
//  GGJ2012
//
//  Created by Jan Ilavsky on 1/29/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#ifndef GGJ2012_CapsuleComponents_h
#define GGJ2012_CapsuleComponents_h

typedef enum {
    CapsuleComponentTypeWater = 0,
    CapsuleComponentTypeEarth = 1,
    CapsuleComponentTypeWind = 2,
    CapsuleComponentTypeFire = 3
} CapsuleComponentType;

typedef struct {
    int component0;
    int component1;
    int component2;
} CapsuleComponents;

static inline CapsuleComponents CapsuleComponentsMake(int component0, int component1, int component2) {
    
    CapsuleComponents capsuleComponents;
    capsuleComponents.component0 = component0;
    capsuleComponents.component1 = component1;
    capsuleComponents.component2 = component2;
    return capsuleComponents;
}

#endif
