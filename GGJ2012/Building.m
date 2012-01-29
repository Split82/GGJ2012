//
//  Building.m
//  GGJ2012
//
//  Created by Peter Hrincar on 1/27/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "Building.h"
#import "MineBuilding.h"
#import "TowerBuilding.h"
#import "MixerBuilding.h"
#import "Tile.h"
#import "MapModel.h"

@implementation Building

@synthesize gid;
@synthesize gridPos;
@synthesize light;
@synthesize lightRadius;
@synthesize lightOn;
@synthesize centerForLight;
@synthesize health;
@synthesize destroyable;

+ (Building*)createBuildingFromGID:(unsigned int)gid andGridPos:(CGPoint)pos {
    switch (gid) {

        case TileTypeBuildingTowerDark:
        case TileTypeBuildingTower:
            return [[TowerBuilding alloc] initWithGID:gid andGridPos:pos];
            break;
            
        case TileTypeBuildingMixer:
            return [[MixerBuilding alloc] initWithGID:gid andGridPos:pos];
            
        case TileTypeBuildingMine:
            return [[MineBuilding alloc] initWithGID:gid andGridPos:pos];
            break;
            
        default:
            return nil;
            break;
    }

}

-(id)initWithGID:(unsigned int)initGID andGridPos:(CGPoint)initGridPos {
    if (self=[super init])  {	
        gid = initGID;
        gridPos = initGridPos;
        centerForLight = ccpAdd(ccp(2,-2), initGridPos);
    }
    return self;    
}

- (void)switchLight {
    if (!self.lightOn) {
        [[MapModel sharedMapModel] updateLightForTiles:CGRectMake(centerForLight.x - self.lightRadius, centerForLight.y - self.lightRadius, 2*(self.lightRadius), 2*(self.lightRadius )) light:self.light radius:self.lightRadius];
        
        [[MapModel sharedMapModel] updateLightForGridRect:CGRectMake(centerForLight.x - self.lightRadius - 1, centerForLight.y - self.lightRadius - 1, 2*(self.lightRadius + 1), 2*(self.lightRadius + 1))];
        self.lightOn = YES;
    }
    else  {
        self.lightOn = NO;
        [[MapModel sharedMapModel] updateLightForTiles:CGRectMake(self.gridPos.x - self.lightRadius, self.gridPos.y - self.lightRadius, 2*(self.lightRadius), 2*(self.lightRadius )) light:-self.light radius:self.lightRadius];
        
        [[MapModel sharedMapModel] updateLightForGridRect:CGRectMake(self.gridPos.x - self.lightRadius - 1, self.gridPos.y - self.lightRadius - 1, 2*(self.lightRadius + 1), 2*(self.lightRadius + 1))];
    }
}

- (BOOL)isFreeAtGridPos:(CGPoint)atGridPos {
    //TODO
    return !(CGPointEqualToPoint(self.gridPos, atGridPos));
                                                   
}

- (void)hitWithDamage:(CGFloat)damage {
    if (destroyable) {
        health = health - damage;
        
        if (health <= 0.0) {
            // TODO remove 
            health = 100.0;
        }
    }
}
@end
