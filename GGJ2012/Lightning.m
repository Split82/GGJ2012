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
static const float kGenerateNewInterval = 0.3f;
static const float kMiddlePointOffsetMul = 0.5f;

static const float kArcWidth = 20;

static const float kSegmentLength = 20.0f;

@implementation Lightning {
 
    CGPoint startPos;
    CGPoint endPos;
    
    
    float size;
    
    CGPoint *points;
    CGPoint *stripes;
    
    int pointsCount;
    
    ccTime elapsedTime;

}

@synthesize finished;

- (id)initWithStartPos:(CGPoint)initStartPos endPos:(CGPoint)initEndPos {
    
    self = [super init];
    
    if (self) {    
    
        finished =  NO;
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
    
    if (finished) return;
        
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisable(GL_TEXTURE_2D);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);

    //glColor4f(0.3f, 1.0f, 0.3f, 1.0f);
    //glVertexPointer(2, GL_FLOAT, 0, stripes);
    //glDrawArrays(GL_TRIANGLE_STRIP, 0, (pointsCount - 2) * 2 + 2);

    glLineWidth(MAX(size * 20, 1.0f));
    glColor4f(0.4f + size * 0.2f, 0.4f + size * 0.2f, 1.0f, 0.5f);
    glVertexPointer(2, GL_FLOAT, 0, points);
    glDrawArrays(GL_LINE_STRIP, 0, pointsCount);
    
    
    glLineWidth(1.0f);
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    glVertexPointer(2, GL_FLOAT, 0, points);
    glDrawArrays(GL_LINE_STRIP, 0, pointsCount);
    
    
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);

}


- (void)calc:(ccTime)dt {
    
    if (elapsedTime > kGenerateNewInterval) {

        finished = YES;
        [self removeFromParentAndCleanup:YES];
        return;
    }
    
    
    elapsedTime += dt;
    size = 1.0f - fabs(elapsedTime / kGenerateNewInterval * 2 - 1);
}

- (void)generate {
    
    
    if (points) {
        free(points);
        points = NULL;
    }

    float dx = (endPos.x - startPos.x);
    float dy = (endPos.y - startPos.y);
    
    float len = sqrtf(dx * dx + dy * dy);
    
    if (len == 0)
        return;
    
    dx /= len;
    dy /= len;
    
    pointsCount = MAX(2, (int)(len / kSegmentLength));
    //printf("%i %f \n", pointsCount, len);
    
    
    points = (CGPoint*)malloc(sizeof(CGPoint) * pointsCount);
    points[0] = startPos;
    points[pointsCount - 1] = endPos;
    
    
    
    for (int i = 1; i < pointsCount - 1; i++) {
        
        float t = (i + ((float)rand() / RAND_MAX * 2 - 1) * kMiddlePointOffsetMul) * len / (pointsCount - 1);
        points[i].x = startPos.x + t * dx;
        points[i].y = startPos.y + t * dy;
        
        t = ((float)rand() / RAND_MAX * 2 - 1) * kArcWidth;
        
        points[i].x += t * -dy;
        points[i].y += t * dx;
    }
    
    
}



- (void) onEnter {
    [super onEnter];
    
    [self schedule:@selector(calc:)];
}

- (void)destroy {
    
    if (points)
        free(points);
}

@end
