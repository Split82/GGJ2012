//
//  Lightning.m
//  GGJ2012
//
//  Created by Loki on 1/29/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "Lightning.h"

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/EAGL.h>


static const float kUpdateInterval = 0.1f;
static const float kGenerateNewInterval = 1.0f;
static const float kMiddlePointOffsetMul = 0.3f;

static const int kMaxPointsCount = 10;

@implementation Lightning {
 
    CGPoint startPos;
    CGPoint endPos;
    
    
    float size;
    
    CGPoint *points;
    CGPoint *stripes;
    
    int pointsCount;
    
    ccTime elapsedTime;

}



- (id)initWithStartPos:(CGPoint)initStartPos endPos:(CGPoint)initEndPos {
    
    self = [super init];
    
    if (self) {    
    
        points = NULL;
        pointsCount = 0;
        
        elapsedTime = 0;
        startPos = initStartPos;
        endPos = initEndPos;
        
        
        
        [self generate];
    }
    
    return  self;
}

- (void)draw {
    
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisable(GL_TEXTURE_2D);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);

    //glColor4f(0.3f, 1.0f, 0.3f, 1.0f);
    //glVertexPointer(2, GL_FLOAT, 0, stripes);
    //glDrawArrays(GL_TRIANGLE_STRIP, 0, (pointsCount - 2) * 2 + 2);
    
    glLineWidth(1.0f);
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    glVertexPointer(2, GL_FLOAT, 0, points);
    glDrawArrays(GL_LINE_STRIP, 0, pointsCount);
    
    
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);

}


- (void)calc:(ccTime)dt {

    elapsedTime += dt;
    
    
    if (elapsedTime > kGenerateNewInterval) {
        elapsedTime -= kGenerateNewInterval;
        
        [self generate];
    }
    
}

- (void)generate {
    
    pointsCount = kMaxPointsCount;
    
    if (points) {
        free(points);
        points = NULL;
    }
    
    points = (CGPoint*)malloc(sizeof(CGPoint) * pointsCount);
    points[0] = startPos;
    points[pointsCount - 1] = endPos;
    
    
    float dx = (endPos.x - startPos.x) / (pointsCount - 1);
    float dy = (endPos.y - startPos.y) / (pointsCount - 1);
    
    //float len = sqrtf(dx * dx + dy * dy);
    
    
    for (int i = 1; i < pointsCount - 1; i++) {
        
        float t = (i + ((float)rand() / RAND_MAX * 2 - 1) * kMiddlePointOffsetMul);
        points[i].x = startPos.x + t * dx;
        points[i].y = startPos.y + t * dy;
    }
    
    
}



- (void) onEnter {
    [super onEnter];
    
    [self schedule:@selector(calc:) interval:kUpdateInterval];
}

- (void)destroy {
    
    if (points)
        free(points);
}

@end
