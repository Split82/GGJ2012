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
    CapsuleComponentTypeEmpty = 0,
    CapsuleComponentTypeWater = 1,
    CapsuleComponentTypeEarth = 2,
    CapsuleComponentTypeWind = 3,
    CapsuleComponentTypeFire = 4
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
