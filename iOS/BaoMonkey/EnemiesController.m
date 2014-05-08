//
//  EnemiesController.m
//  BaoMonkey
//
//  Created by Rémi Hillairet on 07/05/2014.
//  Copyright (c) 2014 BaoMonkey. All rights reserved.
//

#import "EnemiesController.h"
#import "LamberJack.h"
#import "GameData.h"

#define MIN_NEXT_ENEMY  2.0
#define MAX_NEXT_ENEMY  3.0

@implementation EnemiesController

@synthesize enemies;

-(id)initWithScene:(SKScene*)_scene {
    self = [super init];
    if (self) {
        enemies = [[NSMutableArray alloc] init];
        scene = _scene;
        timeForAddEnemy = 0;
        [self initChoppingSlots];
    }
    return self;
}

-(void)initChoppingSlots {
    choppingSlots = [[NSMutableArray alloc] init];
    CGFloat spaceDistance;
    
    SKSpriteNode *LBTmp = [SKSpriteNode spriteNodeWithImageNamed:@"lamberjack-left"];
    spaceDistance = LBTmp.size.width / 2 - 2;
    for (int i = 0; i < 3 ; i++) {
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"FREE", @"LEFT", @"FREE", @"RIGHT", [NSString stringWithFormat:@"%f", (spaceDistance + (spaceDistance * i))], @"posX", nil];
        [choppingSlots addObject:tmp];
    }
}

-(EnemyDirection)chooseDirection {
    NSUInteger numberLeft = 0;
    NSUInteger numberRight = 0;
    
    for (Enemy *enemy in enemies) {
        if (enemy.direction == LEFT)
            numberLeft++;
        else if (enemy.direction == RIGHT)
            numberRight++;
    }
    if (numberRight < numberLeft)
        return RIGHT;
    return LEFT;
}

-(void)addEnemy {
    LamberJack *newLamberJack;
    
    newLamberJack = [[LamberJack alloc] initWithDirection:[self chooseDirection]];

    [enemies addObject:newLamberJack];
    [scene addChild:newLamberJack.node];
}

-(void)updateEnemies:(CFTimeInterval)currentTime {
    
    if ([enemies count] < MAX_LUMBERJACK && ((timeForAddEnemy <= currentTime) || (timeForAddEnemy == 0))){
        float randomFloat = (MIN_NEXT_ENEMY + ((float)arc4random() / (0x100000000 / (MAX_NEXT_ENEMY - MIN_NEXT_ENEMY))));
        [self addEnemy];
        timeForAddEnemy = currentTime + randomFloat;
    }
    //NSLog(@"Update Enemies");
    for (Enemy *enemy in enemies) {
        [(LamberJack*)enemy updatePosition:choppingSlots];
        //NSLog(@"Enemy : x %f y %f", enemy.node.position.x, enemy.node.position.y);
    }
}

-(void)deleteEnemy:(Enemy*)enemy {
    SKAction *fadeIn = [SKAction fadeAlphaTo:0.0 duration:0.25];
    SKAction *sound = [SKAction playSoundFileNamed:@"coconut.mp3" waitForCompletion:NO];
    [enemy.node runAction:sound completion:^(void){
        [enemy.node runAction:fadeIn completion:^{
            [enemy.node removeFromParent];
        }];
    }];
    if (enemy.type == EnemyTypeLamberJack) {
        LamberJack *lamber;
        
        lamber = (LamberJack*)enemy;
        [lamber freeTheSlot:choppingSlots];
        [GameData addPointToScore:10];
    }
    [enemies removeObject:enemy];
}

@end
